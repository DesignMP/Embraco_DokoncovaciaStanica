
ACTION OvladanieZdvihu: 

	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_OvlZdvihu);
	
	CASE SC_OvlZdvihu.Step OF
		
		0:
			SC_OvlZdvihu.StepName:= '0 - Nulovanie';
			Rotor_ZDVIHNI:= FALSE;
			Rotor_POLOZ:= FALSE;
			RR_Rotor_ZDVIHNI:= FALSE;
			RR_Rotor_POLOZ:= FALSE;
			Vyrazanie.OUT.VyrazanieVysunut:= FALSE;
			Vyrazanie.OUT.VyrazanieZasunut:= FALSE;
			ChybaVystrihnutia:= FALSE;
			IF SC_Strihanie.Step <> 0 THEN
				SC_OvlZdvihu.ResetStep:= TRUE;
				SC_OvlZdvihu.Step:= 1;
			END_IF
			
		
		1:
			SC_OvlZdvihu.StepName:= '1 - Rozhodnutie o cinnosti';
			IF Rotor_ZDVIHNI THEN
				SC_OvlZdvihu.Step:= 10;
			ELSIF Rotor_POLOZ THEN
				SC_OvlZdvihu.Step:= 20;
			ELSIF RR_Rotor_ZDVIHNI THEN	
				SC_OvlZdvihu.Step:= 30;
			ELSIF RR_Rotor_POLOZ THEN
				SC_OvlZdvihu.Step:= 40;
			END_IF	
		
		10:
			SC_OvlZdvihu.StepName:= '10 - Zodvihnutie rotora';
			SC_OvlZdvihu.IdleTime.PT:= T#8s;
			SC_OvlZdvihu.AlarmTime.PT:= T#6s;
		
			IF Strihanie_Manual THEN
				SC_OvlZdvihu.IdleTime.IN:= TRUE;
			ELSE	
				SC_OvlZdvihu.AlarmTime.IN:= TRUE;
			END_IF
		
			IF NOT SC_OvlZdvihu.Switch1 THEN
				Vyrazanie.OUT.VyrazanieZasunut:= FALSE;
				Vyrazanie.OUT.VyrazanieVysunut:= TRUE;
				SC_OvlZdvihu.Switch1:= TRUE;
			END_IF
		
			IF SC_OvlZdvihu.AlarmTime.Q THEN
				ChybaVystrihnutia:= TRUE;
			END_IF
		
			
			IF ChybaVystrihnutia THEN
				SC_OvlZdvihu.ResetStep:= TRUE;
				SC_OvlZdvihu.Step:= 20;
			ELSIF Vyrazanie.IN.VyrazanieJeHore OR SC_OvlZdvihu.IdleTime.Q THEN
				SC_OvlZdvihu.ResetStep:= TRUE;
				SC_OvlZdvihu.Step:= 0;
			END_IF
		
		20:
			SC_OvlZdvihu.StepName:= '20 - Polozenie rotora';
			SC_OvlZdvihu.IdleTime.PT:= T#6s;
			SC_OvlZdvihu.AlarmTime.PT:= T#5s;
		
			IF Strihanie_Manual THEN
				SC_OvlZdvihu.IdleTime.IN:= TRUE;
			ELSE	
				SC_OvlZdvihu.AlarmTime.IN:= TRUE;
			END_IF
		
			IF NOT SC_OvlZdvihu.Switch1 THEN
				Vyrazanie.OUT.VyrazanieVysunut:= FALSE;
				Vyrazanie.OUT.VyrazanieZasunut:= TRUE;
				SC_OvlZdvihu.Switch1:= TRUE;
			END_IF
		
			IF SC_OvlZdvihu.AlarmTime.Q THEN
				Alarmy[41]:= TRUE;
				PoruchaStanicaStrihania:= TRUE;
			END_IF
		
			IF ChybaVystrihnutia AND Vyrazanie.IN.VyrazanieJeDole THEN
				Alarmy[40]:= TRUE;
				PoruchaStanicaStrihania:= TRUE;
			ELSIF Vyrazanie.IN.VyrazanieJeDole OR SC_OvlZdvihu.IdleTime.Q THEN
				SC_OvlZdvihu.ResetStep:= TRUE;
				SC_OvlZdvihu.Step:= 0;	
			END_IF	
				
				
					
		30:
			SC_OvlZdvihu.StepName:= '30 - Zodvihnutie rotora v rucnom rezime';
			SC_OvlZdvihu.IdleTime.PT:= T#6s;
			SC_OvlZdvihu.AlarmTime.PT:= T#6s;
				
			IF NOT SC_OvlZdvihu.Switch1 THEN
				Vyrazanie.OUT.VyrazanieZasunut:= FALSE;
				Vyrazanie.OUT.VyrazanieVysunut:= TRUE;
				SC_OvlZdvihu.Switch1:= TRUE;
			END_IF
		
			
			IF Vyrazanie.IN.VyrazanieJeHore OR NOT RR_Rotor_ZDVIHNI THEN
				SC_OvlZdvihu.ResetStep:= TRUE;
				SC_OvlZdvihu.Step:= 0;
			END_IF
		
		40:
			SC_OvlZdvihu.StepName:= '40 - Polozenie rotora v rucnom rezime';
			SC_OvlZdvihu.IdleTime.PT:= T#6s;
			SC_OvlZdvihu.AlarmTime.PT:= T#5s;
			SC_OvlZdvihu.IdleTime.IN:= TRUE;
					
			IF NOT SC_OvlZdvihu.Switch1 THEN
				Vyrazanie.OUT.VyrazanieVysunut:= FALSE;
				Vyrazanie.OUT.VyrazanieZasunut:= TRUE;
				SC_OvlZdvihu.Switch1:= TRUE;
			END_IF
		
					
			IF SC_OvlZdvihu.IdleTime.Q OR Vyrazanie.IN.VyrazanieJeDole THEN
				SC_OvlZdvihu.ResetStep:= TRUE;
				SC_OvlZdvihu.Step:= 0;	
			END_IF	
		
		
		
	END_CASE		
	
	
	
END_ACTION
