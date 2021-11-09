
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	
	//Volanie podprogramov//
	OvladanieOddelovaca;
	
	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_Oddelovac);
	
	//Reset sekcie //
	IF Oddelovac_Reset OR NOT BezpOkruhOplotenia_Aktivovany OR PoruchaOddelovaca THEN
		SC_Oddelovac.Step:= 0;
	END_IF
	
	
	
	
	CASE SC_Oddelovac.Step OF 
	
	
		0:
			SC_Oddelovac.StepName:='0 - Nulovanie';
			SC_OvlOddelovaca.Step:= 0;
			Oddelovac_Automat:= FALSE;
			Oddelovac_KoniecVyroby:= FALSE;
			Oddelovac_KoniecCyklu:= FALSE;
			Oddelovac_Manual:= FALSE;
			Oddelovac_PoINIT:= FALSE;
			Oddelovac_Reset:= FALSE;
			IF BezpOkruhOplotenia_Aktivovany AND NOT PoruchaOddelovaca THEN
				SC_Oddelovac.ResetStep:= TRUE;
				SC_Oddelovac.Step:= 1;
			END_IF
	
		1:
			SC_Oddelovac.StepName:='1 - Rozhodnutie o cinnosti';
			IF Oddelovac_Automat THEN
				SC_Oddelovac.Step:= 2;
			ELSIF Oddelovac_Manual THEN
				SC_Oddelovac.Step:= 700;
			END_IF
		
		
		//********************************************************Inicializácia****************************************************************************//
	
		2:
			SC_Oddelovac.StepName:='2 - Inicializacia - cakanie na spustenie';
			SC_Oddelovac.IdleTime.PT:= T#500ms;
			SC_Oddelovac.AlarmTime.PT:= T#5s;
			SC_Oddelovac.IdleTime.IN:= TRUE;
				
			
			IF SC_Oddelovac.IdleTime.Q THEN
				SC_Oddelovac.ResetStep:= TRUE;
				SC_Oddelovac.Step:= 3;
			END_IF
	
		3:
			SC_Oddelovac.StepName:='3 - Inicializacia - rozhodnutie o preklopeni';
			SC_Oddelovac.IdleTime.PT:= T#500ms;
			SC_Oddelovac.AlarmTime.PT:= T#5s;
		
			IF NOT diOddelovac_PoziciaNavazanie AND NOT diOddelovac_PritomnostRotora THEN
				SC_Oddelovac.ResetStep:= TRUE;
				SC_Oddelovac.Step:= 4;
			ELSIF diOddelovac_PoziciaNavazanie THEN
				Oddelovac_PoINIT:= TRUE;
				SC_Oddelovac.ResetStep:= TRUE;
				SC_Oddelovac.Step:= 100;
			END_IF
		
		4:
			SC_Oddelovac.StepName:='4 - Inicializacia - preklopenie do navazacej pozicie';
			SC_Oddelovac.IdleTime.PT:= T#500ms;
			SC_Oddelovac.AlarmTime.PT:= T#5s;
		
			IF NOT SC_Oddelovac.Switch1 THEN
				Oddelovac_NAVAZANIE:= TRUE;
				SC_Oddelovac.Switch1:= TRUE;
			END_IF
		
			IF diOddelovac_PoziciaNavazanie THEN
				Oddelovac_PoINIT:= TRUE;
				SC_Oddelovac.ResetStep:= TRUE;
				SC_Oddelovac.Step:= 100;
			END_IF
		
		
		
		
		//********************************************************Automatický režim****************************************************************************//
		100:
			SC_Oddelovac.StepName:='100 - Automaticky rezim - cakanie na preklopenie do vyvazacej pozicie';
			SC_Oddelovac.IdleTime.PT:= T#500ms;
			SC_Oddelovac.AlarmTime.PT:= T#5s;
		
			IF diOddelovac_PritomnostRotora AND NOT diVstupDopr_PritomnostRotora AND (diVstupManipul_ZasunutyHore OR VstupManipulator_AktualPozMM < 600) AND NOT Oddelovac_KoniecVyroby AND diVstupDopr_ZdvihRotora_DOLE THEN
				SC_Oddelovac.IdleTime.IN:= TRUE;
			ELSE	
				SC_Oddelovac.IdleTime.IN:= FALSE;
			END_IF
		
			IF SC_Oddelovac.IdleTime.Q THEN
				SC_Oddelovac.ResetStep:= TRUE;
				SC_Oddelovac.Step:= 101;
			END_IF
			
			IF Oddelovac_KoniecCyklu AND NOT VstupManipulator_Automat THEN
				SC_Oddelovac.ResetStep:= TRUE;
				SC_Oddelovac.Step:= 0;
			END_IF
		
			IF Oddelovac_KoniecVyroby AND NOT VstupManipulator_Automat THEN
				SC_Oddelovac.ResetStep:= TRUE;
				SC_Oddelovac.Step:= 0;
			END_IF
		
		101:
			SC_Oddelovac.StepName:='101 - Automaticky rezim - preklopenie do vyvazacej pozicie';
			SC_Oddelovac.IdleTime.PT:= T#500ms;
			SC_Oddelovac.AlarmTime.PT:= T#5s;
		
			IF NOT SC_Oddelovac.Switch1 THEN
				Oddelovac_VYVAZANIE:= TRUE;
				SC_Oddelovac.Switch1:= TRUE;
			END_IF
		
			IF diOddelovac_PoziciaVyvazanie THEN
				SC_Oddelovac.ResetStep:= TRUE;
				SC_Oddelovac.Step:= 102;
			END_IF
		
		102:
			SC_Oddelovac.StepName:='102 - Automaticky rezim - cakanie na preklopenie do navazacej pozicie';
			SC_Oddelovac.IdleTime.PT:= T#100ms;
			SC_Oddelovac.AlarmTime.PT:= T#5s;
		
			IF NOT diOddelovac_PritomnostRotora AND diVstupDopr_PritomnostRotora THEN
				SC_Oddelovac.IdleTime.IN:= TRUE;
			ELSE	
				SC_Oddelovac.IdleTime.IN:= FALSE;
			END_IF
		
			IF SC_Oddelovac.IdleTime.Q THEN
				SC_Oddelovac.ResetStep:= TRUE;
				SC_Oddelovac.Step:= 103;
			END_IF
		
		103:
			SC_Oddelovac.StepName:='102 - Automaticky rezim - cakanie na preklopenie do navazacej pozicie';
			SC_Oddelovac.IdleTime.PT:= T#500ms;
			SC_Oddelovac.AlarmTime.PT:= T#5s;
		
			IF NOT SC_Oddelovac.Switch1 THEN
				Oddelovac_NAVAZANIE:= TRUE;
				SC_Oddelovac.Switch1:= TRUE;
			END_IF
		
			IF diOddelovac_PoziciaNavazanie THEN
				SC_Oddelovac.ResetStep:= TRUE;
				SC_Oddelovac.Step:= 100;
			END_IF
		
		
		
			
		
		//********************************************************Ruèný režim***********************************************************************************//
		700:
			SC_Oddelovac.StepName:='700 - Rucny rezim';
		
		
		
		
		
	END_CASE
	
	
	
	
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

