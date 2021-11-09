
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	
	//Volanie podprogramov//
	OvladanieGripra;
	OvladaniePojazdu;
	OvladanieZdvihu;
	
	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_VystupnyManipulator);
	
	//Reset sekcie //
	IF VystupManipulator_Reset OR NOT BezpOkruhOplotenia_Aktivovany OR PoruchaVystupManipulator THEN
		SC_VystupnyManipulator.Step:= 0;
	END_IF
	
	
	CASE SC_VystupnyManipulator.Step OF 
	
	
		0:
			SC_VystupnyManipulator.StepName:='0 - Nulovanie';
			SC_OvlGripra.Step:= 0;
			SC_OvlServoPojazdu.Step:= 0;
			SC_OvlZdvihu.Step:= 0;
			VystupManipulator_Automat:= FALSE;
			VystupManipulator_KoniecVyroby:= FALSE;
			VystupManipulator_KoniecCyklu:= FALSE;
			VystupManipulator_Manual:= FALSE;
			VystupManipulator_PoINIT:= FALSE;
			VystupManipulator_Reset:= FALSE;
			VystupManipulator_PojazdVPOZICI:= FALSE;
			VystupManipulator_UkoncilCyklus:= FALSE;
			
			IF BezpOkruhOplotenia_Aktivovany AND NOT PoruchaVystupManipulator THEN
				SC_VystupnyManipulator.ResetStep:= TRUE;
				SC_VystupnyManipulator.Step:= 1;
			END_IF
	
		1:
			SC_VystupnyManipulator.StepName:='1 - Rozhodnutie o cinnosti';
			IF VystupManipulator_Automat THEN
				SC_VystupnyManipulator.Step:= 2;
			ELSIF VystupManipulator_Manual THEN
				SC_VystupnyManipulator.Step:= 700;
			END_IF
		
		
		//********************************************************Inicializácia****************************************************************************//
		
		2:
			SC_VystupnyManipulator.StepName:='2 - Inicializacia - cakanie na spustenie';
			SC_VystupnyManipulator.IdleTime.PT:= T#500ms;
			SC_VystupnyManipulator.AlarmTime.PT:= T#5s;
			SC_VystupnyManipulator.IdleTime.IN:= TRUE;
				
			
			IF SC_VystupnyManipulator.IdleTime.Q THEN
				SC_VystupnyManipulator.ResetStep:= TRUE;
				SC_VystupnyManipulator.Step:= 3;
			END_IF
	
		
		3:
			SC_VystupnyManipulator.StepName:='2 - Inicializacia - kontrola home serva';
			SC_VystupnyManipulator.IdleTime.PT:= T#500ms;
			SC_VystupnyManipulator.AlarmTime.PT:= T#5s;
		
		
			IF Motion[2].status.DriveStatus.HomingOk THEN
				SC_VystupnyManipulator.ResetStep:= TRUE;
				SC_VystupnyManipulator.Step:= 5;
			ELSE
				SC_VystupnyManipulator.ResetStep:= TRUE;
				SC_VystupnyManipulator.Step:= 4;
			END_IF
		
		
		4:
			SC_VystupnyManipulator.StepName:='4 - Inicializacia - homing serva';
			SC_VystupnyManipulator.IdleTime.PT:= T#500ms;
			SC_VystupnyManipulator.AlarmTime.PT:= T#5s;
			
			
			IF NOT SC_VystupnyManipulator.Switch1 THEN
				VystupManipulator_PojazdHOME:= TRUE;
				SC_VystupnyManipulator.Switch1:= TRUE;
			END_IF
			
			IF Motion[2].status.DriveStatus.HomingOk THEN
				SC_VystupnyManipulator.IdleTime.IN:= TRUE;
			END_IF	
			
			IF Motion[2].status.DriveStatus.HomingOk AND SC_VystupnyManipulator.IdleTime.Q AND Motion[2].state.StandStill THEN
				SC_VystupnyManipulator.ResetStep:= TRUE;
				SC_VystupnyManipulator.Step:= 6;
			END_IF
		
		
		5:
			SC_VystupnyManipulator.StepName:='5 - Inicializacia - zodvihnutie gripra';
			SC_VystupnyManipulator.IdleTime.PT:= T#500ms;
			SC_VystupnyManipulator.AlarmTime.PT:= T#5s;
			
		
			IF NOT SC_VystupnyManipulator.Switch1 THEN
				Zdvih_Manipulatora:= TRUE;
				SC_VystupnyManipulator.Switch1:= TRUE;
			END_IF
		
			IF diVystupManipul_ZasunutyHore THEN
				SC_VystupnyManipulator.ResetStep:= TRUE;
				SC_VystupnyManipulator.Step:= 6;
			END_IF
		
		
		6:
			SC_VystupnyManipulator.StepName:='6 - Inicializacia - rozhodnutie o presunu manipulatora';
			SC_VystupnyManipulator.IdleTime.PT:= T#500ms;
			SC_VystupnyManipulator.AlarmTime.PT:= T#5s;
		
			IF diVystupManipul_GriperOtvoreny AND diVystupManipul_GriperZatvoreny THEN
				Alarmy[81]:= TRUE;
				PoruchaVystupManipulator:= TRUE;
			ELSIF diVystupManipul_GriperOtvoreny AND NOT diVystupManipul_GriperZatvoreny THEN
				SC_VystupnyManipulator.ResetStep:= TRUE;
				SC_VystupnyManipulator.Step:= 7;
			ELSIF NOT diVystupManipul_GriperOtvoreny AND diVystupManipul_GriperZatvoreny THEN
				SC_VystupnyManipulator.ResetStep:= TRUE;
				SC_VystupnyManipulator.Step:= 8;	
			END_IF	
		
		7:
			SC_VystupnyManipulator.StepName:='6 - Inicializacia - presun nad stol';
			SC_VystupnyManipulator.IdleTime.PT:= T#500ms;
			SC_VystupnyManipulator.AlarmTime.PT:= T#5s;
		
			VystupManipulator_ZadanaPozMM:= TP_VystupManip_PoziciaOdoberania;   
			
			IF NOT SC_VystupnyManipulator.Switch1 THEN
				ServoPojazd_Polohuj:= TRUE;
				SC_VystupnyManipulator.Switch1:= TRUE;
			END_IF
		
			IF VystupManipulator_PojazdVPOZICI THEN
				VystupManipulator_PojazdVPOZICI:= FALSE;
				VystupManipulator_PoINIT:= TRUE;
				SC_VystupnyManipulator.ResetStep:= TRUE;
				SC_VystupnyManipulator.Step:= 100;
			END_IF
		
		8:
			SC_VystupnyManipulator.StepName:='8 - Inicializacia - presun nad NG dopravnik';
			SC_VystupnyManipulator.IdleTime.PT:= T#500ms;
			SC_VystupnyManipulator.AlarmTime.PT:= T#5s;
		
			VystupManipulator_ZadanaPozMM:= TP_VystupManip_PoziciaUklad_NG;	
		
			IF NOT SC_VystupnyManipulator.Switch1 THEN
				ServoPojazd_Polohuj:= TRUE;
				SC_VystupnyManipulator.Switch1:= TRUE;
			END_IF
		
			IF VystupManipulator_PojazdVPOZICI THEN
				VystupManipulator_PojazdVPOZICI:= FALSE;
				VystupManipulator_PoINIT:= TRUE;
				SC_VystupnyManipulator.ResetStep:= TRUE;
				SC_VystupnyManipulator.Step:= 106;
			END_IF
		
		
		
		
		
		
		
		//********************************************************Automatický režim****************************************************************************//
		100:
			SC_VystupnyManipulator.StepName:='100 - Automaticky rezim - cakanie na start cyklu';
			SC_VystupnyManipulator.IdleTime.PT:= T#500ms;
			SC_VystupnyManipulator.AlarmTime.PT:= T#5s;
		
            SC_VystupnyManipulator.IdleTime.IN:= NOT diStol_PritomnostRotoraVystup;
            
			IF VystupManipulator_KoniecCyklu THEN
				SC_VystupnyManipulator.ResetStep:= TRUE;
				SC_VystupnyManipulator.Step:= 0;
			ELSIF Stol_PoINIT AND NOT VystupManipulator_UkoncilCyklus AND diVystupManipul_GriperOtvoreny AND diStol_PritomnostRotoraVystup AND diStol_SnimacPolohyStola THEN
				SC_VystupnyManipulator.ResetStep:= TRUE;
				SC_VystupnyManipulator.Step:= 102;
			ELSIF Stol_PoINIT AND NOT VystupManipulator_UkoncilCyklus AND NOT diStol_PritomnostRotoraVystup AND SC_VystupnyManipulator.IdleTime.Q THEN
				VystupManipulator_UkoncilCyklus:= TRUE;
				SC_VystupnyManipulator.ResetStep:= TRUE;
				SC_VystupnyManipulator.Step:= 121;
			ELSIF VystupManipulator_KoniecVyroby AND NOT Stol_Automat THEN
				SC_VystupnyManipulator.ResetStep:= TRUE;
				SC_VystupnyManipulator.Step:= 0;
			END_IF
		
		
		
		102:
			SC_VystupnyManipulator.StepName:='102 - Automaticky rezim - zostup gripra';
			SC_VystupnyManipulator.IdleTime.PT:= T#500ms;
			SC_VystupnyManipulator.AlarmTime.PT:= T#5s;
		
			IF NOT SC_VystupnyManipulator.Switch1 AND SC_OvlZdvihu.Step = 1 THEN
				Zostup_Manipulatora:= TRUE;
				SC_VystupnyManipulator.Switch1:= TRUE;
			END_IF
		
			IF diVystupManipul_VysunutyDole THEN
				SC_VystupnyManipulator.ResetStep:= TRUE;
				SC_VystupnyManipulator.Step:= 103;
			END_IF
			
		
		103:
			SC_VystupnyManipulator.StepName:='103 - Automaticky rezim - zatvorenie gripra';
			SC_VystupnyManipulator.IdleTime.PT:= T#500ms;
			SC_VystupnyManipulator.AlarmTime.PT:= T#5s;
		
			IF NOT SC_VystupnyManipulator.Switch1 THEN
				Zatvor_Griper:= TRUE;
				SC_VystupnyManipulator.Switch1:= TRUE;
			END_IF
		
		
			IF diVystupManipul_GriperZatvoreny THEN
				SC_VystupnyManipulator.ResetStep:= TRUE;
				SC_VystupnyManipulator.Step:= 104;
			END_IF
		
		104:
			SC_VystupnyManipulator.StepName:='104 - Automaticky rezim - zdvih gripra, vystavenie signalu ukoncenia cyklu';
			SC_VystupnyManipulator.IdleTime.PT:= T#500ms;
			SC_VystupnyManipulator.AlarmTime.PT:= T#5s;
			SC_VystupnyManipulator.IdleTime.IN:= TRUE;
			
						
			IF NOT SC_VystupnyManipulator.Switch1 THEN
				Zdvih_Manipulatora:= TRUE;
				SC_VystupnyManipulator.Switch1:= TRUE;
			END_IF
		
			IF diVystupManipul_ZasunutyHore THEN
				IF Zariadenie_PrebiehaRevorkRezim THEN
					VystupManipulator_Drzi_OK_Kus:= TRUE;
					VystupManipulator_Drzi_NG_Kus:= FALSE;
					VystupManipulator_UkoncilCyklus:= TRUE;
					SC_VystupnyManipulator.ResetStep:= TRUE;
					SC_VystupnyManipulator.Step:= 105;
				ELSIF VystupManipulator_OdoberNGKus THEN
					VystupManipulator_Drzi_NG_Kus:= TRUE;
					VystupManipulator_Drzi_OK_Kus:= FALSE;
					VystupManipulator_OdoberNGKus:= FALSE;
					VystupManipulator_UkoncilCyklus:= TRUE;
					SC_VystupnyManipulator.ResetStep:= TRUE;
					SC_VystupnyManipulator.Step:= 105;
				ELSIF Stol_Pozicia_3 = 2 OR Stol_Pozicia_3 = 0 THEN
					VystupManipulator_Drzi_NG_Kus:= TRUE;
					VystupManipulator_Drzi_OK_Kus:= FALSE;
					VystupManipulator_UkoncilCyklus:= TRUE;
					SC_VystupnyManipulator.ResetStep:= TRUE;
					SC_VystupnyManipulator.Step:= 105;
				ELSIF Stol_Pozicia_3 = 1 THEN
					VystupManipulator_Drzi_OK_Kus:= TRUE;
					VystupManipulator_Drzi_NG_Kus:= FALSE;
					VystupManipulator_UkoncilCyklus:= TRUE;
					SC_VystupnyManipulator.ResetStep:= TRUE;
					SC_VystupnyManipulator.Step:= 105;
				END_IF	
			END_IF	
		
		
		105:
			SC_VystupnyManipulator.StepName:='105 - Automaticky rezim - rozhodnutie o polozeni kusu, presun manipulatora na poziciu ukladania';
			SC_VystupnyManipulator.IdleTime.PT:= T#500ms;
			SC_VystupnyManipulator.AlarmTime.PT:= T#5s;
		
			IF VystupManipulator_Drzi_NG_Kus THEN
				VystupManipulator_ZadanaPozMM:= TP_VystupManip_PoziciaUklad_NG;  //480;  //Pozícia dopravníka NG
			ELSIF VystupManipulator_Drzi_OK_Kus THEN	
				VystupManipulator_ZadanaPozMM:= TP_VystupManip_PoziciaUklad_OK;  //353;  //Pozícia dopravníka OK
			END_IF
		
			IF NOT SC_VystupnyManipulator.Switch1 THEN
				ServoPojazd_Polohuj:= TRUE;
				SC_VystupnyManipulator.Switch1:= TRUE;
			END_IF
		
			IF VystupManipulator_PojazdVPOZICI THEN
				VystupManipulator_PojazdVPOZICI:= FALSE;
				SC_VystupnyManipulator.ResetStep:= TRUE;
				SC_VystupnyManipulator.Step:= 106;
			END_IF	
		
		106:
			SC_VystupnyManipulator.StepName:='105 - Automaticky rezim - cakanie na polozenie rotora na dopravnik';
			SC_VystupnyManipulator.IdleTime.PT:= T#500ms;
			SC_VystupnyManipulator.AlarmTime.PT:= T#5s;
		
			IF (VystupManipulator_AktualPozMM = TP_VystupManip_PoziciaUklad_NG) AND NOT diVystDoprNG_SnimacZaplnTrate AND diVystDopr_OdsuvacZasunuty AND VystupOdsuvac_CakaNaKusy THEN
				SC_VystupnyManipulator.ResetStep:= TRUE;
				SC_VystupnyManipulator.Step:= 107;
			ELSIF (VystupManipulator_AktualPozMM = TP_VystupManip_PoziciaUklad_OK) AND NOT diVystDoprOK_SnimacZaplnTrate AND diVystDopr_OdsuvacZasunuty AND VystupOdsuvac_CakaNaKusy THEN
				SC_VystupnyManipulator.ResetStep:= TRUE;
				SC_VystupnyManipulator.Step:= 107;
			END_IF
		
		107:
			SC_VystupnyManipulator.StepName:='107 - Automaticky rezim - polozenie rotora na dopravnik';
			SC_VystupnyManipulator.IdleTime.PT:= T#1s;
			SC_VystupnyManipulator.AlarmTime.PT:= T#5s;
			SC_VystupnyManipulator.IdleTime.IN:= TRUE;
			
			IF NOT SC_VystupnyManipulator.Switch1 THEN
				Zostup_Manipulatora:= TRUE;
				SC_VystupnyManipulator.Switch1:= TRUE;
			END_IF
		
			IF diVystupManipul_VysunutyDole THEN
				SC_VystupnyManipulator.ResetStep:= TRUE;
				SC_VystupnyManipulator.Step:= 108;
			END_IF	
		
		108:
			SC_VystupnyManipulator.StepName:='108 - Automaticky rezim - otvorenie gripra';
			SC_VystupnyManipulator.IdleTime.PT:= T#500ms;
			SC_VystupnyManipulator.AlarmTime.PT:= T#5s;
		
			IF NOT SC_VystupnyManipulator.Switch1 THEN
				Otvor_Griper:= TRUE;
				SC_VystupnyManipulator.Switch1:= TRUE;
			END_IF
		
		
			IF diVystupManipul_GriperOtvoreny THEN
				VystupManipulator_Drzi_NG_Kus:= FALSE;
				VystupManipulator_Drzi_OK_Kus:= FALSE;
				SC_VystupnyManipulator.ResetStep:= TRUE;
				SC_VystupnyManipulator.Step:= 109;
			END_IF
		
		109:
			SC_VystupnyManipulator.StepName:='109 - Automaticky rezim - zdvih gripra';
			SC_VystupnyManipulator.IdleTime.PT:= T#500ms;
			SC_VystupnyManipulator.AlarmTime.PT:= T#5s;
						
						
			IF NOT SC_VystupnyManipulator.Switch1 THEN
				Zdvih_Manipulatora:= TRUE;
				SC_VystupnyManipulator.Switch1:= TRUE;
			END_IF
		
			IF diVystupManipul_ZasunutyHore THEN
				VystupOdsuvac_KusyVlozene:= TRUE;
				SC_VystupnyManipulator.ResetStep:= TRUE;
				SC_VystupnyManipulator.Step:= 110;
			END_IF	
	
		110:
			SC_VystupnyManipulator.StepName:='110 - Automaticky rezim - presun do cakacej pozicie nad stol';
			SC_VystupnyManipulator.IdleTime.PT:= T#500ms;
			SC_VystupnyManipulator.AlarmTime.PT:= T#5s;
		
			VystupManipulator_ZadanaPozMM:= TP_VystupManip_PoziciaOdoberania;   
			
			IF NOT SC_VystupnyManipulator.Switch1 THEN
				ServoPojazd_Polohuj:= TRUE;
				SC_VystupnyManipulator.Switch1:= TRUE;
			END_IF
		
			IF VystupManipulator_PojazdVPOZICI THEN
				VystupManipulator_PojazdVPOZICI:= FALSE;
				SC_VystupnyManipulator.ResetStep:= TRUE;
				SC_VystupnyManipulator.Step:= 121;
			END_IF
		
			
							
		121:
			SC_VystupnyManipulator.StepName:='121 - Automaticky rezim - cakanie na otocenie stola';
			SC_VystupnyManipulator.IdleTime.PT:= T#500ms;
			SC_VystupnyManipulator.AlarmTime.PT:= T#5s;
		
			IF NOT VystupManipulator_UkoncilCyklus THEN
				SC_VystupnyManipulator.ResetStep:= TRUE;
				SC_VystupnyManipulator.Step:= 100;
			ELSIF VystupManipulator_KoniecVyroby AND NOT Stol_Automat THEN
				SC_VystupnyManipulator.ResetStep:= TRUE;
				SC_VystupnyManipulator.Step:= 0;
			ELSIF VystupManipulator_KoniecCyklu THEN
				SC_VystupnyManipulator.ResetStep:= TRUE;
				SC_VystupnyManipulator.Step:= 0;	
			END_IF	
		
		
		
		
		
		
		//********************************************************Ruèný režim***********************************************************************************//
		700:
			SC_VystupnyManipulator.StepName:='700 - Rucny rezim';
		
			//Polohovanie manipulátora//
			IF RR_PoziciaOdoberaniaStol AND SC_OvlServoPojazdu.Step = 1 THEN
				VystupManipul_Rychlost_MM_s:= TP_VystupManip_RychlostPojazdu;
				VystupManipulator_ZadanaPozMM:= TP_VystupManip_PoziciaOdoberania;
				ServoPojazd_Polohuj:= TRUE;
			ELSIF RR_PoziciaUkladaniaNG AND SC_OvlServoPojazdu.Step = 1 THEN
				VystupManipul_Rychlost_MM_s:= TP_VystupManip_RychlostPojazdu;
				VystupManipulator_ZadanaPozMM:= TP_VystupManip_PoziciaUklad_NG;
				ServoPojazd_Polohuj:= TRUE;
			ELSIF RR_PoziciaUkladaniaOK AND SC_OvlServoPojazdu.Step = 1 THEN
				VystupManipul_Rychlost_MM_s:= TP_VystupManip_RychlostPojazdu;
				VystupManipulator_ZadanaPozMM:= TP_VystupManip_PoziciaUklad_OK;
				ServoPojazd_Polohuj:= TRUE;	
			END_IF	
		
		
		
		
		
	END_CASE
	
	
	
	
	
	
	 
				END_PROGRAM

PROGRAM _EXIT
				(* Insert code here *)
	 
				END_PROGRAM

