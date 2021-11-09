
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	
	
	//Volanie podprogramov//
	OvladanieOdsuvania;
	
	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_VystupnyOdsuvac);
	
	//Reset sekcie //
	IF VystupOdsuvac_Reset OR NOT BezpOkruhOplotenia_Aktivovany OR PoruchaVystupOdsuvac THEN
		SC_VystupnyOdsuvac.Step:= 0;
	END_IF
	
	
	CASE SC_VystupnyOdsuvac.Step OF 
	
	
		0:
			SC_VystupnyOdsuvac.StepName:='0 - Nulovanie';
			SC_OvlOdsuvaca.Step:= 0;
			VystupOdsuvac_Automat:= FALSE;
			VystupOdsuvac_KoniecVyroby:= FALSE;
			VystupOdsuvac_KoniecCyklu:= FALSE;
			VystupOdsuvac_Manual:= FALSE;
			VystupOdsuvac_PoINIT:= FALSE;
			VystupOdsuvac_Reset:= FALSE;
			VystupOdsuvac_CakaNaKusy:= FALSE;
			VystupOdsuvac_KusyVlozene:= FALSE;
			IF BezpOkruhOplotenia_Aktivovany AND NOT PoruchaVystupOdsuvac THEN
				SC_VystupnyOdsuvac.ResetStep:= TRUE;
				SC_VystupnyOdsuvac.Step:= 1;
			END_IF
	
		1:
			SC_VystupnyOdsuvac.StepName:='1 - Rozhodnutie o cinnosti';
			IF VystupOdsuvac_Automat THEN
				SC_VystupnyOdsuvac.Step:= 2;
			ELSIF VystupOdsuvac_Manual THEN
				SC_VystupnyOdsuvac.Step:= 700;
			END_IF
		
		
		//********************************************************Inicializácia****************************************************************************//
		
		2:
			SC_VystupnyOdsuvac.StepName:='2 - Inicializacia - cakanie na spustenie';
			SC_VystupnyOdsuvac.IdleTime.PT:= T#500ms;
			SC_VystupnyOdsuvac.AlarmTime.PT:= T#5s;
			SC_VystupnyOdsuvac.IdleTime.IN:= TRUE;
				
			
			IF SC_VystupnyOdsuvac.IdleTime.Q THEN
				SC_VystupnyOdsuvac.ResetStep:= TRUE;
				SC_VystupnyOdsuvac.Step:= 3;
			END_IF
	
		3:
			SC_VystupnyOdsuvac.StepName:='3 - Inicializacia - vysunutie odsuvaca vpred';
			SC_VystupnyOdsuvac.IdleTime.PT:= T#500ms;
			SC_VystupnyOdsuvac.AlarmTime.PT:= T#5s;
		
			IF NOT SC_VystupnyOdsuvac.Switch1 AND NOT diVystDoprNG_SnimacZaplnTrate AND NOT diVystDoprOK_SnimacZaplnTrate THEN
				Odsuvac_VYSUN:= TRUE;
				SC_VystupnyOdsuvac.Switch1:= TRUE;
			END_IF
		
			IF diVystDopr_OdsuvacVysunuty THEN
				SC_VystupnyOdsuvac.ResetStep:= TRUE;
				SC_VystupnyOdsuvac.Step:= 4;
			END_IF
		
		4:
			SC_VystupnyOdsuvac.StepName:='4 - Inicializacia - zasunutie odsuvaca vzad';
			SC_VystupnyOdsuvac.IdleTime.PT:= T#500ms;
			SC_VystupnyOdsuvac.AlarmTime.PT:= T#5s;
		
			IF NOT SC_VystupnyOdsuvac.Switch1 AND SC_OvlOdsuvaca.Step = 1 THEN
				Odsuvac_ZASUN:= TRUE;
				SC_VystupnyOdsuvac.Switch1:= TRUE;
			END_IF
		
			IF diVystDopr_OdsuvacZasunuty THEN
				VystupOdsuvac_PoINIT:= TRUE;
				SC_VystupnyOdsuvac.ResetStep:= TRUE;
				SC_VystupnyOdsuvac.Step:= 100;
			END_IF
		
		
		
		
		//********************************************************Automatický režim****************************************************************************//
		100:
			SC_VystupnyOdsuvac.StepName:='100 - Automaticky rezim - cakanie na vysunutie';
			SC_VystupnyOdsuvac.IdleTime.PT:= T#500ms;
			SC_VystupnyOdsuvac.AlarmTime.PT:= T#5s;
		
			IF NOT SC_VystupnyOdsuvac.Switch1 THEN
				VystupOdsuvac_CakaNaKusy:= TRUE;
				SC_VystupnyOdsuvac.Switch1:= TRUE;
			END_IF
			
			IF VystupOdsuvac_KusyVlozene THEN
				VystupOdsuvac_CakaNaKusy:= FALSE;
				VystupOdsuvac_KusyVlozene:= FALSE;
				SC_VystupnyOdsuvac.ResetStep:= TRUE;
				SC_VystupnyOdsuvac.Step:= 101;
			ELSIF VystupOdsuvac_KoniecVyroby AND NOT VystupManipulator_Automat THEN
				SC_VystupnyOdsuvac.ResetStep:= TRUE;
				SC_VystupnyOdsuvac.Step:= 0;
			ELSIF VystupOdsuvac_KoniecCyklu AND NOT VystupManipulator_Automat THEN
				SC_VystupnyOdsuvac.ResetStep:= TRUE;
				SC_VystupnyOdsuvac.Step:= 0;	
			END_IF
		
			
		
		101:
			SC_VystupnyOdsuvac.StepName:='101 - Automaticky rezim - vysunutie odsuvaca vpred';
			SC_VystupnyOdsuvac.IdleTime.PT:= T#500ms;
			SC_VystupnyOdsuvac.AlarmTime.PT:= T#5s;
		
			IF NOT SC_VystupnyOdsuvac.Switch1 AND NOT diVystDoprNG_SnimacZaplnTrate AND NOT diVystDoprOK_SnimacZaplnTrate THEN
				Odsuvac_VYSUN:= TRUE;
				SC_VystupnyOdsuvac.Switch1:= TRUE;
			END_IF
		
			IF diVystDopr_OdsuvacVysunuty THEN
				SC_VystupnyOdsuvac.ResetStep:= TRUE;
				SC_VystupnyOdsuvac.Step:= 102;
			END_IF
		
		102:
			SC_VystupnyOdsuvac.StepName:='101 - Automaticky rezim - zasunutie odsuvaca vzad';
			SC_VystupnyOdsuvac.IdleTime.PT:= T#500ms;
			SC_VystupnyOdsuvac.AlarmTime.PT:= T#5s;
		
			IF NOT SC_VystupnyOdsuvac.Switch1 AND SC_OvlOdsuvaca.Step = 1 THEN
				Odsuvac_ZASUN:= TRUE;
				SC_VystupnyOdsuvac.Switch1:= TRUE;
			END_IF
		
			IF diVystDopr_OdsuvacZasunuty THEN
				SC_VystupnyOdsuvac.ResetStep:= TRUE;
				SC_VystupnyOdsuvac.Step:= 100;
			END_IF
		
		
		
		
		
		
		
		//********************************************************Ruèný režim***********************************************************************************//
		700:
			SC_VystupnyOdsuvac.StepName:='700 - Rucny rezim';
		
		
		
		
		
	END_CASE
	
	
	
	
	
	
	
	
	 
				END_PROGRAM

PROGRAM _EXIT
				(* Insert code here *)
	 
				END_PROGRAM

