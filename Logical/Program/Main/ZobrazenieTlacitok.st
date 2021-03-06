
ACTION ZobrazenieTlacitok: 

	//Zamknutie tla��tka Manu�lny re�imm//
	IF BezpOkruhOplotenia_Aktivovany AND NOT NastalaPorucha AND Stav_ServaREADY AND Zariadenie_Moduly_OK THEN
		TP_ZamkniTlacitkoRezimManual:= 0;
	ELSE	
		TP_ZamkniTlacitkoRezimManual:= 1;
	END_IF
	
	//Zamknutie tla��tka Automatick� re�im//
	IF BezpOkruhOplotenia_Aktivovany AND NOT NastalaPorucha AND Stav_ServaREADY AND Zariadenie_Moduly_OK THEN
		TP_ZamkniTlacitkoRezimAutomat:= 0;
	ELSE	
		TP_ZamkniTlacitkoRezimAutomat:= 1;
	END_IF
	
	//Zamknutie tla��tka Revork re�im//
	IF NOT BezpOkruhOplotenia_Aktivovany THEN
		TP_ZamkniTlacitkoRezimRevork:= 1;
	ELSIF NastalaPorucha THEN
		TP_ZamkniTlacitkoRezimRevork:= 1;
	ELSIF NOT VnutorneValcovanie_AKTIVNE AND NOT VonkajsieValcovanie_AKTIVNE THEN
		TP_ZamkniTlacitkoRezimRevork:= 1;
	ELSIF Zariadenie_StavAutomat THEN
		TP_ZamkniTlacitkoRezimRevork:= 1;
	ELSE
		TP_ZamkniTlacitkoRezimRevork:= 0;
	END_IF	
	

	//Zamknutie tla��tok aktiv�cie valcovania//
	IF Zariadenie_StavAutomat THEN
		TP_ZamkniTlacitkaAktivValcovania:= 1;
	ELSE
		TP_ZamkniTlacitkaAktivValcovania:= 0;
	END_IF	
	
	//Zamknutie tla��tka �tart Automat//
	IF BezpOkruhOplotenia_Aktivovany AND NOT NastalaPorucha AND NOT Zariadenie_StavPoINIT AND NOT Zariadenie_PrebiehaUkoncenie AND Stav_ServaREADY AND Zariadenie_Moduly_OK AND VnutorneValcovanie_AKTIVNE AND NOT Zariadenie_PrebiehaRevorkRezim THEN
		TP_ZamkniTlacStartAutomat:= 0;
	ELSE	
		TP_ZamkniTlacStartAutomat:= 1;
	END_IF	
	
	//Blikanie tla��tka �tart Automat//
	IF Zariadenie_StavAutomat AND NOT Zariadenie_StavPoINIT THEN
		BlikanieTlacitkaStartZariadenia:= Blikac500ms;
	ELSIF Zariadenie_StavAutomat AND Zariadenie_StavPoINIT THEN	
		BlikanieTlacitkaStartZariadenia:= 1;
	ELSE	
		BlikanieTlacitkaStartZariadenia:= 0;
	END_IF	
	
	//Zamknutie tla��tka Ukon�enie v�roby//
	IF Zariadenie_StavPoINIT AND NOT Zariadenie_PrebiehaUkoncenie AND NOT Zariadenie_PrebiehaKoniecCyklu THEN
		TP_ZamkniTlacUkoncenieVyroby:= 0;
	ELSE	
		TP_ZamkniTlacUkoncenieVyroby:= 1;
	END_IF	
	
	//Zamknutie tla��tka Koniec cyklu//
	IF Zariadenie_StavPoINIT AND NOT Zariadenie_PrebiehaKoniecCyklu THEN
		TP_ZamkniTlacKoniecCyklu:= 0;
	ELSE	
		TP_ZamkniTlacKoniecCyklu:= 1;
	END_IF	
		
	//Zobrazenie tla��tka Home//
	IF Zariadenie_StavAutomat THEN
		TP_ZobrazTlacitkoHome:= 1;
	ELSIF FM_Menic[3].Output.Status.Running THEN
		TP_ZobrazTlacitkoHome:= 1;
	ELSE	
		TP_ZobrazTlacitkoHome:= 0;
	END_IF	
	
	
	//Zobrazenie hl�senia NG dopravn�k pln�//
	IF diVystDoprNG_SnimacZaplnTrate THEN
		CasZaplneniaDopravnikaNG.IN:= TRUE;
	ELSE	
		CasZaplneniaDopravnikaNG.IN:= FALSE;
	END_IF
	
	IF CasZaplneniaDopravnikaNG.Q THEN
		TP_ZobrazHlasenieDoprNG_Plny:= 0;
	ELSE	
		TP_ZobrazHlasenieDoprNG_Plny:= 1;
	END_IF
	
	
	CasZaplneniaDopravnikaNG.PT:= T#5s;	
	CasZaplneniaDopravnikaNG();	
		
	//Zobrazenie hl�senia OK dopravn�k pln�//
	IF diVystDoprOK_SnimacZaplnTrate THEN
		CasZaplneniaDopravnikaOK.IN:= TRUE;
	ELSE	
		CasZaplneniaDopravnikaOK.IN:= FALSE;
	END_IF
	
	IF CasZaplneniaDopravnikaOK.Q THEN
		TP_ZobrazHlasenieDoprOK_Plny:= 0;
	ELSE	
		TP_ZobrazHlasenieDoprOK_Plny:= 1;
	END_IF
		
		
	CasZaplneniaDopravnikaOK.PT:= T#5s;	
	CasZaplneniaDopravnikaOK();	
	
	//Zobrazenie hl�senia n�zka hladina oleja//
	IF NOT diValcovanie_HladinaOlejaOK THEN
		CasNizkaHladinaOleja.IN:= TRUE;
	ELSE	
		CasNizkaHladinaOleja.IN:= FALSE;
	END_IF	
		
	IF CasNizkaHladinaOleja.Q THEN
		TP_ZobrazHlasenieNizkaHladOleja:= 0;
	ELSE	
		TP_ZobrazHlasenieNizkaHladOleja:= 1;
	END_IF	
		
	CasNizkaHladinaOleja.PT:= T#5s;
	CasNizkaHladinaOleja();
	
	
	//Zobrazenie hl�senia - z�mky vyblokovan�//
	IF RezimServis THEN
		TP_ZobrazHlasenieZamkyVyblokov:= 0;
	ELSE	
		TP_ZobrazHlasenieZamkyVyblokov:= 1;
	END_IF	
	
	
	
	
	//Vstupn� manipul�tor - zamknutie pojazdu //
	IF VstupManipulator_HomingOK AND diVstupManipul_ZasunutyHore THEN
		TP_VstupManip_ZamkniTlacPojazdu:= 0;
	ELSE	
		TP_VstupManip_ZamkniTlacPojazdu:= 1;
	END_IF
	
	
	//Stanica strihania - zamknutie zdvihu rotora//
	IF diStol_SnimacPolohyStola AND Vyrazanie.IN.UchytenieNaliatkuOtvorene AND NOT Vyrazanie.IN.UchytenieNaliatkuZatvorene AND Vyrazanie.IN.OdhadzovanieJeVpredu AND Vyrazanie.IN.OdhadzovanieJeVpredu2 AND Vyrazanie.IN.UchytenieKolikaOtvorene AND NOT Vyrazanie.IN.UchytenieKolikaZatvorene THEN
		TP_Strihanie_ZamkniZdvihRotora:= 0;
	ELSE
		TP_Strihanie_ZamkniZdvihRotora:= 1;
	END_IF
	
	//Stanica razenia - zamknutie zdvihu rotora//
	IF diStol_SnimacPolohyStola THEN
		TP_Razenie_ZamkniZdvihRotora:= 0;
	ELSE
		TP_Razenie_ZamkniZdvihRotora:= 1;
	END_IF
	
	//Stanica valcovania - zamknutie zdvihu rotora//
	IF diStol_SnimacPolohyStola AND diValcovanie_GriperOtvoreny THEN
		TP_Valcovanie_ZamkniZdvihRotora:= 0;
	ELSE
		TP_Valcovanie_ZamkniZdvihRotora:= 1;
	END_IF
	
	//Stanica valcovania - zamknutie zdvihu n�stroja//
	IF Valcovanie_HomingOK THEN
		TP_Valcovanie_ZamkniZdvihServa:= 0;
	ELSE
		TP_Valcovanie_ZamkniZdvihServa:= 1;
	END_IF
	
	//Stanica valcovania 2 - zamknutie zdvihu rotora//
	IF NOT Valcovanie2_HomingOK THEN
		TP_Valcovanie2_ZamkniZdvihServa:= 1;
	ELSIF Valcovanie2_AktualPozMM >= Valcovanie2_ZadanaPozMM THEN
		TP_Valcovanie2_ZamkniZdvihServa:= 1;
	ELSE
		TP_Valcovanie2_ZamkniZdvihServa:= 0;
	END_IF	
	
	
	
	
	//Stanica valcovania 2 - zamknutie zostupu rotora//
	IF NOT Valcovanie2_HomingOK THEN
		TP_Valcovanie2_ZamkniZostupServa:= 1;
	ELSIF Valcovanie2_AktualPozMM <= 13 THEN
		TP_Valcovanie2_ZamkniZostupServa:= 1;
	ELSE
		TP_Valcovanie2_ZamkniZostupServa:= 0;
	END_IF		
		
	
		
	
	
	//Stol - zamknutie ot��ania//
	IF NOT Stol_BlokovanieOtacania THEN
		TP_Stol_ZamkniOtacanie:= 0;
	ELSE	
		TP_Stol_ZamkniOtacanie:= 1;
	END_IF
	
	//Stanica merania - zamknutie zdvihu rotora//
	IF diStol_SnimacPolohyStola THEN
		TP_Meranie_ZamkniZdvihRotora:= 0;
	ELSE
		TP_Meranie_ZamkniZdvihRotora:= 1;
	END_IF
	
	
	//V�stupn� manipul�tor - zamknutie pojazdu//
	IF VystupManipulator_HomingOK AND diVystupManipul_ZasunutyHore THEN
		TP_VystupManip_ZamkniTlacPojazdu:= 0;
	ELSE
		TP_VystupManip_ZamkniTlacPojazdu:= 1;
	END_IF
	
	//V�stupn� ods�va� - zamknutie vysunutia//
	IF diVystupManipul_ZasunutyHore THEN
		TP_VystOdsuvac_ZamkniTlacVysunut:= 0;
	ELSE	
		TP_VystOdsuvac_ZamkniTlacVysunut:= 1;
	END_IF
	
	
	//Zamknutie z�mkov oplotenia//
	IF Zariadenie_StavAutomat THEN
		TP_ZamkniTlacitkaZamkovOplotenia:= 1;
	ELSIF FM_Menic[3].Output.Status.Running THEN
		TP_ZamkniTlacitkaZamkovOplotenia:= 1;
	ELSE
		TP_ZamkniTlacitkaZamkovOplotenia:= 0;
	END_IF
	
	//Zamknutie tla��tka servis//
	IF ZvolenaUroven = 1000 THEN
		TP_ZamkniTlacitkoServis:= 0;
	ELSE	
		TP_ZamkniTlacitkoServis:= 1;
		RezimServis:= FALSE;
	END_IF
	
	//***************************************Zamknutie parametrov nastavenia zariadenia***************************************************************//
	IF ZvolenaUroven < 10 THEN
		TP_ZamkniParametreUrovenOperator:= 2;
	ELSE	
		TP_ZamkniParametreUrovenOperator:= 0;
	END_IF
	
	IF ZvolenaUroven < 20 THEN
		TP_ZamkniParametreUrovenServisak:= 2;
	ELSE	
		TP_ZamkniParametreUrovenServisak:= 0;
	END_IF	
	
	
	
	
	
	
	
	
	
	
	
	
	//0-siv�, 1- �lt�, 2- zelen�, 3- �erven�//
	//Stav vstupn�ho oddelova�a//
	IF PoruchaOddelovaca THEN
		StavOddelovaca:= 3;
	ELSIF NOT Oddelovac_Automat THEN
		StavOddelovaca:= 0;
	ELSIF Oddelovac_Automat AND NOT Oddelovac_PoINIT THEN
		StavOddelovaca:= 1;
	ELSIF Oddelovac_Automat AND Oddelovac_PoINIT THEN
		StavOddelovaca:= 2;
	END_IF
	
	//Stav zdvihu rotora na vstupnom dopravn�ku//
	IF PoruchaZdvihuRotora THEN
		StavZdvihuRotora:= 3;
	ELSIF NOT ZdvihRotora_Automat THEN
		StavZdvihuRotora:= 0;
	ELSIF ZdvihRotora_Automat AND NOT ZdvihRotora_PoINIT THEN
		StavZdvihuRotora:= 1;
	ELSIF ZdvihRotora_Automat AND ZdvihRotora_PoINIT THEN	
		StavZdvihuRotora:= 2;
	END_IF	
	
	
	//Stav vstupn�ho manipul�tora//
	IF PoruchaVstupManipulator THEN
		StavVstupnehoManipulatora:= 3;
	ELSIF NOT VstupManipulator_Automat THEN
		StavVstupnehoManipulatora:= 0;
	ELSIF VstupManipulator_Automat AND NOT VstupManipulator_PoINIT THEN
		StavVstupnehoManipulatora:= 1;
	ELSIF VstupManipulator_Automat AND VstupManipulator_PoINIT THEN
		StavVstupnehoManipulatora:= 2;
	END_IF	
		
		
	//Stav stola//
	IF PoruchaOtocnyStol THEN
		StavStola:= 3;
	ELSIF NOT Stol_Automat THEN
		StavStola:= 0;
	ELSIF Stol_Automat AND NOT Stol_PoINIT THEN
		StavStola:= 1;
	ELSIF Stol_Automat AND Stol_PoINIT THEN
		StavStola:= 2;
	END_IF	
	
	//Stav strihania//
	IF PoruchaStanicaStrihania THEN
		StavStrihania:= 3;
	ELSIF NOT Strihanie_Automat THEN
		StavStrihania:= 0;
	ELSIF Strihanie_Automat AND NOT Strihanie_PoINIT THEN	
		StavStrihania:= 1;
	ELSIF Strihanie_Automat AND Strihanie_PoINIT THEN	
		StavStrihania:= 2;
	END_IF	
		
		
	//Stav razenia//
	IF PoruchaStanicaRazenia THEN
		StavRazenia:= 3;
	ELSIF NOT Razenie_Automat THEN	
		StavRazenia:= 0;
	ELSIF Razenie_Automat AND NOT Razenie_PoINIT THEN	
		StavRazenia:= 1;
	ELSIF Razenie_Automat AND Razenie_PoINIT THEN		
		StavRazenia:= 2;
	END_IF	
		
		
	//Stav valcovania//
	IF PoruchaStanicaValcovania THEN
		StavValcovania:= 3;
	ELSIF NOT Valcovanie_Automat THEN
		StavValcovania:= 0;
	ELSIF Valcovanie_Automat AND NOT Valcovanie_PoINIT THEN
		StavValcovania:= 1;
	ELSIF Valcovanie_Automat AND Valcovanie_PoINIT THEN
		StavValcovania:= 2;
	END_IF	
	
	//Stav valcovania 2//
	IF PoruchaStanicaValcovania2 THEN
		StavValcovania2:= 3;
	ELSIF NOT Valcovanie2_Automat THEN
		StavValcovania2:= 0;
	ELSIF Valcovanie2_Automat AND NOT Valcovanie2_PoINIT THEN
		StavValcovania2:= 1;
	ELSIF Valcovanie2_Automat AND Valcovanie2_PoINIT THEN
		StavValcovania2:= 2;
	END_IF	
	
	
	
	//Stav merania//
	IF PoruchaStanicaMerania THEN
		StavMerania:= 3;
	ELSIF NOT Meranie_Automat THEN
		StavMerania:= 0;
	ELSIF Meranie_Automat AND NOT Meranie_PoINIT THEN	
		StavMerania:= 1;
	ELSIF Meranie_Automat AND Meranie_PoINIT THEN	
		StavMerania:= 2;
	END_IF	
		
		
	//Stav v�stupn�ho manipul�tora//
	IF PoruchaVystupManipulator THEN
		StavVystupnehoManipulatora:= 3;
	ELSIF NOT VystupManipulator_Automat THEN
		StavVystupnehoManipulatora:= 0;
	ELSIF VystupManipulator_Automat AND NOT VystupManipulator_PoINIT THEN 	
		StavVystupnehoManipulatora:= 1;
	ELSIF VystupManipulator_Automat AND VystupManipulator_PoINIT THEN
		StavVystupnehoManipulatora:= 2;
	END_IF	
	
	
	
	//Stav v�stupn�ho ods�va�a//
	IF PoruchaVystupOdsuvac THEN
		StavVystupnehoOdsuvaca:= 3;
	ELSIF NOT VystupOdsuvac_Automat THEN	
		StavVystupnehoOdsuvaca:= 0;
	ELSIF VystupOdsuvac_Automat AND NOT VystupOdsuvac_PoINIT THEN	
		StavVystupnehoOdsuvaca:= 1;
	ELSIF VystupOdsuvac_Automat AND VystupOdsuvac_PoINIT THEN
		StavVystupnehoOdsuvaca:= 2;
	END_IF	
	
	
	
	//Stav bezpe�nostn�ho z�mku BZ1//
	IF diBZ1_DvereZavrete AND NOT Stav_BZ1_Zamknuty THEN
		StavZamkuBZ1:= Blikac500ms;
	ELSIF diBZ1_DvereZavrete AND Stav_BZ1_Zamknuty THEN
		StavZamkuBZ1:= 2;
	ELSE	
		StavZamkuBZ1:= 3;
	END_IF	
	
	//Stav bezpe�nostn�ho z�mku BZ2//
	IF diBZ2_DvereZavrete AND NOT Stav_BZ2_Zamknuty THEN
		StavZamkuBZ2:= Blikac500ms;
	ELSIF diBZ2_DvereZavrete AND Stav_BZ2_Zamknuty THEN
		StavZamkuBZ2:= 2;
	ELSE	
		StavZamkuBZ2:= 3;
	END_IF	
	
	//Stav bezpe�nostn�ho z�mku BZ3//
	IF diBZ3_DvereZavrete AND NOT Stav_BZ3_Zamknuty THEN
		StavZamkuBZ3:= Blikac500ms;
	ELSIF diBZ3_DvereZavrete AND Stav_BZ3_Zamknuty THEN
		StavZamkuBZ3:= 2;
	ELSE	
		StavZamkuBZ3:= 3;
	END_IF	
	
	//Stav bezpe�nostn�ho z�mku BZ4//
	IF diBZ4_DvereZavrete AND NOT Stav_BZ4_Zamknuty THEN
		StavZamkuBZ4:= Blikac500ms;
	ELSIF diBZ4_DvereZavrete AND Stav_BZ4_Zamknuty THEN
		StavZamkuBZ4:= 2;
	ELSE	
		StavZamkuBZ4:= 3;
	END_IF	
	
	//Stav bezpe�nostn�ho z�mku BZ5//
	IF diBZ5_DvereZavrete AND NOT Stav_BZ5_Zamknuty THEN
		StavZamkuBZ5:= Blikac500ms;
	ELSIF diBZ5_DvereZavrete AND Stav_BZ5_Zamknuty THEN
		StavZamkuBZ5:= 2;
	ELSE	
		StavZamkuBZ5:= 3;
	END_IF	
	
	//Stav bezpe�nostn�ho z�mku BZ6//
	IF diBZ6_DvereZavrete AND NOT Stav_BZ6_Zamknuty THEN
		StavZamkuBZ6:= Blikac500ms;
	ELSIF diBZ6_DvereZavrete AND Stav_BZ6_Zamknuty THEN
		StavZamkuBZ6:= 2;
	ELSE	
		StavZamkuBZ6:= 3;
	END_IF	
	
		
		END_ACTION
