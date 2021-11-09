
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC

	//Volanie podprogramov//
    OvladanieOtacania;
	
    //Volanie funkcie SequenceControl//
    SequenceControl(SC:= SC_Stol);
	
    //Blokovanie otáèania stola//
    IF diMeranie_ZdvihSpodnaPoloha AND
        diRazenie_ZdvihSpodnaPoloha AND
        Vyrazanie.IN.VyrazanieJeDole AND
        diValcovanie_ZdvihSpodnaPoloha AND
        (diVstupManipul_ZasunutyHore OR VstupManipulator_AktualPozMM > 15) AND
        (diVystupManipul_ZasunutyHore OR VystupManipulator_AktualPozMM > 15) AND
        NOT diValcovanie_PritomnostNastroja AND
        diValc2_ZdvihRotoraZasunuty AND
        Vyrazanie.IN.CentrovanieOtvorene THEN
        Stol_BlokovanieOtacania:= FALSE;
    ELSE	
        Stol_BlokovanieOtacania:= TRUE;
    END_IF	
	
    		
    //Reset sekcie //
    IF Stol_Reset OR NOT BezpOkruhOplotenia_Aktivovany OR PoruchaOtocnyStol THEN
        SC_Stol.Step:= 0;
    END_IF
	
	
	
    CASE SC_Stol.Step OF 
	
	
        0:
            SC_Stol.StepName:='0 - Nulovanie';
            SC_OvlStola.Step:= 0;
            Stol_Automat:= FALSE;
            Stol_KoniecVyroby:= FALSE;
            Stol_KoniecCyklu:= FALSE;
            Stol_Manual:= FALSE;
            Stol_PoINIT:= FALSE;
            Stol_Reset:= FALSE;
            Stol_PrebehloOtocenie:= FALSE;
            Stol_CakaNaVstupnyManipulator:= FALSE;
            Stol_CakaNaStrihanie:= FALSE;
            Stol_CakaNaRazenie:= FALSE;
            Stol_CakaNaValcovanie:= FALSE;
            Stol_CakaNaMeranie:= FALSE;
            Stol_CakaNaVystupnyManipulator:= FALSE;
            //			Stol_Pozicia_1:= 0;
            //			Stol_Pozicia_2:= 0;
            //			Stol_Pozicia_3:= 0;
            PocetOtoceniStola:= 0;
            Stol_StavPrazdnyStol:= FALSE;
            CasTaktTime2.IN:= FALSE;
            CasTaktTime1.IN:= FALSE;
            TP_Stol_Centrovanie_VYSUN:= FALSE;
            TP_Stol_Centrovanie_ZASUN:= FALSE;
            IF BezpOkruhOplotenia_Aktivovany AND NOT PoruchaOtocnyStol THEN
                SC_Stol.ResetStep:= TRUE;
                SC_Stol.Step:= 1;
            END_IF
	
        1:
            SC_Stol.StepName:='1 - Rozhodnutie o cinnosti';
            IF Stol_Automat THEN
                CisloChyby:= 0;
                SC_Stol.Step:= 2;
            ELSIF Stol_Manual THEN
                SC_Stol.Step:= 700;
            END_IF
		
		
            //********************************************************Inicializácia****************************************************************************//
	
        2:
            SC_Stol.StepName:='2 - Inicializacia - cakanie na spustenie';
            SC_Stol.IdleTime.PT:= T#500ms;
            SC_Stol.AlarmTime.PT:= T#5s;
            SC_Stol.IdleTime.IN:= TRUE;
				
			
            IF SC_Stol.IdleTime.Q THEN
                SC_Stol.ResetStep:= TRUE;
                SC_Stol.Step:= 3;
            END_IF
	
        3:
            SC_Stol.StepName:='2 - Inicializacia - rozhodnutie o otoceni stola';
            SC_Stol.IdleTime.PT:= T#500ms;
            SC_Stol.AlarmTime.PT:= T#5s;
		
            IF diStol_SnimacPolohyStola THEN
                Stol.OUT.CentrovanieVysunut:=1;
                Stol.OUT.CentrovanieZasunut:=0;
                Stol_PoINIT:= TRUE;
                SC_Stol.ResetStep:= TRUE;
                IF Stol.IN.CentrovanieVysunute=1 THEN
                    SC_Stol.Step:= 100;
                END_IF
            ELSE
                SC_Stol.ResetStep:= TRUE;
                SC_Stol.Step:= 4;
            END_IF
		
        4:
            SC_Stol.StepName:='4 - Inicializacia - otocenie stola vpred';
            SC_Stol.IdleTime.PT:= T#500ms;
            SC_Stol.AlarmTime.PT:= T#5s;
				
            IF NOT SC_Stol.Switch1 AND NOT Stol_BlokovanieOtacania THEN
                Otacaj_VPRED:= TRUE;
                SC_Stol.Switch1:= TRUE;
            END_IF
		
            IF diStol_SnimacPolohyStola AND Stol_PrebehloOtocenie THEN
                Stol_PrebehloOtocenie:= FALSE;
                Stol_PoINIT:= TRUE;
                SC_Stol.ResetStep:= TRUE;
                SC_Stol.Step:= 100;
            END_IF	
		
		
		
		
		
            //********************************************************Automatický režim****************************************************************************//
        100:
            SC_Stol.StepName:='100 - Automaticky rezim - cakanie na ukoncenie cyklov jednotlivych pracovisk';
            SC_Stol.IdleTime.PT:= T#500ms;
            SC_Stol.AlarmTime.PT:= T#5s;
		
					
            IF VstupManipulator_UkoncilCyklus AND Strihanie_UkoncilCyklus AND Razenie_UkoncilCyklus AND Valcovanie_UkoncilCyklus AND Valcovanie2_UkoncilCyklus AND Meranie_UkoncilCyklus AND VystupManipulator_UkoncilCyklus AND NOT Stol_NG_KusNaStole THEN
                IF NOT CasTaktTime1.IN AND NOT CasTaktTime2.IN THEN 
                    CasTaktTime1.IN:= TRUE;
                ELSIF CasTaktTime1.IN AND NOT CasTaktTime2.IN THEN 
                    Zariadenie_TaktTime:= TIME_TO_REAL(CasTaktTime1.ET);
                    TP_Zariadenie_TaktTime:= (Zariadenie_TaktTime / 1000);
                    CasTaktTime2.IN:= TRUE;
                    CasTaktTime1.IN:= FALSE;
                ELSIF NOT CasTaktTime1.IN AND CasTaktTime2.IN THEN 	
                    Zariadenie_TaktTime:= TIME_TO_REAL(CasTaktTime2.ET);
                    TP_Zariadenie_TaktTime:= (Zariadenie_TaktTime / 1000);
                    CasTaktTime1.IN:= TRUE;
                    CasTaktTime2.IN:= FALSE;
                END_IF	
                SC_Stol.ResetStep:= TRUE;
                SC_Stol.Step:= 101;
            ELSIF VstupManipulator_UkoncilCyklus AND Strihanie_UkoncilCyklus AND Razenie_UkoncilCyklus AND Valcovanie_UkoncilCyklus AND Valcovanie2_UkoncilCyklus AND Meranie_UkoncilCyklus AND VystupManipulator_UkoncilCyklus AND Stol_NG_KusNaStole THEN	
                Stol_NG_KusNaStole:= FALSE;
                SC_Stol.ResetStep:= TRUE;
                SC_Stol.Step:= 105;
            ELSIF Stol_KoniecCyklu AND NOT VstupManipulator_Automat AND NOT Strihanie_Automat AND NOT Razenie_Automat AND NOT Valcovanie_Automat AND NOT Valcovanie2_Automat AND NOT Meranie_Automat AND NOT VystupManipulator_Automat THEN
                SC_Stol.ResetStep:= TRUE;
                SC_Stol.Step:= 0;
            END_IF
		
			
		
        101:
            SC_Stol.StepName:='101 - Automaticky rezim - otocenie stola vpred,prepisanie bufferov ';
            SC_Stol.IdleTime.PT:= T#500ms;
            SC_Stol.AlarmTime.PT:= T#5s;	
		
            IF NOT SC_Stol.Switch2 THEN
                IF NOT diStol_PritomnostRotoraVstup AND NOT diStol_PritomnostRotoraVystup AND 	NOT Vyrazanie.IN.KusPritomny AND NOT diRazenie_PritomnostRotora AND NOT diValcovanie_PritomnostRotora AND NOT diValc2_PritomnostRotora AND NOT diMeranie_PritomnostRotora THEN
                    PocetOtoceniStola:= PocetOtoceniStola + 1;
                ELSE
                    PocetOtoceniStola:= 0;
                END_IF	
                IF PocetOtoceniStola > 3 THEN
                    Stol_StavPrazdnyStol:= TRUE;
                ELSE	
                    Stol_StavPrazdnyStol:= FALSE;
                END_IF	
                SC_Stol.Switch2:= TRUE;
            END_IF		
			
			
            IF NOT SC_Stol.Switch1 AND NOT Stol_BlokovanieOtacania AND diStol_NaliatokOdstrihnuty THEN
                Otacaj_VPRED:= TRUE;
                SC_Stol.Switch1:= TRUE;
            END_IF
			
            IF NOT diStol_NaliatokOdstrihnuty THEN
                SC_Stol.AlarmTime.IN:= TRUE;
            ELSIF Stol_BlokovanieOtacania THEN
                SC_Stol.AlarmTime.IN:= TRUE;
            ELSE
                SC_Stol.AlarmTime.IN:= FALSE;
            END_IF    
            
            
            IF SC_Stol.AlarmTime.Q THEN
                IF NOT diStol_NaliatokOdstrihnuty THEN
                    Alarmy[34]:= TRUE;
                END_IF
                IF Stol_BlokovanieOtacania THEN
                    IF NOT diMeranie_ZdvihSpodnaPoloha THEN
                        CisloChyby:= 1;
                    ELSIF NOT diRazenie_ZdvihSpodnaPoloha THEN
                        CisloChyby:= 2;
                    ELSIF NOT Vyrazanie.IN.VyrazanieJeDole THEN
                        CisloChyby:= 3;
                    ELSIF NOT diValcovanie_ZdvihSpodnaPoloha THEN
                        CisloChyby:= 4;
                    ELSIF diValcovanie_PritomnostNastroja THEN
                        CisloChyby:= 5;
                    ELSIF NOT Vyrazanie.IN.CentrovanieOtvorene THEN
                        CisloChyby:= 6;
                    ELSIF (NOT diVstupManipul_ZasunutyHore AND VstupManipulator_AktualPozMM < 15) THEN
                        CisloChyby:= 7;
                    ELSIF (NOT diVystupManipul_ZasunutyHore AND VystupManipulator_AktualPozMM < 15) THEN
                        CisloChyby:= 8;
                    END_IF    
                    Alarmy[33]:= TRUE;
                END_IF    
                PoruchaOtocnyStol:= TRUE;
            END_IF    
           
        
            
            
		
            IF diStol_SnimacPolohyStola AND Stol_PrebehloOtocenie THEN
                Stol_PrebehloOtocenie:= FALSE;
                Stol_Pozicia_3:= Stol_Pozicia_2;
                Stol_Pozicia_2:= Stol_Pozicia_1;
                Stol_Pozicia_1:= 0;
                SC_Stol.ResetStep:= TRUE;
                SC_Stol.Step:= 102;
            END_IF	
			
				
		
        102:
            SC_Stol.StepName:='102 - Automaticky rezim - kontrola vyprazdnenia stola';
            SC_Stol.IdleTime.PT:= T#500ms;
            SC_Stol.AlarmTime.PT:= T#5s;
			
            IF NOT Stol_StavPrazdnyStol THEN			
                Stol_PrebehloOtocenie:= FALSE;
                VstupManipulator_UkoncilCyklus:= FALSE;
                Strihanie_UkoncilCyklus:= FALSE;
                Razenie_UkoncilCyklus:= FALSE;
                Valcovanie_UkoncilCyklus:= FALSE;
                Valcovanie2_UkoncilCyklus:= FALSE;
                Meranie_UkoncilCyklus:= FALSE;
                VystupManipulator_UkoncilCyklus:= FALSE;
                SC_Stol.ResetStep:= TRUE;
                SC_Stol.Step:= 100;
            ELSIF NOT Stol_KoniecVyroby AND Stol_StavPrazdnyStol AND diVstupDopr_PritomnostRotora THEN
                Stol_PrebehloOtocenie:= FALSE;
                VstupManipulator_UkoncilCyklus:= FALSE;
                Strihanie_UkoncilCyklus:= FALSE;
                Razenie_UkoncilCyklus:= FALSE;
                Valcovanie_UkoncilCyklus:= FALSE;
                Valcovanie2_UkoncilCyklus:= FALSE;
                Meranie_UkoncilCyklus:= FALSE;
                VystupManipulator_UkoncilCyklus:= FALSE;
                SC_Stol.ResetStep:= TRUE;
                SC_Stol.Step:= 100;
            ELSIF Stol_KoniecVyroby AND NOT Stol_StavPrazdnyStol THEN
                Stol_PrebehloOtocenie:= FALSE;
                VstupManipulator_UkoncilCyklus:= FALSE;
                Strihanie_UkoncilCyklus:= FALSE;
                Razenie_UkoncilCyklus:= FALSE;
                Valcovanie_UkoncilCyklus:= FALSE;
                Valcovanie2_UkoncilCyklus:= FALSE;
                Meranie_UkoncilCyklus:= FALSE;
                VystupManipulator_UkoncilCyklus:= FALSE;
                SC_Stol.ResetStep:= TRUE;
                SC_Stol.Step:= 100;
            ELSIF Stol_KoniecVyroby AND Stol_StavPrazdnyStol THEN
                SC_Stol.ResetStep:= TRUE;
                SC_Stol.Step:= 0;
            ELSIF Stol_KoniecCyklu AND Stol_StavPrazdnyStol THEN
                SC_Stol.ResetStep:= TRUE;
                SC_Stol.Step:= 0; 	
            END_IF	
				
			
					
					
            //Vyhodenie NG kusu//
			
        105:
            SC_Stol.StepName:='105 - Automaticky rezim - otocenie stola vzad';
            SC_Stol.IdleTime.PT:= T#500ms;
            SC_Stol.AlarmTime.PT:= T#5s;	
		
            IF NOT SC_Stol.Switch1 AND NOT Stol_BlokovanieOtacania THEN
                Otacaj_VZAD:= TRUE;
                SC_Stol.Switch1:= TRUE;
            END_IF
		
            IF diStol_SnimacPolohyStola AND Stol_PrebehloOtocenie THEN
                VystupManipulator_OdoberNGKus:= TRUE;
                Stol_PrebehloOtocenie:= FALSE;
                SC_Stol.ResetStep:= TRUE;
                SC_Stol.Step:= 106;
            END_IF	
		
        106:
            SC_Stol.StepName:='106 - Automaticky rezim - odobratie NG kusu';
            SC_Stol.IdleTime.PT:= T#500ms;
            SC_Stol.AlarmTime.PT:= T#5s;
			
            VystupManipulator_UkoncilCyklus:= FALSE;
            SC_Stol.ResetStep:= TRUE;
            SC_Stol.Step:= 107;
		
				
        107:
            SC_Stol.StepName:='107 - Automaticky rezim - ukoncenie odobratie NG kusu';
            SC_Stol.IdleTime.PT:= T#500ms;
            SC_Stol.AlarmTime.PT:= T#5s;
		
            IF VystupManipulator_UkoncilCyklus AND NOT diStol_PritomnostRotoraVystup THEN
                SC_Stol.ResetStep:= TRUE;
                SC_Stol.Step:= 108;
            END_IF	
		
		
		
        108:
            SC_Stol.StepName:='108 - Automaticky rezim - otocenie stola vpred';
            SC_Stol.IdleTime.PT:= T#500ms;
            SC_Stol.AlarmTime.PT:= T#5s;	
		
            IF NOT SC_Stol.Switch1 AND NOT Stol_BlokovanieOtacania AND diStol_NaliatokOdstrihnuty THEN
                Otacaj_VPRED:= TRUE;
                SC_Stol.Switch1:= TRUE;
            END_IF
		
            IF diStol_SnimacPolohyStola AND Stol_PrebehloOtocenie THEN
                Stol_PrebehloOtocenie:= FALSE;
                SC_Stol.ResetStep:= TRUE;
                SC_Stol.Step:= 109;
            END_IF	
            
            IF NOT diStol_NaliatokOdstrihnuty THEN
                SC_Stol.AlarmTime.IN:= TRUE;
            ELSIF Stol_BlokovanieOtacania THEN
                SC_Stol.AlarmTime.IN:= TRUE;
            ELSE
                SC_Stol.AlarmTime.IN:= FALSE;
            END_IF    
            
            
            IF SC_Stol.AlarmTime.Q THEN
                IF NOT diStol_NaliatokOdstrihnuty THEN
                    Alarmy[34]:= TRUE;
                END_IF
                IF Stol_BlokovanieOtacania THEN
                    IF NOT diMeranie_ZdvihSpodnaPoloha THEN
                        CisloChyby:= 1;
                    ELSIF NOT diRazenie_ZdvihSpodnaPoloha THEN
                        CisloChyby:= 2;
                    ELSIF NOT Vyrazanie.IN.VyrazanieJeDole THEN
                        CisloChyby:= 3;
                    ELSIF NOT diValcovanie_ZdvihSpodnaPoloha THEN
                        CisloChyby:= 4;
                    ELSIF diValcovanie_PritomnostNastroja THEN
                        CisloChyby:= 5;
                    ELSIF NOT Vyrazanie.IN.CentrovanieOtvorene THEN
                        CisloChyby:= 6;
                    ELSIF (NOT diVstupManipul_ZasunutyHore AND VstupManipulator_AktualPozMM < 15) THEN
                        CisloChyby:= 7;
                    ELSIF (NOT diVystupManipul_ZasunutyHore AND VystupManipulator_AktualPozMM < 15) THEN
                        CisloChyby:= 8;
                    END_IF  
                    Alarmy[33]:= TRUE;
                END_IF    
                PoruchaOtocnyStol:= TRUE;
            END_IF    
           
            
            
            
        109:
            SC_Stol.StepName:='109 - Automaticky rezim - vystavenie signalu pre vstupny manipulator';
            SC_Stol.IdleTime.PT:= T#500ms;
            SC_Stol.AlarmTime.PT:= T#5s;
		
            VstupManipulator_UkoncilCyklus:= FALSE;
            SC_Stol.ResetStep:= TRUE;
            SC_Stol.Step:= 110;
		
        110:
            SC_Stol.StepName:='110 - Automaticky rezim - cakanie na ukoncenie cyklu vstupneho manipulatora';
            SC_Stol.IdleTime.PT:= T#500ms;
            SC_Stol.AlarmTime.PT:= T#5s;
			
            IF VstupManipulator_UkoncilCyklus THEN
                SC_Stol.ResetStep:= TRUE;
                SC_Stol.Step:= 100;
            ELSIF Stol_KoniecCyklu THEN
                SC_Stol.ResetStep:= TRUE;
                SC_Stol.Step:= 0; 	
            END_IF	
		
            //********************************************************Ruèný režim***********************************************************************************//
        700:
            SC_Stol.StepName:='700 - Rucny rezim';
		
            //Ovládanie centrovania rotora na vstupe stola//
            IF TP_Stol_Centrovanie_VYSUN AND diStol_SnimacPolohyStola THEN
                Stol.OUT.CentrovanieVysunut:=1;
                Stol.OUT.CentrovanieZasunut:=0;
                TP_Stol_Centrovanie_VYSUN:= FALSE;
            ELSIF TP_Stol_Centrovanie_ZASUN THEN    
                Stol.OUT.CentrovanieVysunut:=0;
                Stol.OUT.CentrovanieZasunut:=1;
                TP_Stol_Centrovanie_ZASUN:= FALSE;
            END_IF    
            
            //Ovládanie otáèania stola//
            IF Stol_RR_OtacajVPRED THEN
                IF NOT Stol_BlokovanieOtacania THEN
                    Otacaj_VPRED:= TRUE;
                END_IF
                Stol_RR_OtacajVPRED:= FALSE;
            ELSIF Stol_RR_OtacajVZAD THEN
                IF NOT Stol_BlokovanieOtacania THEN
                    Otacaj_VZAD:= TRUE;
                END_IF
                Stol_RR_OtacajVZAD:= FALSE;
            END_IF    
        
        
        
		
		
    END_CASE
	
    CasTaktTime1.PT:= T#10m;
    CasTaktTime1();
    CasTaktTime2.PT:= T#10m;
    CasTaktTime2();
	
	
	
	
					END_PROGRAM

PROGRAM _EXIT
					(* Insert code here *)
	 
					END_PROGRAM

