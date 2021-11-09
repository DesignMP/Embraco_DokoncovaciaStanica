
PROGRAM _INIT
	T_otvorenieCentrovania.PT:=T#500ms;
END_PROGRAM

PROGRAM _CYCLIC
	T_otvorenieCentrovania();
	
	//Volanie podprogramov//
	OvladanieGripraNaliatku;
	OvladanieGripraStriznika;
	OvladanieOdkloneniaGriprov;
	OvladanieZdvihu;
	
	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_Strihanie);
	
	//Reset sekcie //
	IF Strihanie_Reset OR NOT BezpOkruhOplotenia_Aktivovany OR PoruchaStanicaStrihania THEN
		SC_Strihanie.Step:= 0;
	END_IF
	
	//otvaranie centrovania	
	IF Vyrazanie.IN.VyrazanieJeDole=1 THEN
		T_otvorenieCentrovania.IN:=0;
	END_IF
	
	IF EDGEPOS (T_otvorenieCentrovania.Q=1) THEN
		T_otvorenieCentrovania.IN:=0;
		Vyrazanie.OUT.CentrovanieOtvorit:=1;
		Vyrazanie.OUT.CentrovanieZatvorit:=0;
	END_IF
	
	
	
	CASE SC_Strihanie.Step OF 
	
	
		0:
			SC_Strihanie.StepName:='0 - Nulovanie';
			SC_OvlGripraNaliatku.Step:= 0;
			SC_OvlGripraStriznika.Step:= 0;
			SC_OvlOdklonenia.Step:= 0;
			SC_OvlZdvihu.Step:= 0;
			Strihanie_Automat:= FALSE;
			Strihanie_KoniecVyroby:= FALSE;
			Strihanie_KoniecCyklu:= FALSE;
			Strihanie_Manual:= FALSE;
			Strihanie_PoINIT:= FALSE;
			Strihanie_Reset:= FALSE;
			Strihanie_UkoncilCyklus:= FALSE;
			PocetOtvoreniGriprov:= 0;
			GriperStriznika_ZATVORENY:= FALSE;
			GriperNaliatkuZATVORENY:= FALSE;
			Strihanie_SpustiRazenie:= FALSE;
			IF BezpOkruhOplotenia_Aktivovany AND NOT PoruchaStanicaStrihania THEN
				SC_Strihanie.ResetStep:= TRUE;
				SC_Strihanie.Step:= 1;
			END_IF
	
		1:
			SC_Strihanie.StepName:='1 - Rozhodnutie o cinnosti';
			IF Strihanie_Automat THEN
				SC_Strihanie.Step:= 2;
			ELSIF Strihanie_Manual THEN
				SC_Strihanie.Step:= 700;
			END_IF
		
		
			//********************************************************Inicializácia****************************************************************************//
		2:
			SC_Strihanie.StepName:='2 - Inicializacia - cakanie na spustenie';
			SC_Strihanie.IdleTime.PT:= T#500ms;
			SC_Strihanie.AlarmTime.PT:= T#5s;
			SC_Strihanie.IdleTime.IN:= TRUE;
				
			
			IF SC_Strihanie.IdleTime.Q THEN
				SC_Strihanie.ResetStep:= TRUE;
				SC_Strihanie.Step:= 3;
			END_IF
	
		3:
			SC_Strihanie.StepName:='3 - Inicializacia - zasunutie zdvihu rotora';
			SC_Strihanie.IdleTime.PT:= T#500ms;
			SC_Strihanie.AlarmTime.PT:= T#5s;
		
			IF NOT SC_Strihanie.Switch1 THEN
				Rotor_POLOZ:= TRUE;
				SC_Strihanie.Switch1:= TRUE;
			END_IF
		
			IF Vyrazanie.IN.VyrazanieJeDole THEN
				SC_Strihanie.ResetStep:= TRUE;
				SC_Strihanie.Step:= 4;
			END_IF
		
			
		
		4:
			SC_Strihanie.StepName:='4 - Inicializacia -  kontrola otvorenia griprov';
			SC_Strihanie.IdleTime.PT:= T#500ms;
			SC_Strihanie.AlarmTime.PT:= T#5s;	
		
			IF Vyrazanie.IN.UchytenieKolikaDrzimkus OR Vyrazanie.IN.UchytenieKolikaDrzimkus THEN
				SC_Strihanie.ResetStep:= TRUE;
				SC_Strihanie.Step:= 5;
			ELSIF Vyrazanie.IN.UchytenieNaliatkuOtvorene AND Vyrazanie.IN.UchytenieKolikaOtvorene THEN
				SC_Strihanie.ResetStep:= TRUE;
				SC_Strihanie.Step:= 7;
			END_IF	
		
		
		5:
			SC_Strihanie.StepName:='4 - Inicializacia -  otocenie griprov do pozicie odhodenia';
			SC_Strihanie.IdleTime.PT:= T#500ms;
			SC_Strihanie.AlarmTime.PT:= T#5s;	
		
			IF NOT SC_Strihanie.Switch1 THEN
				OdklonGriprov_ZAHODENIE:= TRUE;
				SC_Strihanie.Switch1:= TRUE;
			END_IF
		
			IF Vyrazanie.IN.OdhadzovanieJeVzadu THEN
				SC_Strihanie.ResetStep:= TRUE;
				SC_Strihanie.Step:= 6;
			END_IF
		
		6:
			SC_Strihanie.StepName:='6 - Inicializacia - otvorenie griprov';
			SC_Strihanie.IdleTime.PT:= T#500ms;
			SC_Strihanie.AlarmTime.PT:= T#5s;
		
			IF NOT SC_Strihanie.Switch1 THEN
				GriperNaliatku_OTVOR:= TRUE;
				GriperStriznika_OTVOR:= TRUE;
				SC_Strihanie.Switch1:= TRUE;
			END_IF
		
			IF Vyrazanie.IN.UchytenieKolikaOtvorene AND Vyrazanie.IN.UchytenieNaliatkuOtvorene THEN
				SC_Strihanie.ResetStep:= TRUE;
				SC_Strihanie.Step:= 7;
			END_IF
		
		
		
		7:
			SC_Strihanie.StepName:='7 - Inicializacia - otocenie griprov do pozicie odoberania';
			SC_Strihanie.IdleTime.PT:= T#500ms;
			SC_Strihanie.AlarmTime.PT:= T#5s;
			SC_Strihanie.IdleTime.IN:= TRUE;
		
			IF NOT SC_Strihanie.Switch1 AND SC_Strihanie.IdleTime.Q THEN
				OdklonGriprov_ODOBERANIE:= TRUE;
				SC_Strihanie.Switch1:= TRUE;
			END_IF
		
			IF Vyrazanie.IN.OdhadzovanieJeVpredu THEN
				Strihanie_PoINIT:= TRUE;
				SC_Strihanie.ResetStep:= TRUE;
				SC_Strihanie.Step:= 8;
			END_IF
			
		8:
			SC_Strihanie.StepName:='8 - Inicializacia - otvorenie centrovania';
			SC_Strihanie.IdleTime.PT:= T#500ms;
			SC_Strihanie.AlarmTime.PT:= T#5s;
			SC_Strihanie.IdleTime.IN:= TRUE;
		
			IF NOT SC_Strihanie.Switch1 AND SC_Strihanie.IdleTime.Q THEN
				Vyrazanie.OUT.CentrovanieOtvorit:= TRUE;
				Vyrazanie.OUT.CentrovanieZatvorit:= FALSE;
				SC_Strihanie.Switch1:= TRUE;
			END_IF
		
			IF Vyrazanie.IN.CentrovanieOtvorene THEN
				Strihanie_PoINIT:= TRUE;
				SC_Strihanie.ResetStep:= TRUE;
				SC_Strihanie.Step:= 100;
			END_IF
		
		
			//********************************************************Automatický režim****************************************************************************//
		100:
			SC_Strihanie.StepName:='100 - Automaticky rezim - cakanie na start cyklu';
			SC_Strihanie.IdleTime.PT:= T#500ms;
			SC_Strihanie.AlarmTime.PT:= T#5s;
		
            SC_Strihanie.IdleTime.IN:= NOT Vyrazanie.IN.KusPritomny;
            
			IF Strihanie_KoniecCyklu THEN
				SC_Strihanie.ResetStep:= TRUE;
				SC_Strihanie.Step:= 0;
			ELSIF Zariadenie_PrebiehaRevorkRezim THEN
				Strihanie_UkoncilCyklus:= TRUE;
                SC_Strihanie.ResetStep:= TRUE;
				SC_Strihanie.Step:= 120; 
			ELSIF Stol_PoINIT AND NOT Strihanie_UkoncilCyklus AND Vyrazanie.IN.KusPritomny AND diStol_SnimacPolohyStola THEN
				SC_Strihanie.ResetStep:= TRUE;
				SC_Strihanie.Step:= 101;
			ELSIF Stol_PoINIT AND NOT Strihanie_UkoncilCyklus AND NOT Vyrazanie.IN.KusPritomny AND SC_Strihanie.IdleTime.Q AND diStol_SnimacPolohyStola THEN
				Strihanie_UkoncilCyklus:= TRUE;
                Strihanie_SpustiRazenie:= TRUE;
				SC_Strihanie.ResetStep:= TRUE;
				SC_Strihanie.Step:= 120; 
			ELSIF Strihanie_KoniecVyroby AND NOT Stol_Automat THEN
				SC_Strihanie.ResetStep:= TRUE;
				SC_Strihanie.Step:= 0;
			END_IF
			
		101:
			SC_Strihanie.StepName:='101 - Automaticky rezim - zacentrovanie rotora';
			SC_Strihanie.IdleTime.PT:= T#500ms;
			SC_Strihanie.AlarmTime.PT:= T#5s;
		
			IF NOT SC_Strihanie.Switch1 THEN
				Vyrazanie.OUT.CentrovanieZatvorit:= TRUE;
				Vyrazanie.OUT.CentrovanieOtvorit:= FALSE;
				SC_Strihanie.Switch1:= TRUE;
			END_IF
		
			IF Vyrazanie.IN.CentrovanieZatvorene THEN
				SC_Strihanie.ResetStep:= TRUE;
				SC_Strihanie.Step:= 102; (*102*)
			END_IF
			
		102:
			SC_Strihanie.StepName:='102 - Automaticky rezim - zodvihnutie rotora';
			SC_Strihanie.IdleTime.PT:= T#500ms;
			SC_Strihanie.AlarmTime.PT:= T#5s;
		
			IF NOT SC_Strihanie.Switch1 THEN
				Rotor_ZDVIHNI:= TRUE;
				SC_Strihanie.Switch1:= TRUE;
			END_IF
		
			IF Vyrazanie.IN.VyrazanieJeHore AND NOT PAUZA THEN
				SC_Strihanie.ResetStep:= TRUE;
				SC_Strihanie.Step:= 103;
			END_IF
		
		103:
			SC_Strihanie.StepName:='103 - Automaticky rezim - zatvorenie griprov, zasunutie zdvihu rotora,otocenie griprov';
			SC_Strihanie.IdleTime.PT:= T#500ms;
			SC_Strihanie.AlarmTime.PT:= T#5s;
		
			IF NOT SC_Strihanie.Switch1 THEN
				GriperNaliatku_ZATVOR:= TRUE;
				GriperStriznika_ZATVOR:= TRUE;
				Strihanie_SpustiRazenie:= TRUE;
				SC_Strihanie.Switch1:= TRUE;
			END_IF
			
					
			IF Vyrazanie.IN.UchytenieKolikaDrzimkus AND Vyrazanie.IN.UchytenieNaliatkuDrzimkus THEN
				T_otvorenieCentrovania.IN:=1;
				Rotor_POLOZ:= TRUE;
				OdklonGriprov_ZAHODENIE:= TRUE;
				SC_Strihanie.ResetStep:= TRUE;
				SC_Strihanie.Step:= 104;
			END_IF
		
		104:
			SC_Strihanie.StepName:='104 - Automaticky rezim - vystavenie signalu ukoncenie cyklu, otvorenie griprov a zatvorenie griprov';
			SC_Strihanie.IdleTime.PT:= T#700ms;
			SC_Strihanie.AlarmTime.PT:= T#5s;
		
			IF EDGEPOS(Vyrazanie.IN.UchytenieKolikaOtvorene = TRUE AND Vyrazanie.IN.UchytenieNaliatkuOtvorene = TRUE) THEN
				PocetOtvoreniGriprov:= PocetOtvoreniGriprov + 1;
			END_IF	
			
			IF EDGEPOS(Vyrazanie.IN.VyrazanieJeDole = TRUE) THEN				
				IF Vyrazanie.IN.KusPritomny THEN
					Strihanie_UkoncilCyklus:= TRUE;
				ELSE
					Alarmy[48]:= TRUE;
					PoruchaStanicaStrihania:= TRUE;
				END_IF
			END_IF	
			
			
			IF PocetOtvoreniGriprov <2 AND Vyrazanie.IN.OdhadzovanieJeVzadu AND Vyrazanie.IN.UchytenieKolikaZatvorene  AND SC_OvlGripraNaliatku.Step = 1 AND SC_OvlGripraStriznika.Step = 1 THEN
				GriperNaliatku_OTVOR:= TRUE;
				GriperStriznika_OTVOR:= TRUE;
				SC_Strihanie.IdleTime.IN:= TRUE;
			ELSIF PocetOtvoreniGriprov <2 AND Vyrazanie.IN.UchytenieKolikaOtvorene AND Vyrazanie.IN.UchytenieNaliatkuOtvorene AND SC_Strihanie.IdleTime.Q AND SC_OvlGripraNaliatku.Step = 1 AND SC_OvlGripraStriznika.Step = 1 THEN
				GriperNaliatku_ZATVOR:= TRUE;
				GriperStriznika_ZATVOR:= TRUE;
			ELSIF PocetOtvoreniGriprov >=2 AND Vyrazanie.IN.UchytenieKolikaOtvorene AND Vyrazanie.IN.UchytenieNaliatkuOtvorene AND Vyrazanie.IN.VyrazanieJeDole THEN
				PocetOtvoreniGriprov:= 0;
				SC_Strihanie.ResetStep:= TRUE;
				Vyrazanie.OUT.CentrovanieOtvorit:=1;
				Vyrazanie.OUT.CentrovanieZatvorit:=0;
				SC_Strihanie.Step:= 110;	
			END_IF
								
			
		
					
		
		
		110:
			SC_Strihanie.StepName:='110 - Automaticky rezim - otocenie griprov do pozicie odoberania';
			SC_Strihanie.IdleTime.PT:= T#500ms;
			SC_Strihanie.AlarmTime.PT:= T#5s;
			SC_Strihanie.IdleTime.IN:= TRUE;
		
			IF NOT SC_Strihanie.Switch1 THEN
				OdklonGriprov_ODOBERANIE:= TRUE;
				SC_Strihanie.Switch1:= TRUE;
			END_IF
		
			IF Vyrazanie.IN.OdhadzovanieJeVpredu AND Vyrazanie.IN.CentrovanieOtvorene=1 AND Vyrazanie.IN.VyrazanieJeDole THEN
				SC_Strihanie.ResetStep:= TRUE;
				SC_Strihanie.Step:= 120;
			END_IF
		

		
					
        120:
            SC_Strihanie.StepName:='120 - Automaticky rezim - cakanie na otocenie stola';
            SC_Strihanie.IdleTime.PT:= T#500ms;
            SC_Strihanie.AlarmTime.PT:= T#5s;
		
            IF NOT Strihanie_UkoncilCyklus AND SC_OvlZdvihu.Step = 1  THEN
				SC_Strihanie.ResetStep:= TRUE;
				SC_Strihanie.Step:= 100;
			ELSIF Strihanie_KoniecVyroby AND NOT Stol_Automat THEN
				SC_Strihanie.ResetStep:= TRUE;
				SC_Strihanie.Step:= 0;
			ELSIF Strihanie_KoniecCyklu THEN
				SC_Strihanie.ResetStep:= TRUE;
				SC_Strihanie.Step:= 0;	
			END_IF	
			
			
		
			//********************************************************Ruèný režim***********************************************************************************//
		700:
			SC_Strihanie.StepName:='700 - Rucny rezim';
		
		
        //Ovládanie otvárania centrovania rotora//
            IF Strihanie_RR_Centrovanie_OTVOR THEN
                Vyrazanie.OUT.CentrovanieZatvorit:= FALSE;
                Vyrazanie.OUT.CentrovanieOtvorit:= TRUE;
                Strihanie_RR_Centrovanie_OTVOR:= FALSE;
            ELSIF Strihanie_RR_Centrovanie_ZATVOR THEN
                Vyrazanie.OUT.CentrovanieZatvorit:= TRUE;
                Vyrazanie.OUT.CentrovanieOtvorit:= FALSE;
                Strihanie_RR_Centrovanie_ZATVOR:= FALSE;
            END_IF    
        
            
		
		
		
	END_CASE
	
	
	
	
	
	 
				END_PROGRAM

PROGRAM _EXIT
				(* Insert code here *)
	 
				END_PROGRAM

