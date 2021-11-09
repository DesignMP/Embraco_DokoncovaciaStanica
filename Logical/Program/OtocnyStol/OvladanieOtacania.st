
ACTION OvladanieOtacania: 

	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_OvlStola);
	
	
	
	
	CASE SC_OvlStola.Step OF
		
		0:
			SC_OvlStola.StepName:= '0 - Nulovanie';
			Otacaj_VPRED:= FALSE;
			Otacaj_VZAD:= FALSE;
			doStol_ODBRZDENIE:= FALSE;
			doStol_OtacajVPRED:= FALSE;
			doStol_OtacajVZAD:= FALSE;
			Stol.OUT.CentrovanieVysunut:=0;
			Stol.OUT.CentrovanieZasunut:=0;
	
			IF SC_Stol.Step <> 0 THEN
				SC_OvlStola.ResetStep:= TRUE;
				SC_OvlStola.Step:= 1;
			END_IF
	
	
		1:
			SC_OvlStola.StepName:= '1 - Rozhodnutie o cinnosti';
			IF Otacaj_VPRED THEN
				SC_OvlStola.Step:= 10;
			ELSIF Otacaj_VZAD THEN
				SC_OvlStola.Step:= 20;
			END_IF	
	
		10:
			SC_OvlStola.StepName:= '10 - Zasunutie centrovania';
			SC_OvlStola.IdleTime.PT:= T#7s;
			SC_OvlStola.AlarmTime.PT:= T#7s;
			IF Stol_Manual THEN
				SC_OvlStola.IdleTime.IN:= TRUE;
			ELSE	
				SC_OvlStola.AlarmTime.IN:= TRUE;
			END_IF
			
			IF NOT SC_OvlStola.Switch1 THEN
				Stol.OUT.CentrovanieVysunut:=0;
				Stol.OUT.CentrovanieZasunut:=1;
				SC_OvlStola.Switch1:= TRUE;
			END_IF		
			
			
			IF Stol.IN.CentrovanieZasunute=1 THEN
				SC_OvlStola.ResetStep:= TRUE;
				SC_OvlStola.Step:= 11;
			END_IF
			
		11:
			SC_OvlStola.StepName:= '11 - Spustenie otacania stola vpred';
			SC_OvlStola.IdleTime.PT:= T#7s;
			SC_OvlStola.AlarmTime.PT:= T#7s;
			IF Stol_Manual THEN
				SC_OvlStola.IdleTime.IN:= TRUE;
			ELSE	
				SC_OvlStola.AlarmTime.IN:= TRUE;
			END_IF
			
			IF NOT SC_OvlStola.Switch1 AND NOT Stol_BlokovanieOtacania THEN
				doStol_ODBRZDENIE:= TRUE;
				doStol_OtacajVPRED:= TRUE;
				SC_OvlStola.Switch1:= TRUE;
			END_IF
		
						
            IF doStol_OtacajVPRED AND NOT diStol_SnimacPolohyStola THEN
                SC_OvlStola.ResetStep:= TRUE;
				SC_OvlStola.Step:= 12;
			END_IF
			
		12:
			SC_OvlStola.StepName:= '12 - Zastavenie otacania stola vpred';
			SC_OvlStola.IdleTime.PT:= T#7s;
			SC_OvlStola.AlarmTime.PT:= T#7s;	
			
			
			IF EDGEPOS (diStol_SnimacPolohyStola = TRUE) THEN
				//Stol_PrebehloOtocenie:= TRUE;
				doStol_ODBRZDENIE:= FALSE;
				doStol_OtacajVPRED:= FALSE;
				SC_OvlStola.ResetStep:= TRUE;
				SC_OvlStola.Step:= 13;
			ELSIF SC_OvlStola.IdleTime.Q THEN
				doStol_ODBRZDENIE:= FALSE;
				doStol_OtacajVPRED:= FALSE;
				SC_OvlStola.ResetStep:= TRUE;
				SC_OvlStola.Step:= 0;
			END_IF
			
						
			
            IF SC_OvlStola.AlarmTime.Q THEN
				Alarmy[31]:= TRUE;
				PoruchaOtocnyStol:= TRUE;
			END_IF
			
		13:
			SC_OvlStola.StepName:= '13 - Vysunutie centrovania';
			SC_OvlStola.IdleTime.PT:= T#7s;
			SC_OvlStola.AlarmTime.PT:= T#7s;
			IF Stol_Manual THEN
				SC_OvlStola.IdleTime.IN:= TRUE;
			ELSE	
				SC_OvlStola.AlarmTime.IN:= TRUE;
			END_IF
			
			IF NOT SC_OvlStola.Switch1 THEN
				doStol_ODBRZDENIE:= FALSE;
				doStol_OtacajVPRED:= FALSE;
				Stol.OUT.CentrovanieVysunut:=1;
				Stol.OUT.CentrovanieZasunut:=0;
				SC_OvlStola.Switch1:= TRUE;
			END_IF		
			
			
			IF Stol.IN.CentrovanieVysunute=1 THEN
				Stol_PrebehloOtocenie:= TRUE;
				SC_OvlStola.ResetStep:= TRUE;
				SC_OvlStola.Step:= 0;
			END_IF
	
		20:
			SC_OvlStola.StepName:= '20 - Zasunutie centrovania';
			SC_OvlStola.IdleTime.PT:= T#7s;
			SC_OvlStola.AlarmTime.PT:= T#7s;
			IF Stol_Manual THEN
				SC_OvlStola.IdleTime.IN:= TRUE;
			ELSE	
				SC_OvlStola.AlarmTime.IN:= TRUE;
			END_IF
			
			IF NOT SC_OvlStola.Switch1 THEN
				Stol.OUT.CentrovanieVysunut:=0;
				Stol.OUT.CentrovanieZasunut:=1;
				SC_OvlStola.Switch1:= TRUE;
			END_IF		
			
			
			IF Stol.IN.CentrovanieZasunute=1 THEN
				SC_OvlStola.ResetStep:= TRUE;
				SC_OvlStola.Step:= 21;
			END_IF	
			
		21:
			SC_OvlStola.StepName:= '21 - Spustenie otacania stola vzad';
			SC_OvlStola.IdleTime.PT:= T#7s;
			SC_OvlStola.AlarmTime.PT:= T#7s;
			IF Stol_Manual THEN
				SC_OvlStola.IdleTime.IN:= TRUE;
			ELSE	
				SC_OvlStola.AlarmTime.IN:= TRUE;
			END_IF
			
			Stol.OUT.CentrovanieVysunut:=0;
			Stol.OUT.CentrovanieZasunut:=1;
			
			IF NOT SC_OvlStola.Switch1 AND NOT Stol_BlokovanieOtacania THEN
				doStol_ODBRZDENIE:= TRUE;
				doStol_OtacajVZAD:= TRUE;
				SC_OvlStola.Switch1:= TRUE;
			END_IF
		
			
			
            IF doStol_OtacajVZAD AND NOT diStol_SnimacPolohyStola THEN
                SC_OvlStola.ResetStep:= TRUE;
				SC_OvlStola.Step:= 22;
			END_IF
		
		22:
			SC_OvlStola.StepName:= '22 - Zastavenie otacania stola vzad';
			SC_OvlStola.IdleTime.PT:= T#7s;
			SC_OvlStola.AlarmTime.PT:= T#7s;	
			
			
			IF EDGEPOS (diStol_SnimacPolohyStola = TRUE) THEN
				//Stol_PrebehloOtocenie:= TRUE;
				doStol_ODBRZDENIE:= FALSE;
				doStol_OtacajVPRED:= FALSE;
				SC_OvlStola.ResetStep:= TRUE;
				SC_OvlStola.Step:= 23;
			ELSIF SC_OvlStola.IdleTime.Q THEN
				doStol_ODBRZDENIE:= FALSE;
				doStol_OtacajVPRED:= FALSE;
				SC_OvlStola.ResetStep:= TRUE;
				SC_OvlStola.Step:= 0;
			END_IF
			
						
			
            IF SC_OvlStola.AlarmTime.Q THEN
				Alarmy[31]:= TRUE;
				PoruchaOtocnyStol:= TRUE;
			END_IF
		
		23:
			SC_OvlStola.StepName:= '23 - Vysunutie centrovania';
			SC_OvlStola.IdleTime.PT:= T#7s;
			SC_OvlStola.AlarmTime.PT:= T#7s;
			IF Stol_Manual THEN
				SC_OvlStola.IdleTime.IN:= TRUE;
			ELSE	
				SC_OvlStola.AlarmTime.IN:= TRUE;
			END_IF
			
			IF NOT SC_OvlStola.Switch1 THEN
				doStol_ODBRZDENIE:= FALSE;
				doStol_OtacajVPRED:= FALSE;
				Stol.OUT.CentrovanieVysunut:=1;
				Stol.OUT.CentrovanieZasunut:=0;
				SC_OvlStola.Switch1:= TRUE;
			END_IF		
			
			
			IF Stol.IN.CentrovanieVysunute=1 THEN
				Stol_PrebehloOtocenie:= TRUE;
				SC_OvlStola.ResetStep:= TRUE;
				SC_OvlStola.Step:= 0;
			END_IF
	
	END_CASE		
	
	
	
END_ACTION
