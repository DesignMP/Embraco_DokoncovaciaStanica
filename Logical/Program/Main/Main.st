
PROGRAM _INIT
	Slider:= 0;
	//0 - tlaèítko zobrazené, 1 - tlaèítko skryté//
	TP_ZobrazPopUpPrihlasenie:= 1;
	TP_ZobrazHlasenieResetZariadenia:= 1;
	TP_ZobrazHlasenieNizkaHladOleja:= 1;
	TP_ZobrazHlasenieZamkyVyblokov:= 1;
	VnutorneValcovanie_AKTIVNE:= TRUE;
	VonkajsieValcovanie_AKTIVNE:= FALSE;
	
END_PROGRAM

PROGRAM _CYCLIC
	
	//Volanie podprogramov//
	ZobrazenieTlacitok;
	OvladanieHydrauliky;
	OvladanieSafety;
	
	
	//Ovládanie osvetlenia bunky//
	IF NOT diBZ1_DvereZavrete OR NOT diBZ2_DvereZavrete OR NOT diBZ3_DvereZavrete OR NOT diBZ4_DvereZavrete OR NOT diBZ5_DvereZavrete OR NOT diBZ6_DvereZavrete THEN
		doLEDosvetlenie_BieleSvetlo:= TRUE;
		doLEDosvetlenie_ZeleneSvetlo:= FALSE;
		doLEDosvetlenie_CerveneSvetlo:= FALSE;
	ELSIF NastalaPorucha THEN
		doLEDosvetlenie_CerveneSvetlo:= TRUE;
		doLEDosvetlenie_BieleSvetlo:= FALSE;
		doLEDosvetlenie_ZeleneSvetlo:= FALSE;
	ELSIF Zariadenie_StavAutomat THEN
		doLEDosvetlenie_ZeleneSvetlo:= TRUE;
		doLEDosvetlenie_BieleSvetlo:= FALSE;
		doLEDosvetlenie_CerveneSvetlo:= FALSE;
	ELSE	
		doLEDosvetlenie_BieleSvetlo:= FALSE;
		doLEDosvetlenie_ZeleneSvetlo:= FALSE;
		doLEDosvetlenie_CerveneSvetlo:= FALSE;
	END_IF	
	
		
	
	//Zobrazenie úvodnej obrazovky//
	IF NOT SafetyPLC_Nabehlo THEN
		CisloZadanejObrazovky:= 0;
		IF EDGEPOS (Blikac500ms = TRUE) THEN
			Slider:= Slider+1;
			IF Slider > 10 THEN
				Slider:= 0;
			END_IF
		END_IF
	END_IF
	
	//Prepnutie na hlavnú obrazovku//
	IF EDGEPOS (SafetyPLC_Nabehlo = TRUE) THEN
		CisloZadanejObrazovky:= 1;
	ELSIF EDGENEG(BezpOkruhOplotenia_Aktivovany = TRUE) AND CisloAktualnejObrazovky <> 100 THEN
		CisloZadanejObrazovky:= 1;
	ELSIF SafetyPLC_Nabehlo AND CisloAktualnejObrazovky = 0 THEN
		CisloZadanejObrazovky:= 1;
	END_IF	
	
	//Prepnutie na hlavnú obrazovku ruèného režimu pri poruche//
