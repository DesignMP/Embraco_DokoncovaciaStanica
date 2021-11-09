
ACTION OvladanieZdvihuRotora: 

	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_OvlZdvihu);
	
	CASE SC_OvlZdvihu.Step OF
		
		0:
			SC_OvlZdvihu.StepName:= '0 - Nulovanie';
			Rotor_ZDVIHNI:= FALSE;
			Rotor_POLOZ:= FALSE;
			doValcovanie_ZDVIH_Rotora:= FALSE;
			doValcovanie_ZOSTUP_Rotora:= FALSE;
			IF SC_Valcovanie.Step <> 0 THEN
				SC_OvlZdvihu.ResetStep:= TRUE;
				SC_OvlZdvihu.Step:= 1;
			END_IF
	
	
		1:
			SC_OvlZdvihu.StepName:= '1 - Rozhodnutie o cinnosti';
			IF Rotor_ZDVIHNI THEN
				SC_OvlZdvihu.Step:= 10;
			ELSIF Rotor_POLOZ THEN
				SC_OvlZdvihu.Step:= 20;
			END_IF	
	
	
		10:
			SC_OvlZdvihu.StepName:= '10 - Zodvihnutie rotora';
			SC_OvlZdvihu.IdleTime.PT:= T#3s;
			SC_OvlZdvihu.AlarmTime.PT:= T#3s;
		
			IF Valcovanie_Manual THEN
				SC_OvlZdvihu.IdleTime.IN:= TRUE;
			ELSE	
				SC_OvlZdvihu.AlarmTime.IN:= TRUE;
			END_IF
		
			IF NOT SC_OvlZdvihu.Switch1 THEN
				doValcovanie_ZDVIH_Rotora:= TRUE;
				SC_OvlZdvihu.Switch1:= TRUE;
			END_IF
		
			IF SC_OvlZdvihu.AlarmTime.Q THEN
				Alarmy[60]:= TRUE;
				PoruchaStanicaValcovania:= TRUE;
			END_IF
		
			IF diValcovanie_ZdvihHornaPoloha OR SC_OvlZdvihu.IdleTime.Q THEN
				SC_OvlZdvihu.ResetStep:= TRUE;
				SC_OvlZdvihu.Step:= 0;
			END_IF	
			
		20:
			SC_OvlZdvihu.StepName:= '20 - Polozenie rotora';
			SC_OvlZdvihu.IdleTime.PT:= T#3s;
			SC_OvlZdvihu.AlarmTime.PT:= T#3s;
		
			IF Valcovanie_Manual THEN
				SC_OvlZdvihu.IdleTime.IN:= TRUE;
			ELSE	
				SC_OvlZdvihu.AlarmTime.IN:= TRUE;
			END_IF
		
			IF NOT SC_OvlZdvihu.Switch1 THEN
				doValcovanie_ZOSTUP_Rotora:= TRUE;
				SC_OvlZdvihu.Switch1:= TRUE;
			END_IF
		
			IF SC_OvlZdvihu.AlarmTime.Q THEN
				Alarmy[61]:= TRUE;
				PoruchaStanicaValcovania:= TRUE;
			END_IF
		
			IF diValcovanie_ZdvihSpodnaPoloha OR SC_OvlZdvihu.IdleTime.Q THEN
				SC_OvlZdvihu.ResetStep:= TRUE;
				SC_OvlZdvihu.Step:= 0;
			END_IF	
				
			
				
	END_CASE
	
	
			END_ACTION
