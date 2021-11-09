
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	//Volanie podprogramov//
	OvladanieZdvihu;
	
	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_ZdvihRotora);
	
	//Reset sekcie //
	IF ZdvihRotora_Reset OR NOT BezpOkruhOplotenia_Aktivovany OR PoruchaZdvihuRotora THEN
		SC_ZdvihRotora.Step:= 0;
	END_IF
	
	
	
	
	CASE SC_ZdvihRotora.Step OF 
	
	
		0:
			SC_ZdvihRotora.StepName:='0 - Nulovanie';
			SC_OvlZdvihu.Step:= 0;
			ZdvihRotora_Automat:= FALSE;
			ZdvihRotora_KoniecVyroby:= FALSE;
			ZdvihRotora_KoniecCyklu:= FALSE;
			ZdvihRotora_Manual:= FALSE;
			ZdvihRotora_PoINIT:= FALSE;
			ZdvihRotora_Reset:= FALSE;
			IF BezpOkruhOplotenia_Aktivovany AND NOT PoruchaZdvihuRotora THEN
				SC_ZdvihRotora.ResetStep:= TRUE;
				SC_ZdvihRotora.Step:= 1;
			END_IF
	
		1:
			SC_ZdvihRotora.StepName:='1 - Rozhodnutie o cinnosti';
			IF ZdvihRotora_Automat THEN
				SC_ZdvihRotora.Step:= 2;
			ELSIF ZdvihRotora_Manual THEN
				SC_ZdvihRotora.Step:= 700;
			END_IF
		
		
			//********************************************************Inicializácia****************************************************************************//
	 
			
	
		2:
			SC_ZdvihRotora.StepName:='2 - Inicializacia - cakanie na spustenie';
			SC_ZdvihRotora.IdleTime.PT:= T#500ms;
			SC_ZdvihRotora.AlarmTime.PT:= T#5s;
			SC_ZdvihRotora.IdleTime.IN:= TRUE;
				
			
			IF SC_ZdvihRotora.IdleTime.Q THEN
				SC_ZdvihRotora.ResetStep:= TRUE;
				SC_ZdvihRotora.Step:= 3;
			END_IF
			
		3:
			SC_ZdvihRotora.StepName:='3 - Inicializacia - rozhodnutie o ukonceni inicializacie';
			SC_ZdvihRotora.IdleTime.PT:= T#500ms;
			SC_ZdvihRotora.AlarmTime.PT:= T#5s;
			
			IF diVstupDopr_ZdvihRotora_DOLE AND NOT diVstupDopr_ZdvihRotora_HORE THEN
				ZdvihRotora_PoINIT:= TRUE;
				SC_ZdvihRotora.ResetStep:= TRUE;
				SC_ZdvihRotora.Step:= 100;
			ELSIF diVstupDopr_ZdvihRotora_HORE AND NOT diVstupDopr_ZdvihRotora_DOLE AND diVstupDopr_PritomnostRotora THEN
				ZdvihRotora_PoINIT:= TRUE;
				SC_ZdvihRotora.ResetStep:= TRUE;
				SC_ZdvihRotora.Step:= 101;
			ELSIF diVstupDopr_ZdvihRotora_HORE AND NOT diVstupDopr_ZdvihRotora_DOLE AND NOT diVstupDopr_PritomnostRotora THEN
				SC_ZdvihRotora.ResetStep:= TRUE;
				SC_ZdvihRotora.Step:= 4;	
			ELSE
				Alarmy[17]:= TRUE;
				PoruchaZdvihuRotora:= TRUE;
			END_IF	
		
		
		4:
			SC_ZdvihRotora.StepName:='3 - Inicializacia - zasunutie zdvihu dole';
			SC_ZdvihRotora.IdleTime.PT:= T#500ms;
			SC_ZdvihRotora.AlarmTime.PT:= T#5s;
			
			IF NOT SC_ZdvihRotora.Switch1 THEN
				PolozRotor:= TRUE;
				SC_ZdvihRotora.Switch1:= TRUE;
			END_IF
		
			IF diVstupDopr_ZdvihRotora_DOLE THEN
				ZdvihRotora_PoINIT:= TRUE;
				SC_ZdvihRotora.ResetStep:= TRUE;
				SC_ZdvihRotora.Step:= 100;
			END_IF
			
		
			
			//********************************************************Automatický režim****************************************************************************//
		100:
			SC_ZdvihRotora.StepName:='100 - Automaticky rezim - cakanie na zdvihnutie rotora';
			SC_ZdvihRotora.IdleTime.PT:= T#200ms;
			SC_ZdvihRotora.AlarmTime.PT:= T#5s;	
			
			IF diVstupDopr_PritomnostRotora THEN
				SC_ZdvihRotora.IdleTime.IN:= TRUE;
			ELSE	
				SC_ZdvihRotora.IdleTime.IN:= FALSE;
			END_IF
		
			IF SC_ZdvihRotora.IdleTime.Q AND NOT SC_ZdvihRotora.Switch1 THEN
				ZdvihniRotor:= TRUE;
				SC_ZdvihRotora.Switch1:= TRUE;
			END_IF
		
			IF diVstupDopr_ZdvihRotora_HORE THEN
				SC_ZdvihRotora.ResetStep:= TRUE;
				SC_ZdvihRotora.Step:= 101;
			END_IF
		
			IF ZdvihRotora_KoniecCyklu AND NOT VstupManipulator_Automat THEN
				SC_ZdvihRotora.ResetStep:= TRUE;
				SC_ZdvihRotora.Step:= 0;
			END_IF
			
			IF ZdvihRotora_KoniecVyroby AND NOT VstupManipulator_Automat THEN
				SC_ZdvihRotora.ResetStep:= TRUE;
				SC_ZdvihRotora.Step:= 0;
			END_IF
			
		101:
			SC_ZdvihRotora.StepName:='101 - Automaticky rezim - cakanie na odobratie rotora';
			SC_ZdvihRotora.IdleTime.PT:= T#200ms;
			SC_ZdvihRotora.AlarmTime.PT:= T#5s;	
			
			IF NOT diVstupDopr_PritomnostRotora THEN
				SC_ZdvihRotora.IdleTime.IN:= TRUE;
			ELSE	
				SC_ZdvihRotora.IdleTime.IN:= FALSE;
			END_IF
		
			IF SC_ZdvihRotora.IdleTime.Q AND NOT SC_ZdvihRotora.Switch1 THEN
				PolozRotor:= TRUE;
				SC_ZdvihRotora.Switch1:= TRUE;
			END_IF
		
			IF diVstupDopr_ZdvihRotora_DOLE THEN
				SC_ZdvihRotora.ResetStep:= TRUE;
				SC_ZdvihRotora.Step:= 100;
			END_IF
			
			IF ZdvihRotora_KoniecCyklu AND NOT VstupManipulator_Automat THEN
				SC_ZdvihRotora.ResetStep:= TRUE;
				SC_ZdvihRotora.Step:= 0;
			END_IF
		
			IF ZdvihRotora_KoniecVyroby AND NOT VstupManipulator_Automat THEN
				SC_ZdvihRotora.ResetStep:= TRUE;
				SC_ZdvihRotora.Step:= 0;
			END_IF
		
		
		
		
		
			//********************************************************Ruèný režim***********************************************************************************//
		700:
			SC_ZdvihRotora.StepName:='700 - Rucny rezim';
			
			
			
	END_CASE		
			
				END_PROGRAM

PROGRAM _EXIT
				(* Insert code here *)
	 
				END_PROGRAM

