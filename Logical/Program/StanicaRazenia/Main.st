
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC

	//Volanie podprogramov//
	OvladanieZdvihu;
	
	
	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_Razenie);
	
	//Prepoèet èasu razenia//
	CasRazenia:= REAL_TO_TIME(TP_Razenie_CasRazenia * 1000);
	
	
	//Reset sekcie //
	IF Razenie_Reset OR NOT BezpOkruhOplotenia_Aktivovany OR PoruchaStanicaRazenia THEN
		SC_Razenie.Step:= 0;
	END_IF
	
	
	CASE SC_Razenie.Step OF 
	
	
		0:
			SC_Razenie.StepName:='0 - Nulovanie';
			SC_OvlZdvihu.Step:= 0;
			Razenie_Automat:= FALSE;
			Razenie_KoniecVyroby:= FALSE;
			Razenie_KoniecCyklu:= FALSE;
			Razenie_Manual:= FALSE;
			Razenie_PoINIT:= FALSE;
			Razenie_Reset:= FALSE;
			Razenie_UkoncilCyklus:= FALSE;
			Strihanie_StavBUSY:= FALSE;
			Zdvih_Napolohovany:= FALSE;
			IF BezpOkruhOplotenia_Aktivovany AND NOT PoruchaStanicaRazenia THEN
				SC_Razenie.ResetStep:= TRUE;
				SC_Razenie.Step:= 1;
			END_IF
	
		1:
			SC_Razenie.StepName:='1 - Rozhodnutie o cinnosti';
			IF Razenie_Automat THEN
				SC_Razenie.Step:= 2;
			ELSIF Razenie_Manual THEN
				SC_Razenie.Step:= 700;
			END_IF
		
		
			//********************************************************Inicializácia****************************************************************************//
	
		2:
			SC_Razenie.StepName:='2 - Inicializacia - cakanie na spustenie';
			SC_Razenie.IdleTime.PT:= T#500ms;
			SC_Razenie.AlarmTime.PT:= T#5s;
			SC_Razenie.IdleTime.IN:= TRUE;
				
			
			IF SC_Razenie.IdleTime.Q THEN
				SC_Razenie.ResetStep:= TRUE;
				SC_Razenie.Step:= 3;
			END_IF
	
		3:
			SC_Razenie.StepName:='3 - Inicializacia - zasunutie zdvihu';
			SC_Razenie.IdleTime.PT:= T#500ms;
			SC_Razenie.AlarmTime.PT:= T#5s;
		
			IF NOT SC_Razenie.Switch1 THEN
				Rotor_POLOZ:= TRUE;
				SC_Razenie.Switch1:= TRUE;
			END_IF
		
			IF diRazenie_ZdvihSpodnaPoloha THEN
				Razenie_PoINIT:= TRUE;
				SC_Razenie.ResetStep:= TRUE;
				SC_Razenie.Step:= 100;
			END_IF
		
		
			
		
		
			//********************************************************Automatický režim****************************************************************************//
		100:
			SC_Razenie.StepName:='100 - Automaticky rezim - cakanie na start cyklu';
			SC_Razenie.IdleTime.PT:= T#500ms;
			SC_Razenie.AlarmTime.PT:= T#5s;
			
			SC_Razenie.IdleTime.IN:= NOT diRazenie_PritomnostRotora;
            
			IF Razenie_KoniecCyklu THEN
				SC_Razenie.ResetStep:= TRUE;
				SC_Razenie.Step:= 0;
			ELSIF Zariadenie_PrebiehaRevorkRezim THEN
				SC_Razenie.ResetStep:= TRUE;
				SC_Razenie.Step:= 120;
			ELSIF Stol_PoINIT AND NOT Razenie_UkoncilCyklus AND diRazenie_PritomnostRotora AND diStol_SnimacPolohyStola (*AND Strihanie_SpustiRazenie*) THEN
				Strihanie_StavBUSY:= FALSE;
				Strihanie_SpustiRazenie:= FALSE;
				SC_Razenie.ResetStep:= TRUE;
				SC_Razenie.Step:= 101;//101	
			ELSIF Stol_PoINIT AND NOT Razenie_UkoncilCyklus AND NOT diRazenie_PritomnostRotora AND SC_Razenie.IdleTime.Q AND diStol_SnimacPolohyStola THEN
				Strihanie_StavBUSY:= FALSE;
				SC_Razenie.ResetStep:= TRUE;
				SC_Razenie.Step:= 120;
			ELSIF Razenie_KoniecVyroby AND NOT Stol_Automat THEN
				SC_Razenie.ResetStep:= TRUE;
				SC_Razenie.Step:= 0;	
			END_IF
		
		101:
			SC_Razenie.StepName:='101 - Automaticky rezim - zodvihnutie rotora';
			SC_Razenie.IdleTime.PT:= T#500ms;
			SC_Razenie.AlarmTime.PT:= T#5s;
		
			IF NOT SC_Razenie.Switch1 AND SC_OvlZdvihu.Step = 1 THEN
				Rotor_ZDVIHNI:= TRUE;
				SC_Razenie.Switch1:= TRUE;
			END_IF
		
			IF Zdvih_Napolohovany THEN
				Zdvih_Napolohovany:= FALSE;
				SC_Razenie.ResetStep:= TRUE;
				SC_Razenie.Step:= 103;
			END_IF
				
		103:
			SC_Razenie.StepName:='103 - Automaticky rezim - zasunutie zdvihu';
			SC_Razenie.IdleTime.PT:= T#500ms;
			SC_Razenie.AlarmTime.PT:= T#5s;
		
			IF NOT SC_Razenie.Switch1 AND SC_OvlZdvihu.Step = 1 THEN
				Rotor_POLOZ:= TRUE;
				SC_Razenie.Switch1:= TRUE;
			END_IF
		
			IF diRazenie_ZdvihSpodnaPoloha AND diRazenie_PritomnostRotora THEN
				SC_Razenie.ResetStep:= TRUE;
				SC_Razenie.Step:= 120;
			ELSIF diRazenie_ZdvihSpodnaPoloha AND NOT diRazenie_PritomnostRotora THEN
				Alarmy[52]:= TRUE;
				PoruchaStanicaRazenia:= TRUE;
			END_IF
		
			
		
		
		
		120:
			SC_Razenie.StepName:='120 - Automaticky rezim - vystavenie signalu ukoncenie pracovneho cyklu';
			SC_Razenie.IdleTime.PT:= T#500ms;
			SC_Razenie.AlarmTime.PT:= T#5s;
		
			IF diRazenie_ZdvihSpodnaPoloha THEN
				Razenie_UkoncilCyklus:= TRUE;
				SC_Razenie.ResetStep:= TRUE;
				SC_Razenie.Step:= 121;
			END_IF
		
		121:
			SC_Razenie.StepName:='121 - Automaticky rezim - cakanie na otocenie stola';
			SC_Razenie.IdleTime.PT:= T#500ms;
			SC_Razenie.AlarmTime.PT:= T#5s;
		
			IF NOT Razenie_UkoncilCyklus AND SC_OvlZdvihu.Step = 1 THEN
				SC_Razenie.ResetStep:= TRUE;
				SC_Razenie.Step:= 100;
			ELSIF Razenie_KoniecVyroby AND NOT Stol_Automat THEN
				SC_Razenie.ResetStep:= TRUE;
				SC_Razenie.Step:= 0;
			ELSIF Razenie_KoniecCyklu THEN
				SC_Razenie.ResetStep:= TRUE;
				SC_Razenie.Step:= 0;	
			END_IF
		
			//********************************************************Ruèný režim***********************************************************************************//
		700:
			SC_Razenie.StepName:='700 - Rucny rezim';
		
	END_CASE
END_PROGRAM

PROGRAM _EXIT
END_PROGRAM

