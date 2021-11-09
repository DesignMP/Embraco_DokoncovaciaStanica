
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	
	//Volanie podprogramov//
	OvladanieGripra;
	OvladanieOtacaniaRotora;
	OvladanieZdvihuRotora;
	OvladanieZdvihuServa;
	
	
	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_Valcovanie);
	
	//Prepoèet èasu streku oleja//
	CasStrekuOleja:= REAL_TO_TIME(TP_Valcovanie_CasStrekuOleja * 1000);
	
	//Prepoèet èasu valcovania//
	CasValcovania_ms:= REAL_TO_TIME(TP_CasValcovania_s * 1000);
	
	
	//Striekanie oleja//
	IF doValcovanie_DavkaOleja THEN
		CasStrikaniaOleja.IN:= TRUE;
	END_IF
	
	IF CasStrikaniaOleja.Q THEN
		CasStrikaniaOleja.IN:= FALSE;
		doValcovanie_DavkaOleja:= FALSE;
	END_IF	
	
	CasStrikaniaOleja.PT:= CasStrekuOleja;
	CasStrikaniaOleja();
	
	
	
	
	//Reset sekcie //
	IF Valcovanie_Reset OR NOT BezpOkruhOplotenia_Aktivovany OR PoruchaStanicaValcovania THEN
		SC_Valcovanie.Step:= 0;
	END_IF
	
	
	
	CASE SC_Valcovanie.Step OF 
	
	
		0:
			SC_Valcovanie.StepName:='0 - Nulovanie';
			SC_OvlGripra.Step:= 0;
			SC_OvlOtacania.Step:= 0;
			SC_OvlServoZdvihu.Step:= 0;
			SC_OvlZdvihu.Step:= 0;
			Valcovanie_Automat:= FALSE;
			Valcovanie_KoniecVyroby:= FALSE;
			Valcovanie_KoniecCyklu:= FALSE;
			Valcovanie_Manual:= FALSE;
			Valcovanie_PoINIT:= FALSE;
			Valcovanie_Reset:= FALSE;
			Valcovanie_ZdvihVPOZICI:= FALSE;
			Valcovanie_UkoncilCyklus:= FALSE;
			doValcovanie_DavkaOleja:= FALSE;
			PocetCyklovValcovania:= 0;
			RR_StartOlejovania:= FALSE;
			RR_PoziciaValcovania:= FALSE;
			RR_PoziciaVychodzia:= FALSE;
			Priznak_ValcovanieNG:= FALSE;
			Priznak_ValcovanieOK:= FALSE;
			IF BezpOkruhOplotenia_Aktivovany AND NOT PoruchaStanicaValcovania THEN
				SC_Valcovanie.ResetStep:= TRUE;
				SC_Valcovanie.Step:= 1;
			END_IF
	
		1:
			SC_Valcovanie.StepName:='1 - Rozhodnutie o cinnosti';
			IF Valcovanie_Automat THEN
				SC_Valcovanie.Step:= 2;
			ELSIF Valcovanie_Manual THEN
				SC_Valcovanie.Step:= 700;
			END_IF
		
		
			//********************************************************Inicializácia****************************************************************************//
		
		2:
			SC_Valcovanie.StepName:='2 - Inicializacia - cakanie na spustenie';
			SC_Valcovanie.IdleTime.PT:= T#500ms;
			SC_Valcovanie.AlarmTime.PT:= T#5s;
			SC_Valcovanie.IdleTime.IN:= TRUE;
				
			
			IF SC_Valcovanie.IdleTime.Q THEN
				SC_Valcovanie.ResetStep:= TRUE;
				SC_Valcovanie.Step:= 3;
			END_IF
	
		3:
			SC_Valcovanie.StepName:='3 - Inicializacia - kontrola home serva zdvihu';
			SC_Valcovanie.IdleTime.PT:= T#500ms;
			SC_Valcovanie.AlarmTime.PT:= T#5s;
		
			IF Motion[3].status.DriveStatus.HomingOk THEN
				SC_Valcovanie.ResetStep:= TRUE;
				SC_Valcovanie.Step:= 5;
			ELSE
				SC_Valcovanie.ResetStep:= TRUE;
				SC_Valcovanie.Step:= 4;
			END_IF
		
		4:
			SC_Valcovanie.StepName:='4 - Inicializacia - homing serva zdvihu';
			SC_Valcovanie.IdleTime.PT:= T#500ms;
			SC_Valcovanie.AlarmTime.PT:= T#5s;
			
			
			IF NOT SC_Valcovanie.Switch1 THEN
				Valcovanie_ZdvihHOME:= TRUE;
				SC_Valcovanie.Switch1:= TRUE;
			END_IF
			
			IF Motion[3].status.DriveStatus.HomingOk THEN
				SC_Valcovanie.IdleTime.IN:= TRUE;
			END_IF	
			
			IF Motion[3].status.DriveStatus.HomingOk AND SC_Valcovanie.IdleTime.Q AND Motion[3].state.StandStill THEN
				SC_Valcovanie.ResetStep:= TRUE;
				SC_Valcovanie.Step:= 5;
			END_IF
		
		
		5:
			SC_Valcovanie.StepName:='5 - Inicializacia - otvorenie gripra';
			SC_Valcovanie.IdleTime.PT:= T#500ms;
			SC_Valcovanie.AlarmTime.PT:= T#5s;
		
			IF NOT SC_Valcovanie.Switch1 THEN
				Otvor_Griper:= TRUE;
				SC_Valcovanie.Switch1:= TRUE;
			END_IF
		
			IF diValcovanie_GriperOtvoreny THEN
				SC_Valcovanie.ResetStep:= TRUE;
				SC_Valcovanie.Step:= 6;
			END_IF
		
		6:
			SC_Valcovanie.StepName:='6 - Inicializacia - zdvih motora do vychodiskovej pozicie, zasunutie zdvihu rotora';
			SC_Valcovanie.IdleTime.PT:= T#500ms;
			SC_Valcovanie.AlarmTime.PT:= T#5s;	
		
			Valcovanie_ZadanaPozMM:= 15;
		
			IF NOT SC_Valcovanie.Switch1 THEN
				ServoZdvih_Polohuj:= TRUE;
				Rotor_POLOZ:= TRUE;
				SC_Valcovanie.Switch1:= TRUE;
			END_IF
		
			IF diValcovanie_ZdvihSpodnaPoloha AND Valcovanie_ZdvihVPOZICI THEN
				Valcovanie_ZdvihVPOZICI:= FALSE;
				Valcovanie_PoINIT:= TRUE;
				SC_Valcovanie.ResetStep:= TRUE;
				SC_Valcovanie.Step:= 100;
			END_IF
		
			
		
			//********************************************************Automatický režim****************************************************************************//
		100:
			SC_Valcovanie.StepName:='100 - Automaticky rezim - cakanie na start cyklu';
			SC_Valcovanie.IdleTime.PT:= T#500ms;
			SC_Valcovanie.AlarmTime.PT:= T#5s;	
			Priznak_ValcovanieOK:= FALSE;
			
            SC_Valcovanie.IdleTime.IN:= NOT diValcovanie_PritomnostRotora;
            
			IF Valcovanie_KoniecCyklu THEN
				SC_Valcovanie.ResetStep:= TRUE;
				SC_Valcovanie.Step:= 0;
			ELSIF NOT VnutorneValcovanie_AKTIVNE THEN
				SC_Valcovanie.ResetStep:= TRUE;
				SC_Valcovanie.Step:= 120;
			ELSIF Stol_PoINIT AND NOT Valcovanie_UkoncilCyklus AND diValcovanie_PritomnostRotora AND diStol_SnimacPolohyStola THEN
				SC_Valcovanie.ResetStep:= TRUE;
				SC_Valcovanie.Step:= 101;
			ELSIF Stol_PoINIT AND NOT Valcovanie_UkoncilCyklus AND NOT diValcovanie_PritomnostRotora AND SC_Valcovanie.IdleTime.Q THEN
				SC_Valcovanie.ResetStep:= TRUE;
				SC_Valcovanie.Step:= 120;
			ELSIF Valcovanie_KoniecVyroby AND NOT Stol_Automat THEN
				SC_Valcovanie.ResetStep:= TRUE;
				SC_Valcovanie.Step:= 0;
			END_IF	
		
		101:
			SC_Valcovanie.StepName:='101 - Automaticky rezim - zdvih rotora';
			SC_Valcovanie.IdleTime.PT:= T#500ms;
			SC_Valcovanie.AlarmTime.PT:= T#5s;	
		
			IF NOT SC_Valcovanie.Switch1 THEN
				Rotor_ZDVIHNI:= TRUE;
				PocetCyklovValcovania:= PocetCyklovValcovania + 1;
				SC_Valcovanie.Switch1:= TRUE;
			END_IF
		
			IF diValcovanie_ZdvihHornaPoloha THEN
				SC_Valcovanie.ResetStep:= TRUE;
				SC_Valcovanie.Step:= 102;
			END_IF
		
		102:
			SC_Valcovanie.StepName:='102 - Automaticky rezim - zatvorenie gripra';
			SC_Valcovanie.IdleTime.PT:= T#500ms;
			SC_Valcovanie.AlarmTime.PT:= T#5s;	
		
			IF NOT SC_Valcovanie.Switch1 THEN
				Zatvor_Griper:= TRUE;
				SC_Valcovanie.Switch1:= TRUE;
			END_IF
		
			IF diValcovanie_GriperZatvoreny THEN
				SC_Valcovanie.ResetStep:= TRUE;
				SC_Valcovanie.Step:= 103;
			END_IF
		
		103:
			SC_Valcovanie.StepName:='103 - Automaticky rezim - spustenie otacania nastroja, zostup do pozicie zaciatku valcovania, streknutie oleja';
			SC_Valcovanie.IdleTime.PT:= CasValcovania_ms;
			SC_Valcovanie.AlarmTime.PT:= T#5s;	
			
			SC_Valcovanie.IdleTime.IN:= Valcovanie_ZdvihVPOZICI;
			Valcovanie_ZadanaPozMM:= TP_Valcovanie_PoziciaVnorenia; //50
		
			
			IF NOT SC_Valcovanie.Switch1 AND NOT diValcovanie_PritomnostNastroja AND SC_OvlServoZdvihu.Step = 1 THEN
				RotorOtacaj_VPRED:= TRUE;
				ServoZdvih_Polohuj:= TRUE;
				SC_Valcovanie.Switch1:= TRUE;
			END_IF
		
			IF PocetCyklovValcovania >= TP_Valcovanie_PocetCyklPredStrek THEN
				IF EDGEPOS (Valcovanie_AktualPozMM >= (TP_Valcovanie_PoziciaVnorenia - 50)) THEN
					doValcovanie_DavkaOleja:= TRUE;
					PocetCyklovValcovania:= 0;
				END_IF
			END_IF	
			
			
			
			IF Valcovanie_ZdvihVPOZICI AND SC_Valcovanie.IdleTime.Q THEN
				Valcovanie_ZdvihVPOZICI:= FALSE;
				SC_Valcovanie.ResetStep:= TRUE;
				SC_Valcovanie.Step:= 107;
			END_IF
		
		107:
			SC_Valcovanie.StepName:='107 - Automaticky rezim - zdvih valcovacieho nastroja, otvorenie gripra, zasunutie zdvihu';
			SC_Valcovanie.IdleTime.PT:= T#500ms;
			SC_Valcovanie.AlarmTime.PT:= T#5s;	
			SC_Valcovanie.IdleTime.IN:= TRUE;
		
			Valcovanie_ZadanaPozMM:= 15;
			
			
			
			IF NOT SC_Valcovanie.Switch1 AND SC_OvlServoZdvihu.Step = 1 THEN
				ServoZdvih_Polohuj:= TRUE;
				SC_Valcovanie.Switch1:= TRUE;
			END_IF
		
			IF EDGEPOS(Valcovanie_AktualPozMM < 60) THEN
				Otvor_Griper:= TRUE;
			END_IF	
			
			IF EDGENEG(diValcovanie_GriperZatvoreny = TRUE) THEN
				Rotor_POLOZ:= TRUE;
			END_IF	
				
				
				
			IF Valcovanie_ZdvihVPOZICI AND diValcovanie_GriperOtvoreny AND diValcovanie_ZdvihSpodnaPoloha THEN
				Valcovanie_ZdvihVPOZICI:= FALSE;
				SC_Valcovanie.ResetStep:= TRUE;
				SC_Valcovanie.Step:= 120;
			END_IF
			
		
	
		
		120:
			SC_Valcovanie.StepName:='120 - Automaticky rezim - vystavenie signalu ukoncenie pracovneho cyklu';
			SC_Valcovanie.IdleTime.PT:= T#500ms;
			SC_Valcovanie.AlarmTime.PT:= T#5s;
		
			IF Priznak_ValcovanieNG THEN
				Alarmy[77]:= TRUE;
				PoruchaStanicaValcovania:= TRUE;
			ELSE 
				Valcovanie_UkoncilCyklus:= TRUE;
				SC_Valcovanie.ResetStep:= TRUE;
				SC_Valcovanie.Step:= 121;
			END_IF
			
		
		121:
			SC_Valcovanie.StepName:='121 - Automaticky rezim - cakanie na otocenie stola';
			SC_Valcovanie.IdleTime.PT:= T#500ms;
			SC_Valcovanie.AlarmTime.PT:= T#5s;
		
				
			IF diValcovanie_PritomnostNastroja THEN
				Alarmy[68]:= TRUE;
				PoruchaStanicaValcovania:= TRUE;
			END_IF
		
			IF NOT Valcovanie_UkoncilCyklus THEN
				SC_Valcovanie.ResetStep:= TRUE;
				SC_Valcovanie.Step:= 100;
			ELSIF Valcovanie_KoniecVyroby AND NOT Stol_Automat THEN
				SC_Valcovanie.ResetStep:= TRUE;
				SC_Valcovanie.Step:= 0;	
			ELSIF Valcovanie_KoniecCyklu THEN
				SC_Valcovanie.ResetStep:= TRUE;
				SC_Valcovanie.Step:= 0;	
			END_IF
		
		
		
			//********************************************************Ruèný režim***********************************************************************************//
		700:
			SC_Valcovanie.StepName:='700 - Rucny rezim';
					
		
			//Ovládanie odstreku oleja//
			IF RR_StartOlejovania THEN
				doValcovanie_DavkaOleja:= TRUE;
				RR_StartOlejovania:= FALSE;
			END_IF	
				
			//Polohovanie zdvihu valcovania//
			IF RR_PoziciaVychodzia AND SC_OvlServoZdvihu.Step = 1 THEN
				Valcovanie_Rychlost_MM_s:= TP_Valcovanie_RychlostZdvihu;
				Valcovanie_ZadanaPozMM:= 10;
				ServoZdvih_Polohuj:= TRUE;
			ELSIF RR_PoziciaValcovania AND SC_OvlServoZdvihu.Step = 1 THEN	
				Valcovanie_Rychlost_MM_s:= TP_Valcovanie_RychlostZdvihu;
				Valcovanie_ZadanaPozMM:= TP_Valcovanie_PoziciaVnorenia;
				ServoZdvih_Polohuj:= TRUE;
			END_IF	
		
		
		
	END_CASE
	
	
	
	

	
	
	 
				END_PROGRAM

PROGRAM _EXIT
				(* Insert code here *)
	 
				END_PROGRAM