//	IF EDGEPOS (NastalaPorucha = TRUE) THEN
//		IF Zariadenie_StavManual AND CisloAktualnejObrazovky <> 20 THEN
//			CisloZadanejObrazovky:= 20;
//		END_IF	
//	END_IF	
	
	//Prepnutie na obrazovku alarmov pri poruche//
	IF EDGEPOS (NastalaPorucha) THEN
		CisloZadanejObrazovky:= 102;
	END_IF	
	
	
	//Zariadenie stav Homing OK//
	IF VstupManipulator_HomingOK AND Valcovanie_HomingOK AND VystupManipulator_HomingOK AND Valcovanie2_HomingOK THEN
		Zariadenie_HomingOK:= TRUE;
	ELSE	
		Zariadenie_HomingOK:= FALSE;
	END_IF	
	
		
	//Zariadenie stav Automat//
	IF Meranie_Automat OR Oddelovac_Automat OR ZdvihRotora_Automat OR Razenie_Automat OR Stol_Automat OR Strihanie_Automat OR Valcovanie_Automat OR Valcovanie2_Automat OR VstupManipulator_Automat OR VystupManipulator_Automat OR VystupOdsuvac_Automat THEN
		Zariadenie_StavAutomat:= TRUE;
	ELSE	
		Zariadenie_StavAutomat:= FALSE;
		Zariadenie_PrebiehaUkoncenie:= FALSE;
		Zariadenie_PrebiehaKoniecCyklu:= FALSE;
		Zariadenie_PrebiehaRevorkRezim:= FALSE;
	END_IF	
	
	//Zariadenie stav Manual//
	IF Meranie_Manual OR Oddelovac_Manual OR ZdvihRotora_Manual OR Razenie_Manual OR Stol_Manual OR Strihanie_Manual OR Valcovanie_Manual OR Valcovanie2_Manual OR VstupManipulator_Manual OR VystupManipulator_Manual OR VystupOdsuvac_Manual THEN
		Zariadenie_StavManual:= TRUE;
	ELSE	
		Zariadenie_StavManual:= FALSE;
	END_IF
	
		
	//Zariadenie stav po inicializacii//
	IF Meranie_PoINIT AND Oddelovac_PoINIT AND ZdvihRotora_PoINIT AND Razenie_PoINIT AND Stol_PoINIT AND Strihanie_PoINIT AND Valcovanie_PoINIT AND Valcovanie2_PoINIT AND VstupManipulator_PoINIT AND VystupManipulator_PoINIT AND VystupOdsuvac_PoINIT THEN
		Zariadenie_StavPoINIT:= TRUE;
	ELSE
		Zariadenie_StavPoINIT:= FALSE;
	END_IF
	
	//Zariadenie stav prebieha homing//
	IF VstupManipulator_PrebiehaHoming OR Valcovanie_PrebiehaHoming OR Valcovanie2_PrebiehaHoming OR VystupManipulator_PrebiehaHoming THEN
		Zariadenie_PrebiehaHoming:= TRUE;
	ELSE	
		Zariadenie_PrebiehaHoming:= FALSE;
	END_IF	
	
	//Zariadenie stav moduly OK//
	IF Modul_DB1_OK AND Modul_DB2_OK AND Modul_DB3_OK AND Modul_DB4_OK AND Modul_DB5_OK AND Modul_DB6_OK THEN 
		Zariadenie_Moduly_OK:= TRUE;
	ELSE	
		Zariadenie_Moduly_OK:= FALSE;
	END_IF	
		
		
	//Spustenie výroby na zariadení//
	IF Zariadenie_Automat AND BezpOkruhOplotenia_Aktivovany THEN
		Meranie_Automat:= TRUE;
		Oddelovac_Automat:= TRUE;
		ZdvihRotora_Automat:= TRUE;
		Razenie_Automat:= TRUE;
		Stol_Automat:= TRUE;
		Strihanie_Automat:= TRUE;
		Valcovanie_Automat:= TRUE;
		Valcovanie2_Automat:= TRUE;
		VstupManipulator_Automat:= TRUE;
		VystupManipulator_Automat:= TRUE;
		VystupOdsuvac_Automat:= TRUE;
		Zariadenie_Automat:= FALSE;
	ELSIF Zariadenie_Automat AND NOT BezpOkruhOplotenia_Aktivovany THEN	
		Zariadenie_Automat:= FALSE;
	END_IF	
	
	
	//Spustenie revork režimu//
	IF Zariadenie_RevorkRezim AND BezpOkruhOplotenia_Aktivovany THEN
		Meranie_Automat:= TRUE;
		Oddelovac_Automat:= TRUE;
		ZdvihRotora_Automat:= TRUE;
		Razenie_Automat:= TRUE;
		Stol_Automat:= TRUE;
		Strihanie_Automat:= TRUE;
		Valcovanie_Automat:= TRUE;
		Valcovanie2_Automat:= TRUE;
		VstupManipulator_Automat:= TRUE;
		VystupManipulator_Automat:= TRUE;
		VystupOdsuvac_Automat:= TRUE;
		Zariadenie_PrebiehaRevorkRezim:= TRUE;
		Zariadenie_RevorkRezim:= FALSE;
	ELSIF Zariadenie_RevorkRezim AND NOT BezpOkruhOplotenia_Aktivovany THEN	
		Zariadenie_RevorkRezim:= FALSE;
	END_IF	

	
	//Vypnutie ruèného režimu na hlavnej obrazovke ruèného režimu//
	IF EDGEPOS(CisloAktualnejObrazovky = 20) THEN
		Meranie_Manual:= FALSE;
		Oddelovac_Manual:= FALSE;
		ZdvihRotora_Manual:= FALSE;
		Razenie_Manual:= FALSE;
		Stol_Manual:= FALSE;
		Strihanie_Manual:= FALSE;
		Valcovanie_Manual:= FALSE;
		Valcovanie2_Manual:= FALSE;
		VstupManipulator_Manual:= FALSE;
		VystupManipulator_Manual:= FALSE;
		VystupOdsuvac_Manual:= FALSE;
	END_IF
	
	//Ukonèenie výroby na zariadení//
	IF Zariadenie_KoniecVyroby THEN
		Meranie_KoniecVyroby:= TRUE;
		Oddelovac_KoniecVyroby:= TRUE;
		ZdvihRotora_KoniecVyroby:= TRUE;
		Razenie_KoniecVyroby:= TRUE;
		Stol_KoniecVyroby:= TRUE;
		Strihanie_KoniecVyroby:= TRUE;
		Valcovanie_KoniecVyroby:= TRUE;
		Valcovanie2_KoniecVyroby:= TRUE;
		VstupManipulator_KoniecVyroby:= TRUE;
		VystupManipulator_KoniecVyroby:= TRUE;
		VystupOdsuvac_KoniecVyroby:= TRUE;
		Zariadenie_PrebiehaUkoncenie:= TRUE;
		Zariadenie_KoniecVyroby:= FALSE;
	END_IF	
	
	//Ukonèenie pracovného cyklu//
	IF EDGEPOS(NastalaPorucha = TRUE) THEN
		Zariadenie_KoniecCyklu:= TRUE;
	END_IF	
	
	IF Zariadenie_KoniecCyklu THEN
		Oddelovac_KoniecCyklu:= TRUE;
		ZdvihRotora_KoniecCyklu:= TRUE;
		VstupManipulator_KoniecCyklu:= TRUE;
		Strihanie_KoniecCyklu:= TRUE;
		Razenie_KoniecCyklu:= TRUE;
		Valcovanie_KoniecCyklu:= TRUE;
		Valcovanie2_KoniecCyklu:= TRUE;
		Meranie_KoniecCyklu:= TRUE;
		Stol_KoniecCyklu:= TRUE;
		VystupManipulator_KoniecCyklu:= TRUE;
		VystupOdsuvac_KoniecCyklu:= TRUE;
		Zariadenie_PrebiehaKoniecCyklu:= TRUE;
		Zariadenie_KoniecCyklu:= FALSE;
	END_IF		
	
	
	
	//Resetovanie zariadenia//
	IF Zariadenie_Reset THEN
		Meranie_Reset:= TRUE; 
		Oddelovac_Reset:= TRUE;
		ZdvihRotora_Reset:= TRUE;
		Razenie_Reset:= TRUE;
		Stol_Reset:= TRUE;
		Strihanie_Reset:= TRUE;
		Valcovanie_Reset:= TRUE;
		Valcovanie2_Reset:= TRUE;
		VstupManipulator_Reset:= TRUE;
		VystupManipulator_Reset:= TRUE;
		VystupOdsuvac_Reset:= TRUE;
		Zariadenie_Reset:= FALSE;
	END_IF	
		
		
		
		
		
END_PROGRAM

PROGRAM _EXIT
			(* Insert code here *)
	 
			END_PROGRAM

