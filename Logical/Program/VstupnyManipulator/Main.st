
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	
	//Volanie podprogramov//
	OvladanieGripra;
	OvladaniePojazdu;
	OvladanieZdvihu;
	
	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_VstupnyManipulator);
	
		
	
	//Reset sekcie //
	IF VstupManipulator_Reset OR NOT BezpOkruhOplotenia_Aktivovany OR PoruchaVstupManipulator THEN
		SC_VstupnyManipulator.Step:= 0;
	END_IF
	
	
	CASE SC_VstupnyManipulator.Step OF 
	
	
		0:
			SC_VstupnyManipulator.StepName:='0 - Nulovanie';
			SC_OvlGripra.Step:= 0;
			SC_OvlServoPojazdu.Step:= 0;
			SC_OvlZdvihu.Step:= 0;
			VstupManipulator_Automat:= FALSE;
			VstupManipulator_KoniecVyroby:= FALSE;
			VstupManipulator_KoniecCyklu:= FALSE;
			VstupManipulator_Manual:= FALSE;
			VstupManipulator_PoINIT:= FALSE;
			VstupManipulator_Reset:= FALSE;
			VstupManipulator_PojazdVPOZICI:= FALSE;
			VstupManipulator_UkoncilCyklus:= FALSE;
			Zariadenie_PAUZA:= FALSE;
			VstupManipulator_OdobralRotor:= FALSE;
			IF BezpOkruhOplotenia_Aktivovany AND NOT PoruchaVstupManipulator THEN
				SC_VstupnyManipulator.ResetStep:= TRUE;
				SC_VstupnyManipulator.Step:= 1;
			END_IF
	
		1:
			SC_VstupnyManipulator.StepName:='1 - Rozhodnutie o cinnosti';
			IF VstupManipulator_Automat THEN
				SC_VstupnyManipulator.Step:= 2;
			ELSIF VstupManipulator_Manual THEN
				SC_VstupnyManipulator.Step:= 700;
			END_IF
		
		
		//********************************************************Inicializácia****************************************************************************//
		
		2:
			SC_VstupnyManipulator.StepName:='2 - Inicializacia - cakanie na spustenie';
			SC_VstupnyManipulator.IdleTime.PT:= T#500ms;
			SC_VstupnyManipulator.AlarmTime.PT:= T#5s;
			SC_VstupnyManipulator.IdleTime.IN:= TRUE;
				
			
			IF SC_VstupnyManipulator.IdleTime.Q THEN
				SC_VstupnyManipulator.ResetStep:= TRUE;
				SC_VstupnyManipulator.Step:= 3;
			END_IF
	
		
		3:
			SC_VstupnyManipulator.StepName:='3 - Inicializacia - kontrola home serva';
			SC_VstupnyManipulator.IdleTime.PT:= T#500ms;
			SC_VstupnyManipulator.AlarmTime.PT:= T#5s;
		
			IF Motion[1].status.DriveStatus.HomingOk THEN
				SC_VstupnyManipulator.ResetStep:= TRUE;
				SC_VstupnyManipulator.Step:= 5;
			ELSE
				SC_VstupnyManipulator.ResetStep:= TRUE;
				SC_VstupnyManipulator.Step:= 4;
			END_IF
		
		
		4:
			SC_VstupnyManipulator.StepName:='4 - Inicializacia - homing serva';
			SC_VstupnyManipulator.IdleTime.PT:= T#1s;
			SC_VstupnyManipulator.AlarmTime.PT:= T#5s;
			
			
			IF NOT SC_VstupnyManipulator.Switch1 THEN
				VstupManipulator_PojazdHOME:= TRUE;
				SC_VstupnyManipulator.Switch1:= TRUE;
			END_IF
			
			IF Motion[1].status.DriveStatus.HomingOk THEN
				SC_VstupnyManipulator.IdleTime.IN:= TRUE;
			END_IF	
			
			IF Motion[1].status.DriveStatus.HomingOk AND SC_VstupnyManipulator.IdleTime.Q AND Motion[1].state.StandStill THEN
				SC_VstupnyManipulator.ResetStep:= TRUE;
				SC_VstupnyManipulator.Step:= 6;
			END_IF
		
		
		5:
			SC_VstupnyManipulator.StepName:='5 - Inicializacia - zodvihnutie gripra';
			SC_VstupnyManipulator.IdleTime.PT:= T#500ms;
			SC_VstupnyManipulator.AlarmTime.PT:= T#5s;
			
		
			IF NOT SC_VstupnyManipulator.Switch1 THEN
				Zdvih_Manipulatora:= TRUE;
				SC_VstupnyManipulator.Switch1:= TRUE;
			END_IF
		
			IF diVstupManipul_ZasunutyHore THEN
				SC_VstupnyManipulator.ResetStep:= TRUE;
				SC_VstupnyManipulator.Step:= 6;
			END_IF
		
		6:
			SC_VstupnyManipulator.StepName:='6 - Inicializacia - rozhodnutie o presunu manipulatora';
			SC_VstupnyManipulator.IdleTime.PT:= T#200ms;
			SC_VstupnyManipulator.AlarmTime.PT:= T#5s;
		
			IF diVstupManipul_GriperOtvoreny AND diVstupManipul_GriperZatvoreny THEN
				Alarmy[21]:= TRUE;
				PoruchaVstupManipulator:= TRUE;
			ELSIF diVstupManipul_GriperOtvoreny AND NOT diVstupManipul_GriperZatvoreny THEN	
				VstupManipulator_PoINIT:= TRUE;
				SC_VstupnyManipulator.ResetStep:= TRUE;
				SC_VstupnyManipulator.Step:= 125;
			ELSIF NOT diVstupManipul_GriperOtvoreny AND diVstupManipul_GriperZatvoreny THEN	
				VstupManipulator_PoINIT:= TRUE;
				SC_VstupnyManipulator.ResetStep:= TRUE;
				SC_VstupnyManipulator.Step:= 110;
			END_IF	
		
			
			
		
		//********************************************************Automatický režim****************************************************************************//
		100:
			SC_VstupnyManipulator.StepName:='100 - Automaticky rezim - cakanie na odobratie rotora';
			SC_VstupnyManipulator.IdleTime.PT:= T#3s;
			SC_VstupnyManipulator.AlarmTime.PT:= T#5s;
			SC_VstupnyManipulator.IdleTime.IN:= TRUE;
			
			IF VstupManipulator_KoniecCyklu THEN
				SC_VstupnyManipulator.ResetStep:= TRUE;
				SC_VstupnyManipulator.Step:= 0;	
			ELSIF diVstupManipul_GriperOtvoreny AND NOT diVstupManipul_GriperZatvoreny AND diVstupDopr_PritomnostRotora AND diVstupDopr_ZdvihRotora_HORE AND NOT VstupManipulator_KoniecVyroby THEN
				SC_VstupnyManipulator.ResetStep:= TRUE;
				SC_VstupnyManipulator.Step:= 101;
			ELSIF diVstupManipul_GriperZatvoreny AND NOT diVstupManipul_GriperOtvoreny THEN
				SC_VstupnyManipulator.ResetStep:= TRUE;
				SC_VstupnyManipulator.Step:= 108;
			ELSIF SC_VstupnyManipulator.IdleTime.Q AND Stol_Automat THEN
				VstupManipulator_UkoncilCyklus:= TRUE;
				SC_VstupnyManipulator.ResetStep:= TRUE;
				SC_VstupnyManipulator.Step:= 132;
			ELSIF VstupManipulator_KoniecVyroby AND NOT Stol_Automat THEN
				SC_VstupnyManipulator.ResetStep:= TRUE;
				SC_VstupnyManipulator.Step:= 0;
			END_IF
		
					
		
		101:
			SC_VstupnyManipulator.StepName:='101 - Automaticky rezim - zostup manipulatora nad vstupny dopravnik';
			SC_VstupnyManipulator.IdleTime.PT:= T#1s;
			SC_VstupnyManipulator.AlarmTime.PT:= T#5s;
			SC_VstupnyManipulator.IdleTime.IN:= TRUE;
			
			IF NOT SC_VstupnyManipulator.Switch1 THEN
				Zostup_Manipulatora:= TRUE;
				SC_VstupnyManipulator.Switch1:= TRUE;
			END_IF
		
			IF diVstupManipul_VysunutyDole THEN
				SC_VstupnyManipulator.ResetStep:= TRUE;
				SC_VstupnyManipulator.Step:= 102;
			END_IF
		
		102:
			SC_VstupnyManipulator.StepName:='102 - Automaticky rezim - zatvorenie gripra manipulatora';
			SC_VstupnyManipulator.IdleTime.PT:= T#500ms;
			SC_VstupnyManipulator.AlarmTime.PT:= T#5s;
		
			IF NOT SC_VstupnyManipulator.Switch1 THEN
				Zatvor_Griper:= TRUE;
				SC_VstupnyManipulator.Switch1:= TRUE;
			END_IF
			
			IF diVstupManipul_GriperZatvoreny THEN
				SC_VstupnyManipulator.ResetStep:= TRUE;
				SC_VstupnyManipulator.Step:= 103;
			END_IF
	
		103:
			SC_VstupnyManipulator.StepName:='103 - Automaticky rezim - otvorenie gripra manipulatora';
			SC_VstupnyManipulator.IdleTime.PT:= T#500ms;
			SC_VstupnyManipulator.AlarmTime.PT:= T#5s;
		
			IF NOT SC_VstupnyManipulator.Switch1 AND SC_OvlGripra.Step = 1 THEN
				Otvor_Griper:= TRUE;
				SC_VstupnyManipulator.Switch1:= TRUE;
			END_IF
			
			IF diVstupManipul_GriperOtvoreny THEN
				SC_VstupnyManipulator.ResetStep:= TRUE;
				SC_VstupnyManipulator.Step:= 104;
			END_IF
			
		104:
			SC_VstupnyManipulator.StepName:='104 - Automaticky rezim - zatvorenie gripra manipulatora';
			SC_VstupnyManipulator.IdleTime.PT:= T#500ms;
			SC_VstupnyManipulator.AlarmTime.PT:= T#5s;
		
			IF NOT SC_VstupnyManipulator.Switch1 AND SC_OvlGripra.Step = 1 THEN
				Zatvor_Griper:= TRUE;
				SC_VstupnyManipulator.Switch1:= TRUE;
			END_IF
			
			IF diVstupManipul_GriperZatvoreny THEN
				SC_VstupnyManipulator.ResetStep:= TRUE;
				SC_VstupnyManipulator.Step:= 108;
			END_IF
			
			
		108:
			SC_VstupnyManipulator.StepName:='102 - Automaticky rezim - zdvih manipulatora nad vstupny dopravnik, zistovanie NG kusu';
			SC_VstupnyManipulator.IdleTime.PT:= T#500ms;
			SC_VstupnyManipulator.AlarmTime.PT:= T#5s;
			SC_VstupnyManipulator.IdleTime.IN:= TRUE;
		
			IF NOT SC_VstupnyManipulator.Switch1 THEN
				Zdvih_Manipulatora:= TRUE;
				SC_VstupnyManipulator.Switch1:= TRUE;
			END_IF
		
			IF EDGEPOS(diVstupManipul_SpodSnimacNG_Kusu = TRUE) THEN
				IF diVstupManipul_HornSnimacNG_Kusu THEN
					VstupManipulator_Drzi_NG_Kus:= FALSE;
				ELSIF Zariadenie_PrebiehaRevorkRezim THEN
					VstupManipulator_Drzi_NG_Kus:= FALSE;
				ELSE	
					VstupManipulator_Drzi_NG_Kus:= TRUE;
				END_IF
			END_IF	
					
			IF diVstupManipul_ZasunutyHore THEN
				SC_VstupnyManipulator.ResetStep:= TRUE;
				SC_VstupnyManipulator.Step:= 110;
			END_IF
		
		110:
			SC_VstupnyManipulator.StepName:='104 - Automaticky rezim - presun manipulatora na poziciu vkladania';
			SC_VstupnyManipulator.IdleTime.PT:= T#500ms;
			SC_VstupnyManipulator.AlarmTime.PT:= T#5s;
		
			
			VstupManipulator_ZadanaPozMM:= TP_VstupManip_PoziciaUkladania; //9 mm
			
			IF NOT SC_VstupnyManipulator.Switch1 AND SC_OvlServoPojazdu.Step = 1 THEN			
				ServoPojazd_Polohuj:= TRUE;
				SC_VstupnyManipulator.Switch1:= TRUE;
			END_IF
		
			IF VstupManipulator_PojazdVPOZICI AND (VstupManipulator_AktualPozMM = TP_VstupManip_PoziciaUkladania) THEN
				VstupManipulator_PojazdVPOZICI:= FALSE;
				SC_VstupnyManipulator.ResetStep:= TRUE;
				SC_VstupnyManipulator.Step:= 120;
			END_IF
		
		
		
		
		
		120:
			SC_VstupnyManipulator.StepName:='120 - Automaticky rezim - kontrola stola';
			SC_VstupnyManipulator.IdleTime.PT:= T#500ms;
			SC_VstupnyManipulator.AlarmTime.PT:= T#5s;
		
			IF Stol_PoINIT AND NOT VstupManipulator_UkoncilCyklus AND diStol_SnimacPolohyStola AND NOT diStol_PritomnostRotoraVstup THEN
				SC_VstupnyManipulator.ResetStep:= TRUE;
				SC_VstupnyManipulator.Step:= 122;
			ELSIF Stol_PoINIT AND NOT VstupManipulator_UkoncilCyklus AND diStol_SnimacPolohyStola AND diStol_PritomnostRotoraVstup THEN
				VstupManipulator_UkoncilCyklus:= TRUE;
				SC_VstupnyManipulator.ResetStep:= TRUE;
				SC_VstupnyManipulator.Step:= 132;
			ELSIF VstupManipulator_KoniecCyklu THEN
				SC_VstupnyManipulator.ResetStep:= TRUE;
				SC_VstupnyManipulator.Step:= 0;		
			END_IF	
			
		
		
		
		122:
			SC_VstupnyManipulator.StepName:='122 - Automaticky rezim - polozenie rotora na stol';
			SC_VstupnyManipulator.IdleTime.PT:= T#200ms;
			SC_VstupnyManipulator.AlarmTime.PT:= T#5s;
			SC_VstupnyManipulator.AlarmTime.IN:= TRUE;
			
			
			IF NOT SC_VstupnyManipulator.Switch1 AND diStol_SnimacPolohyStola AND NOT diStol_PritomnostRotoraVstup AND Stol.IN.CentrovanieVysunute=1 THEN
				Zostup_Manipulatora:= TRUE;
				SC_VstupnyManipulator.Switch1:= TRUE;
			END_IF
		
			IF diVstupManipul_ZdvihStredPoloha THEN
				SC_VstupnyManipulator.IdleTime.IN:= TRUE;
			END_IF
			
			
			IF diVstupManipul_VysunutyDole OR SC_VstupnyManipulator.IdleTime.Q THEN
				SC_VstupnyManipulator.ResetStep:= TRUE;
				SC_VstupnyManipulator.Step:= 123;
			END_IF
			
								
			IF SC_VstupnyManipulator.AlarmTime.Q THEN
				Alarmy[23]:= TRUE;
				PoruchaVstupManipulator:= TRUE;
			END_IF	
			
		
		123:
			SC_VstupnyManipulator.StepName:='123 - Automaticky rezim - otvorenie gripra manipulatora';
			SC_VstupnyManipulator.IdleTime.PT:= T#500ms;
			SC_VstupnyManipulator.AlarmTime.PT:= T#5s;
		
			IF NOT SC_VstupnyManipulator.Switch1 THEN
				Otvor_Griper:= TRUE;
				SC_VstupnyManipulator.Switch1:= TRUE;
			END_IF
			
			IF diVstupManipul_GriperOtvoreny AND diVstupManipul_VysunutyDole THEN
				IF VstupManipulator_Drzi_NG_Kus THEN
					Stol_NG_KusNaStole:= TRUE;
				ELSE
					Stol_NG_KusNaStole:= FALSE;
				END_IF	
				VstupManipulator_Drzi_NG_Kus:= FALSE;
				SC_VstupnyManipulator.ResetStep:= TRUE;
				SC_VstupnyManipulator.Step:= 124;
			END_IF
		
		124:
			SC_VstupnyManipulator.StepName:='124 - Automaticky rezim - zdvih manipulatora nad stol, vystavenie signalu ukoncenie cyklu';
			SC_VstupnyManipulator.IdleTime.PT:= T#500ms;
			SC_VstupnyManipulator.AlarmTime.PT:= T#5s;
		
			IF NOT SC_VstupnyManipulator.Switch1 AND SC_OvlZdvihu.Step = 1 THEN
				Zdvih_Manipulatora:= TRUE;
				Stol.OUT.CentrovanieVysunut:=0;
				Stol.OUT.CentrovanieZasunut:=1;
				SC_VstupnyManipulator.Switch1:= TRUE;
			END_IF
		
			IF diVstupManipul_ZasunutyHore AND Stol.IN.CentrovanieZasunute=1 THEN
				IF diStol_PritomnostRotoraVstup THEN
					VstupManipulator_UkoncilCyklus:= TRUE;
				END_IF	
				SC_VstupnyManipulator.ResetStep:= TRUE;
				SC_VstupnyManipulator.Step:= 125;
			END_IF
		
		125:
			SC_VstupnyManipulator.StepName:='125 - Automaticky rezim - presun manipulatora na poziciu odoberania';
			SC_VstupnyManipulator.IdleTime.PT:= T#500ms;
			SC_VstupnyManipulator.AlarmTime.PT:= T#5s;
		
			VstupManipulator_ZadanaPozMM:= TP_VstupManip_PoziciaOdoberania;//602.0;
			
			IF NOT SC_VstupnyManipulator.Switch1 AND SC_OvlServoPojazdu.Step = 1 THEN
				ServoPojazd_Polohuj:= TRUE;
				SC_VstupnyManipulator.Switch1:= TRUE;
			END_IF
		
			IF VstupManipulator_PojazdVPOZICI AND (VstupManipulator_AktualPozMM = TP_VstupManip_PoziciaOdoberania) THEN
				VstupManipulator_PojazdVPOZICI:= FALSE;
				SC_VstupnyManipulator.ResetStep:= TRUE;
				SC_VstupnyManipulator.Step:= 100;
			END_IF
		
		
			
		132:
			SC_VstupnyManipulator.StepName:='132 - Automaticky rezim - cakanie na otocenie stola';
			SC_VstupnyManipulator.IdleTime.PT:= T#500ms;
			SC_VstupnyManipulator.AlarmTime.PT:= T#5s;
		
			IF NOT VstupManipulator_UkoncilCyklus THEN
				SC_VstupnyManipulator.ResetStep:= TRUE;
				SC_VstupnyManipulator.Step:= 100;
			ELSIF VstupManipulator_KoniecVyroby AND NOT Stol_Automat THEN
				SC_VstupnyManipulator.ResetStep:= TRUE;
				SC_VstupnyManipulator.Step:= 0;
			ELSIF VstupManipulator_KoniecCyklu THEN
				SC_VstupnyManipulator.ResetStep:= TRUE;
				SC_VstupnyManipulator.Step:= 0;		
			END_IF	
			
		
		
		//********************************************************Ruèný režim***********************************************************************************//
		700:
			SC_VstupnyManipulator.StepName:='700 - Rucny rezim';
		
		
			//Polohovanie manipulátora//
			IF RR_PoziciaOdoberania AND SC_OvlServoPojazdu.Step = 1 THEN
				VstupManipul_Rychlost_MM_s:= TP_VstupManip_RychlostPojazdu;
				VstupManipulator_ZadanaPozMM:= TP_VstupManip_PoziciaOdoberania;
				ServoPojazd_Polohuj:= TRUE;
			ELSIF RR_PoziciaVkladaniaStol AND SC_OvlServoPojazdu.Step = 1 THEN
				VstupManipul_Rychlost_MM_s:= TP_VstupManip_RychlostPojazdu;
				VstupManipulator_ZadanaPozMM:= TP_VstupManip_PoziciaUkladania;
				ServoPojazd_Polohuj:= TRUE;
			END_IF	
		
		
		
		
		
		
		
		
		
	END_CASE
	
	
	
	
	 
				END_PROGRAM

PROGRAM _EXIT
				(* Insert code here *)
	 
				END_PROGRAM

