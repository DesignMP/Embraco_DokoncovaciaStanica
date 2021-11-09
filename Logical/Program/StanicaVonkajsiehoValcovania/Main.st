
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	
	//Volanie podprogramov//
	OvlHornehoPritlaku;
	OvlOtacaniaNastroja;
	OvlZdvihuRotora;
	
	
	
	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_Valcovanie2);
	
	Valcovanie2_CasStrekuOleja_s;
	Valcovanie2_CasValcovania_s;
	
	
	//***************************Dávka oleja**********************************//
	IF Valcovanie2_DavkaOleja THEN
		doValc2_DavkaOleja:= TRUE;
		CasDavkyOleja.IN:= TRUE;
	END_IF
	
	IF CasDavkyOleja.Q THEN
		Valcovanie2_DavkaOleja:= FALSE;
		CasDavkyOleja.IN:= FALSE;
		doValc2_DavkaOleja:= FALSE;
	END_IF	
	
	CasDavkyOleja.PT:= REAL_TO_TIME(Valcovanie2_CasStrekuOleja_s * 1000);
	CasDavkyOleja();
	
	
	
	
	//Reset sekcie //
	IF Valcovanie2_Reset OR NOT BezpOkruhOplotenia_Aktivovany OR PoruchaStanicaValcovania2 THEN
		SC_Valcovanie2.Step:= 0;
	END_IF
	
	
	
	CASE SC_Valcovanie2.Step OF 
	
	
		0:
			SC_Valcovanie2.StepName:='0 - Nulovanie';
			SC_OvlHornehoPritlaku.Step:= 0;
			SC_OvlOtacaniaNastroja.Step:= 0;
			SC_OvlZdvihuRotora.Step:= 0;
			Valcovanie2_Automat:= FALSE;
			Valcovanie2_KoniecVyroby:= FALSE;
			Valcovanie2_KoniecCyklu:= FALSE;
			Valcovanie2_Manual:= FALSE;
			Valcovanie2_PoINIT:= FALSE;
			Valcovanie2_Reset:= FALSE;
			Valcovanie2_ZdvihVPOZICI:= FALSE;
			Valcovanie2_UkoncilCyklus:= FALSE;
			RR_ZdvihRotora_PozValcovania:= FALSE;
			RR_ZdvihRotora_PozVychodzia:= FALSE;
			PocetCyklovValcovania:= 0;
			Priznak_ValcovanieNG:= FALSE;
			Priznak_ValcovanieOK:= FALSE;
			IF BezpOkruhOplotenia_Aktivovany AND NOT PoruchaStanicaValcovania2 THEN
				SC_Valcovanie2.ResetStep:= TRUE;
				SC_Valcovanie2.Step:= 1;
			END_IF
	
		1:
			SC_Valcovanie2.StepName:='1 - Rozhodnutie o cinnosti';
			IF Valcovanie2_Automat THEN
				SC_Valcovanie2.Step:= 2;
			ELSIF Valcovanie2_Manual THEN
				SC_Valcovanie2.Step:= 700;
			END_IF
		
		
			//********************************************************Inicializácia****************************************************************************//
	
		2:
			SC_Valcovanie2.StepName:='2 - Inicializacia - cakanie na spustenie';
			SC_Valcovanie2.IdleTime.PT:= T#500ms;
			SC_Valcovanie2.AlarmTime.PT:= T#5s;
			SC_Valcovanie2.IdleTime.IN:= TRUE;
				
			
			IF SC_Valcovanie2.IdleTime.Q AND diStol_SnimacPolohyStola THEN
				SC_Valcovanie2.ResetStep:= TRUE;
				SC_Valcovanie2.Step:= 4;
			END_IF
	
					
		4:
			SC_Valcovanie2.StepName:='4 - Inicializacia - kontrola home serva zdvihu rotora';
			SC_Valcovanie2.IdleTime.PT:= T#500ms;
			SC_Valcovanie2.AlarmTime.PT:= T#5s;
		
			IF Motion[4].status.DriveStatus.HomingOk THEN
				SC_Valcovanie2.ResetStep:= TRUE;
				SC_Valcovanie2.Step:= 6;
			ELSE
				SC_Valcovanie2.ResetStep:= TRUE;
				SC_Valcovanie2.Step:= 5;
			END_IF
		
		5:
			SC_Valcovanie2.StepName:='5 - Inicializacia - homing serva zdvihu rotora';
			SC_Valcovanie2.IdleTime.PT:= T#500ms;
			SC_Valcovanie2.AlarmTime.PT:= T#5s;
			
			
			IF NOT SC_Valcovanie2.Switch1 THEN
				ZdvihRotora_HOME:= TRUE;
				SC_Valcovanie2.Switch1:= TRUE;
			END_IF
			
			IF Motion[4].status.DriveStatus.HomingOk THEN
				SC_Valcovanie2.IdleTime.IN:= TRUE;
			END_IF	
			
			IF Motion[4].status.DriveStatus.HomingOk AND SC_Valcovanie2.IdleTime.Q AND Motion[4].state.StandStill THEN
				SC_Valcovanie2.ResetStep:= TRUE;
				SC_Valcovanie2.Step:= 6;
			END_IF
		
		
		6:
			SC_Valcovanie2.StepName:='6 - Inicializacia - zasunutie zdvihu rotora do vychodiskovej pozicie';
			SC_Valcovanie2.IdleTime.PT:= T#500ms;
			SC_Valcovanie2.AlarmTime.PT:= T#5s;	
		
			
			IF NOT SC_Valcovanie2.Switch1 AND (Valcovanie2_AktualPozMM <> Valcovanie2_ZadanaPozSTART_MM) AND SC_OvlZdvihuRotora.Step = 1 THEN
				ZdvihRotora_PoziciaSTART:= TRUE;
				SC_Valcovanie2.Switch1:= TRUE;
			END_IF
				
			IF (Valcovanie2_AktualPozMM = Valcovanie2_ZadanaPozSTART_MM) AND Motion[4].state.StandStill THEN
				SC_Valcovanie2.ResetStep:= TRUE;
				SC_Valcovanie2.Step:= 9;
			END_IF
		
		9:
			SC_Valcovanie2.StepName:='9 - Inicializacia - vysunutie horneho pritlaku dole';
			SC_Valcovanie2.IdleTime.PT:= T#4s;
			SC_Valcovanie2.AlarmTime.PT:= T#5s;	
			
			IF NOT SC_Valcovanie2.Switch1 AND SC_OvlHornehoPritlaku.Step = 1 THEN
				HornyPritlak_DOLE:= TRUE;
				SC_Valcovanie2.Switch1:= TRUE;
			END_IF
			
			IF diValc2_PritlakVysunuty THEN
				SC_Valcovanie2.ResetStep:= TRUE;
				SC_Valcovanie2.Step:= 10;
			END_IF
			
			
		10:
			SC_Valcovanie2.StepName:='10 - Inicializacia - spustenie otacania nastroja';
			SC_Valcovanie2.IdleTime.PT:= T#4s;
			SC_Valcovanie2.AlarmTime.PT:= T#5s;	
	
			IF NOT SC_Valcovanie2.Switch1 AND SC_OvlOtacaniaNastroja.Step = 1 AND VonkajsieValcovanie_AKTIVNE THEN
				OtacanieNastroja_VPRED:= TRUE;
				SC_Valcovanie2.IdleTime.IN:= TRUE;
				SC_Valcovanie2.Switch1:= TRUE;
			END_IF
			
			IF SC_Valcovanie2.IdleTime.Q OR NOT VonkajsieValcovanie_AKTIVNE THEN
				Valcovanie2_PoINIT:= TRUE;
				SC_Valcovanie2.ResetStep:= TRUE;
				SC_Valcovanie2.Step:= 100;
			END_IF
			
		
			//********************************************************Automatický režim****************************************************************************//
		100:
			SC_Valcovanie2.StepName:='100 - Automaticky rezim - cakanie na start cyklu';
			SC_Valcovanie2.IdleTime.PT:= T#500ms;
			SC_Valcovanie2.AlarmTime.PT:= T#5s;	
		
            SC_Valcovanie2.IdleTime.IN:= NOT diValc2_PritomnostRotora;
            
			IF Valcovanie2_KoniecCyklu THEN
				SC_Valcovanie2.ResetStep:= TRUE;
				SC_Valcovanie2.Step:= 105;
			ELSIF NOT VonkajsieValcovanie_AKTIVNE THEN
				SC_Valcovanie2.ResetStep:= TRUE;
				SC_Valcovanie2.Step:= 120;
			ELSIF Stol_PoINIT AND NOT Valcovanie2_UkoncilCyklus AND diValc2_PritomnostRotora AND diStol_SnimacPolohyStola THEN
				SC_Valcovanie2.ResetStep:= TRUE;
				SC_Valcovanie2.Step:= 101;
			ELSIF Stol_PoINIT AND NOT Valcovanie2_UkoncilCyklus AND NOT diValc2_PritomnostRotora AND SC_Valcovanie2.IdleTime.Q THEN
				SC_Valcovanie2.ResetStep:= TRUE;
				SC_Valcovanie2.Step:= 120;
			ELSIF Valcovanie2_KoniecVyroby AND NOT Stol_Automat THEN
				SC_Valcovanie2.ResetStep:= TRUE;
				SC_Valcovanie2.Step:= 105;
			END_IF	
						
		
		
		101:
			SC_Valcovanie2.StepName:='101 - Automaticky rezim - zdvih rotora, streknutie oleja';
			SC_Valcovanie2.IdleTime.PT:= T#500ms;
			SC_Valcovanie2.AlarmTime.PT:= T#5s;	
		
			IF NOT SC_Valcovanie2.Switch1 AND SC_OvlZdvihuRotora.Step = 1 THEN
				ZdvihRotora_VALCOVANIE:= TRUE;
				SC_Valcovanie2.Switch1:= TRUE;
			END_IF
		
					
			IF Priznak_ValcovanieOK AND Valcovanie2_AktualPozMM = 13 AND Motion[4].state.StandStill AND diValc2_PritomnostRotora AND NOT diValc2_SpomalenieZdvihu THEN
				Priznak_ValcovanieOK:= FALSE;
				SC_Valcovanie2.ResetStep:= TRUE;
				SC_Valcovanie2.Step:= 120;
			ELSIF Priznak_ValcovanieOK AND Valcovanie2_AktualPozMM = 13 AND Motion[4].state.StandStill AND (NOT diValc2_PritomnostRotora OR diValc2_SpomalenieZdvihu) THEN	
				Alarmy[74]:= TRUE;
				PoruchaStanicaValcovania2:= TRUE; 
			ELSIF Priznak_ValcovanieNG AND (Valcovanie2_AktualPozMM = 13) AND Motion[4].state.StandStill THEN
				SC_Valcovanie2.ResetStep:= TRUE;
				SC_Valcovanie2.Step:= 110;
			END_IF
		
		105:
			SC_Valcovanie2.StepName:='105 - Automaticky rezim - zdvih vrchneho pritlaku';
			SC_Valcovanie2.IdleTime.PT:= T#500ms;
			SC_Valcovanie2.AlarmTime.PT:= T#5s;	
			
			IF NOT SC_Valcovanie2.Switch1 THEN
				HornyPritlak_HORE:= TRUE;
			END_IF		
			
			IF diValc2_PritlakZasunuty THEN
				SC_Valcovanie2.ResetStep:= TRUE;
				SC_Valcovanie2.Step:= 0;
			END_IF	
			
		110:
			SC_Valcovanie2.StepName:='110 - Automaticky rezim - zdvih vrchneho pritlaku po NG kusu';
			SC_Valcovanie2.IdleTime.PT:= T#500ms;
			SC_Valcovanie2.AlarmTime.PT:= T#5s;	
			
			IF NOT SC_Valcovanie2.Switch1 THEN
				HornyPritlak_HORE:= TRUE;
			END_IF		
			
			IF diValc2_PritlakZasunuty THEN
				Alarmy[75]:= TRUE;
				PoruchaStanicaValcovania2:= TRUE;
			END_IF	
			
			
			
			
		
		120:
			SC_Valcovanie2.StepName:='120 - Automaticky rezim - vystavenie signalu ukoncenie pracovneho cyklu';
			SC_Valcovanie2.IdleTime.PT:= T#500ms;
			SC_Valcovanie2.AlarmTime.PT:= T#5s;
		
			Valcovanie2_UkoncilCyklus:= TRUE;
			SC_Valcovanie2.ResetStep:= TRUE;
			SC_Valcovanie2.Step:= 121;
		
		
		121:
			SC_Valcovanie2.StepName:='121 - Automaticky rezim - cakanie na otocenie stola';
			SC_Valcovanie2.IdleTime.PT:= T#500ms;
			SC_Valcovanie2.AlarmTime.PT:= T#5s;
		
			
			IF NOT Valcovanie2_UkoncilCyklus THEN
				SC_Valcovanie2.ResetStep:= TRUE;
				SC_Valcovanie2.Step:= 100;
			ELSIF Valcovanie2_KoniecVyroby AND NOT Stol_Automat THEN
				SC_Valcovanie2.ResetStep:= TRUE;
				SC_Valcovanie2.Step:= 105;
			ELSIF Valcovanie2_KoniecCyklu THEN
				SC_Valcovanie2.ResetStep:= TRUE;
				SC_Valcovanie2.Step:= 105;
			END_IF		
			
		
		
			//********************************************************Ruèný režim***********************************************************************************//
		700:
			SC_Valcovanie2.StepName:='700 - Rucny rezim';
					
		
		
		
		
		
		
	END_CASE		
	
	
	
	 
				END_PROGRAM

PROGRAM _EXIT
				(* Insert code here *)
	 
				END_PROGRAM

