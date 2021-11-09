
ACTION OvladanieSafety: 

	diStavReleKA100_KA101;
	diStavReleKA102_KA103;
	diStavReleKA104_KA105;
	diStav_PrivodVzduchuKanalA;
	diStav_PrivodVzduchuKanalB;
	Reset_CS;
	Reset_Oplotenia;
	SafetyPLC_Nabehlo;
	BezpOkruhCS_Aktivovany;
	BezpOkruhOplotenia_Aktivovany;
	Stav_CS_Odblokovane;
	Stav_BZ1_Zamknuty;
	Stav_BZ2_Zamknuty;
	Stav_BZ3_Zamknuty;
	Stav_BZ4_Zamknuty;
	Stav_BZ5_Zamknuty;
	Stav_BZ6_Zamknuty;
	RezimServis;
	
	
	//Ovladanie dverí è.1//
	IF EDGEPOS (Zamkni_BZ1 = TRUE) AND BezpOkruhCS_Aktivovany THEN
		IF diBZ1_DvereZavrete AND NOT Stav_BZ1_Zamknuty THEN
			doBZ1_ZamkniZamok:= TRUE;
		ELSIF diBZ1_DvereZavrete AND Stav_BZ1_Zamknuty AND NOT Zariadenie_StavAutomat THEN
			doBZ1_ZamkniZamok:= FALSE;
		END_IF
	ELSIF NOT BezpOkruhCS_Aktivovany THEN
		doBZ1_ZamkniZamok:= FALSE;	
	END_IF	
	
	//Ovladanie dverí è.2//
	IF EDGEPOS (Zamkni_BZ2 = TRUE) AND BezpOkruhCS_Aktivovany THEN
		IF diBZ2_DvereZavrete AND NOT Stav_BZ2_Zamknuty THEN
			doBZ2_ZamkniZamok:= TRUE;
		ELSIF diBZ2_DvereZavrete AND Stav_BZ2_Zamknuty AND NOT Zariadenie_StavAutomat THEN
			doBZ2_ZamkniZamok:= FALSE;
		END_IF
	ELSIF NOT BezpOkruhCS_Aktivovany THEN
		doBZ2_ZamkniZamok:= FALSE;		
	END_IF
	
	//Ovladanie dverí è.3//
	IF EDGEPOS (Zamkni_BZ3 = TRUE) AND BezpOkruhCS_Aktivovany THEN
		IF diBZ3_DvereZavrete AND NOT Stav_BZ3_Zamknuty THEN
			doBZ3_ZamkniZamok:= TRUE;
		ELSIF diBZ3_DvereZavrete AND Stav_BZ3_Zamknuty AND NOT Zariadenie_StavAutomat THEN
			doBZ3_ZamkniZamok:= FALSE;
		END_IF
	ELSIF NOT BezpOkruhCS_Aktivovany THEN
		doBZ3_ZamkniZamok:= FALSE;		
	END_IF
	
	//Ovladanie dverí è.4//
	IF EDGEPOS (Zamkni_BZ4 = TRUE) AND BezpOkruhCS_Aktivovany THEN
		IF diBZ4_DvereZavrete AND NOT Stav_BZ4_Zamknuty THEN
			doBZ4_ZamkniZamok:= TRUE;
		ELSIF diBZ4_DvereZavrete AND Stav_BZ4_Zamknuty AND NOT Zariadenie_StavAutomat THEN
			doBZ4_ZamkniZamok:= FALSE;
		END_IF
	ELSIF NOT BezpOkruhCS_Aktivovany THEN
		doBZ4_ZamkniZamok:= FALSE;		
	END_IF
	
	//Ovladanie dverí è.5//
	IF EDGEPOS (Zamkni_BZ5 = TRUE) AND BezpOkruhCS_Aktivovany THEN
		IF diBZ5_DvereZavrete AND NOT Stav_BZ5_Zamknuty THEN
			doBZ5_ZamkniZamok:= TRUE;
		ELSIF diBZ5_DvereZavrete AND Stav_BZ5_Zamknuty AND NOT Zariadenie_StavAutomat THEN
			doBZ5_ZamkniZamok:= FALSE;
		END_IF
	ELSIF NOT BezpOkruhCS_Aktivovany THEN
		doBZ5_ZamkniZamok:= FALSE;		
	END_IF
	
	//Ovladanie dverí è.6//
	IF EDGEPOS (Zamkni_BZ6 = TRUE) AND BezpOkruhCS_Aktivovany THEN
		IF diBZ6_DvereZavrete AND NOT Stav_BZ6_Zamknuty THEN
			doBZ6_ZamkniZamok:= TRUE;
		ELSIF diBZ6_DvereZavrete AND Stav_BZ6_Zamknuty AND NOT Zariadenie_StavAutomat THEN
			doBZ6_ZamkniZamok:= FALSE;
		END_IF
	ELSIF NOT BezpOkruhCS_Aktivovany THEN
		doBZ6_ZamkniZamok:= FALSE;		
	END_IF
	
	
	//Resetovanie oplotenia//
	IF ((Stav_BZ1_Zamknuty AND Stav_BZ2_Zamknuty AND Stav_BZ3_Zamknuty AND Stav_BZ4_Zamknuty AND Stav_BZ5_Zamknuty AND Stav_BZ6_Zamknuty) OR RezimServis) AND BezpOkruhCS_Aktivovany THEN
		CasPredResetomOplotenia.IN:= TRUE;
	ELSE
		CasPredResetomOplotenia.IN:= FALSE;
	END_IF
	
	IF CasPredResetomOplotenia.Q AND NOT BezpOkruhOplotenia_Aktivovany AND BezpOkruhCS_Aktivovany THEN
		Reset_Oplotenia:= TRUE;
	ELSE	
		Reset_Oplotenia:= FALSE;
	END_IF	
	
	
	CasPredResetomOplotenia.PT:= T#500ms;
	CasPredResetomOplotenia();
	
	
	
	
	//Podsvietenie tlaèítka reset CS//
	IF Stav_CS_Odblokovane AND NOT BezpOkruhCS_Aktivovany THEN
		TP_ModraLEDResetCS:= Blikac500ms;
	ELSIF BezpOkruhCS_Aktivovany THEN
		TP_ModraLEDResetCS:= 2;
	ELSE
		TP_ModraLEDResetCS:= 3;
	END_IF	
	
	
	
	//Podsvietenie tlaèítka reset oplotenia//
	IF BezpOkruhCS_Aktivovany AND Stav_BZ1_Zamknuty AND Stav_BZ2_Zamknuty AND Stav_BZ3_Zamknuty AND Stav_BZ4_Zamknuty AND Stav_BZ5_Zamknuty AND Stav_BZ6_Zamknuty AND NOT BezpOkruhOplotenia_Aktivovany THEN
		TP_ModraLEDResetOplotenia:= Blikac500ms; 
	ELSIF (RezimServis OR BezpOkruhOplotenia_Aktivovany) AND BezpOkruhCS_Aktivovany THEN
		TP_ModraLEDResetOplotenia:= 2; 
	ELSE
		TP_ModraLEDResetOplotenia:= 3;
	END_IF	
	
	
	
	
		
	
END_ACTION
