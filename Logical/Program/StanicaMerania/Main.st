
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	
	diTlacitko_RotorNG;
	diTlacitko_RotorOK;
	doZelenaLED_Tlacitko_rotor_OK;
	doCervenaLED_Tlacitko_rotor_NG;
	diMeranie_Osciloskop_Stav_NG;
	diMeranie_Osciloskop_Stav_OK;
	doMeranie_Osciloskop_START;
	doMeranie_Osciloskop_STOP;
	
	
	//Ovládanie vzorkovacej frekvencie osciloskopu//
	IF RotorOtacaj_VPRED THEN
		doMeranie_Osciloskop_Frekvencia:= Blikac50ms;
	ELSE
		doMeranie_Osciloskop_Frekvencia:= FALSE;
	END_IF	
		
		
	//Meranie prestoja na stanici merania//
	IF StratovyCas_START THEN
		StratovyCas_Milisekundy:= StratovyCas_Milisekundy + 1;
		IF StratovyCas_Milisekundy >= 1000 THEN
			StratovyCas_Sekundy:= StratovyCas_Sekundy + 1;
			StratovyCas_Milisekundy:= 0;
		END_IF
		IF StratovyCas_Sekundy >= 60 THEN
			StratovyCas_Minuty:= StratovyCas_Minuty + 1;
			StratovyCas_Sekundy:= 0;
		END_IF	
		IF StratovyCas_Minuty >= 60 THEN
			StratovyCas_Hodiny:= StratovyCas_Hodiny + 1;
			StratovyCas_Minuty:= 0;
		END_IF
		IF StratovyCas_Hodiny >= 24 THEN
			StratovyCas_RESET:= TRUE;
		END_IF
	END_IF	
		
	IF StratovyCas_RESET THEN
		StratovyCas_Milisekundy:= 0;
		StratovyCas_Sekundy:= 0;
		StratovyCas_Minuty:= 0;
		StratovyCas_Hodiny:= 0;
		StratovyCas_RESET:= FALSE;
	END_IF	
	
	
	
	
	
	//Volanie podprogramov//
	OvladanieOtacaniaRotora;
	OvladanieZdvihu;
	
	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_Meranie);
	
	//Prepoèet èasu merania//
	CasMerania:= REAL_TO_TIME(TP_Meranie_CasMerania*1000);
	
	
	
	//Reset sekcie //
	IF Meranie_Reset OR NOT BezpOkruhOplotenia_Aktivovany OR PoruchaStanicaMerania THEN
		SC_Meranie.Step:= 0;
	END_IF
	
	
	CASE SC_Meranie.Step OF 
	
	
		0:
			SC_Meranie.StepName:='0 - Nulovanie';
			SC_OvlOtacania.Step:= 0;
			SC_OvlZdvihu.Step:= 0;;
			Meranie_Automat:= FALSE;
			Meranie_KoniecVyroby:= FALSE;
			Meranie_KoniecCyklu:= FALSE;
			Meranie_Manual:= FALSE;
			Meranie_PoINIT:= FALSE;
			Meranie_Reset:= FALSE;
			Meranie_UkoncilCyklus:= FALSE;
			Meranie_ObsluhaRozhodla:= FALSE;
			doCervenaLED_Tlacitko_rotor_NG:= FALSE;
			doZelenaLED_Tlacitko_rotor_OK:= FALSE;
			StratovyCas_START:= FALSE;
			doMeranie_Osciloskop_START:= FALSE;
			IF BezpOkruhOplotenia_Aktivovany AND NOT PoruchaStanicaMerania THEN
				SC_Meranie.ResetStep:= TRUE;
				SC_Meranie.Step:= 1;
			END_IF
	
		
		1:
			SC_Meranie.StepName:='1 - Rozhodnutie o cinnosti';
			IF Meranie_Automat THEN
				SC_Meranie.Step:= 2;
			ELSIF Meranie_Manual THEN
				SC_Meranie.Step:= 700;
			END_IF
		
		
			//********************************************************Inicializácia****************************************************************************//
		
		2:
			SC_Meranie.StepName:='2 - Inicializacia - cakanie na spustenie';
			SC_Meranie.IdleTime.PT:= T#500ms;
			SC_Meranie.AlarmTime.PT:= T#5s;
			SC_Meranie.IdleTime.IN:= TRUE;
				
			
			IF SC_Meranie.IdleTime.Q THEN
				SC_Meranie.ResetStep:= TRUE;
				SC_Meranie.Step:= 3;
			END_IF
	
		
		3:
			SC_Meranie.StepName:='2 - Inicializacia - zasunutie zdvihu rotora';
			SC_Meranie.IdleTime.PT:= T#500ms;
			SC_Meranie.AlarmTime.PT:= T#5s;
		
			IF NOT SC_Meranie.Switch1 THEN
				Rotor_POLOZ:= TRUE;
				SC_Meranie.Switch1:= TRUE;
			END_IF
		
			IF diMeranie_ZdvihSpodnaPoloha THEN
				RotorOtacaj_VPRED:= TRUE;
				Meranie_PoINIT:= TRUE;
				SC_Meranie.ResetStep:= TRUE;
				SC_Meranie.Step:= 100;
			END_IF
		
		
		
		
		
			//********************************************************Automatický režim****************************************************************************//
		100:
			SC_Meranie.StepName:='100 - Automaticky rezim - cakanie na start cyklu';
			SC_Meranie.IdleTime.PT:= T#500ms;
			SC_Meranie.AlarmTime.PT:= T#5s;
		
           SC_Meranie.IdleTime.IN:= NOT diMeranie_PritomnostRotora; 
            
			IF Meranie_KoniecCyklu THEN
				SC_Meranie.ResetStep:= TRUE;
				SC_Meranie.Step:= 0;
			ELSIF Zariadenie_PrebiehaRevorkRezim THEN
				SC_Meranie.ResetStep:= TRUE;
				SC_Meranie.Step:= 120;
			ELSIF Stol_PoINIT AND NOT Meranie_UkoncilCyklus AND diMeranie_PritomnostRotora AND diStol_SnimacPolohyStola THEN
				Meranie_ObsluhaRozhodla:= FALSE;
				doCervenaLED_Tlacitko_rotor_NG:= FALSE;
				doZelenaLED_Tlacitko_rotor_OK:= FALSE;
				SC_Meranie.ResetStep:= TRUE;
				SC_Meranie.Step:= 101;
			ELSIF Stol_PoINIT AND NOT Meranie_UkoncilCyklus AND NOT diMeranie_PritomnostRotora AND SC_Meranie.IdleTime.Q THEN
				Meranie_ObsluhaRozhodla:= FALSE;
				doCervenaLED_Tlacitko_rotor_NG:= FALSE;
				doZelenaLED_Tlacitko_rotor_OK:= FALSE;
				Stol_Pozicia_1:= 0;
				SC_Meranie.ResetStep:= TRUE;
				SC_Meranie.Step:= 120;
			ELSIF Meranie_KoniecVyroby AND NOT Stol_Automat THEN
				SC_Meranie.ResetStep:= TRUE;
				SC_Meranie.Step:= 0;
			END_IF
		
		
		101:
			SC_Meranie.StepName:='101 - Automaticky rezim - zdvih rotora';
			SC_Meranie.IdleTime.PT:= T#1s;
			SC_Meranie.AlarmTime.PT:= T#5s;
		
			IF NOT SC_Meranie.Switch1 AND SC_OvlZdvihu.Step = 1 THEN
				Rotor_ZDVIHNI:= TRUE;
				SC_Meranie.IdleTime.IN:= TRUE;
				SC_Meranie.Switch1:= TRUE;
			END_IF
		
			IF diMeranie_ZdvihHornaPoloha THEN
				SC_Meranie.ResetStep:= TRUE;
				SC_Meranie.Step:= 102;
			END_IF
		
		102:
			SC_Meranie.StepName:='102 - Automaticky rezim - spustenie otacania, cakanie na vysledok merania';
			SC_Meranie.IdleTime.PT:= T#5s;
			SC_Meranie.AlarmTime.PT:= T#2s;
			SC_Meranie.IdleTime.IN:= TRUE;
			
				
			IF NOT SC_Meranie.Switch1 THEN
				RotorOtacaj_VPRED:= TRUE;
				doMeranie_Osciloskop_START:= TRUE;
				SC_Meranie.AlarmTime.IN:= TRUE;
				SC_Meranie.Switch1:= TRUE;
			END_IF
			
			IF SC_Meranie.IdleTime.Q THEN
				StratovyCas_START:= TRUE;
			END_IF	
			
						
			IF EDGEPOS(diMeranie_Osciloskop_Stav_OK) THEN
				Stol_Pozicia_1:= 1;
				StratovyCas_START:= FALSE;
				doMeranie_Osciloskop_START:= FALSE;
				SC_Meranie.ResetStep:= TRUE;
				SC_Meranie.Step:= 103;
			ELSIF EDGEPOS(diMeranie_Osciloskop_Stav_NG) THEN
				Stol_Pozicia_1:= 2;
				StratovyCas_START:= FALSE;
				doMeranie_Osciloskop_START:= FALSE;
				SC_Meranie.ResetStep:= TRUE;
				SC_Meranie.Step:= 103;
			ELSIF Meranie_KoniecCyklu THEN
				StratovyCas_START:= FALSE;
				doMeranie_Osciloskop_START:= FALSE;
				SC_Meranie.ResetStep:= TRUE;
				SC_Meranie.Step:= 103;	
			END_IF	
			
			
			
			
			
		103:
			SC_Meranie.StepName:='103 - Automaticky rezim - zasunutie zdvihu rotora';
			SC_Meranie.IdleTime.PT:= T#5s;
			SC_Meranie.AlarmTime.PT:= T#5s;
		
			IF NOT SC_Meranie.Switch1  AND SC_OvlZdvihu.Step = 1 THEN
				Rotor_POLOZ:= TRUE;
				SC_Meranie.Switch1:= TRUE;
			END_IF
		
			IF diMeranie_ZdvihSpodnaPoloha AND diMeranie_PritomnostRotora AND NOT diMeranie_ZdvihHornaPoloha THEN
				SC_Meranie.ResetStep:= TRUE;
				SC_Meranie.Step:= 120;
			ELSIF diMeranie_ZdvihSpodnaPoloha AND NOT diMeranie_PritomnostRotora THEN	
				Alarmy[73]:= TRUE;
				PoruchaStanicaMerania:= TRUE;
			ELSIF diMeranie_ZdvihSpodnaPoloha AND diMeranie_ZdvihHornaPoloha THEN	
				Alarmy[73]:= TRUE;
				PoruchaStanicaMerania:= TRUE;	
			END_IF
				
		
			
		120:
			SC_Meranie.StepName:='120 - Automaticky rezim - vystavenie signalu ukoncenie pracovneho cyklu';
			SC_Meranie.IdleTime.PT:= T#5s;
			SC_Meranie.AlarmTime.PT:= T#5s;
		
			Meranie_UkoncilCyklus:= TRUE;
			SC_Meranie.ResetStep:= TRUE;
			SC_Meranie.Step:= 121;
		
			
		
		121:
			SC_Meranie.StepName:='121 - Automaticky rezim - cakanie na otocenie stola';
			SC_Meranie.IdleTime.PT:= T#5s;
			SC_Meranie.AlarmTime.PT:= T#5s;
		
			IF NOT Meranie_UkoncilCyklus THEN
				SC_Meranie.ResetStep:= TRUE;
				SC_Meranie.Step:= 100;
			ELSIF Meranie_KoniecVyroby AND NOT Stol_Automat THEN
				SC_Meranie.ResetStep:= TRUE;
				SC_Meranie.Step:= 0;
			ELSIF Meranie_KoniecCyklu THEN
				SC_Meranie.ResetStep:= TRUE;
				SC_Meranie.Step:= 0;	
			END_IF
			
		
			//********************************************************Ruèný režim***********************************************************************************//
		700:
			SC_Meranie.StepName:='700 - Rucny rezim';
		
		
		
		
	
	END_CASE
	
	
	

	
	
	
	
	 
				END_PROGRAM

PROGRAM _EXIT
				(* Insert code here *)
	 
				END_PROGRAM

