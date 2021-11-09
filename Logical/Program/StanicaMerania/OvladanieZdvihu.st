
ACTION OvladanieZdvihu: 

	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_OvlZdvihu);
	
	CASE SC_OvlZdvihu.Step OF
	
		0:
			SC_OvlZdvihu.StepName:= '0 - Nulovanie';
			Rotor_ZDVIHNI:= FALSE;
			Rotor_POLOZ:= FALSE;
			doMeranie_ZDVIH:= FALSE;
			doMeranie_ZOSTUP:= FALSE;
			IF SC_Meranie.Step <> 0 THEN
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
			SC_OvlZdvihu.IdleTime.PT:= T#1s;
			SC_OvlZdvihu.AlarmTime.PT:= T#3s;
			SC_OvlZdvihu.IdleTime.IN:= TRUE;
			
			IF NOT SC_OvlZdvihu.Switch1 THEN
				doMeranie_ZDVIH:= TRUE;
				SC_OvlZdvihu.Switch1:= TRUE;
			END_IF
		
//			IF SC_OvlZdvihu.AlarmTime.Q THEN
//				Alarmy[70]:= TRUE;
//				PoruchaStanicaMerania:= TRUE;
//			END_IF
		
			IF SC_OvlZdvihu.IdleTime.Q THEN
				SC_OvlZdvihu.ResetStep:= TRUE;
				SC_OvlZdvihu.Step:= 0;
			END_IF	
			
		
		
		20:
			SC_OvlZdvihu.StepName:= '20 - Polozenie rotora';
			SC_OvlZdvihu.IdleTime.PT:= T#3s;
			SC_OvlZdvihu.AlarmTime.PT:= T#3s;
		
			IF Meranie_Manual THEN
				SC_OvlZdvihu.IdleTime.IN:= TRUE;
			ELSE	
				SC_OvlZdvihu.AlarmTime.IN:= TRUE;
			END_IF
		
			IF NOT SC_OvlZdvihu.Switch1 THEN
				doMeranie_ZOSTUP:= TRUE;
				SC_OvlZdvihu.Switch1:= TRUE;
			END_IF
		
			IF SC_OvlZdvihu.AlarmTime.Q THEN
				Alarmy[71]:= TRUE;
				PoruchaStanicaMerania:= TRUE;
			END_IF
		
			IF diMeranie_ZdvihSpodnaPoloha OR SC_OvlZdvihu.IdleTime.Q THEN
				SC_OvlZdvihu.ResetStep:= TRUE;
				SC_OvlZdvihu.Step:= 0;
			END_IF	
		
		
		
	
	END_CASE
	
END_ACTION
