
ACTION OvladanieGripraStriznika: 

	
	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_OvlGripraStriznika);
	
	CASE SC_OvlGripraStriznika.Step OF
		0:
			SC_OvlGripraStriznika.StepName:= '0 - Nulovanie';
			GriperStriznika_OTVOR:= FALSE;
			GriperStriznika_ZATVOR:= FALSE;
			Vyrazanie.OUT.UchytenieKolikaOtvorit:= FALSE;
			Vyrazanie.OUT.UchytenieKolikaZatvorit:= FALSE;
			IF SC_Strihanie.Step <> 0 THEN
				SC_OvlGripraStriznika.ResetStep:= TRUE;
				SC_OvlGripraStriznika.Step:= 1;
			END_IF
	
	
		1:
			SC_OvlGripraStriznika.StepName:= '1 - Rozhodnutie o cinnosti';		
			IF GriperStriznika_OTVOR THEN
				SC_OvlGripraStriznika.Step:= 10;
			ELSIF GriperStriznika_ZATVOR THEN
				SC_OvlGripraStriznika.Step:= 20;
			END_IF
			
		10:
			SC_OvlGripraStriznika.StepName:= '10 - Otvorenie gripra';
			SC_OvlGripraStriznika.IdleTime.PT:= T#3s;
			SC_OvlGripraStriznika.AlarmTime.PT:= T#3s;
		
			IF Strihanie_Manual THEN
				SC_OvlGripraStriznika.IdleTime.IN:= TRUE;
			ELSE	
				SC_OvlGripraStriznika.AlarmTime.IN:= TRUE;
			END_IF
		
			IF NOT SC_OvlGripraStriznika.Switch1 THEN
				Vyrazanie.OUT.UchytenieKolikaOtvorit:= TRUE;
				SC_OvlGripraStriznika.Switch1:= TRUE;
			END_IF
		
			IF SC_OvlGripraStriznika.AlarmTime.Q THEN
				Alarmy[44]:= TRUE;
				PoruchaStanicaStrihania:= TRUE;
			END_IF
		
			IF Vyrazanie.IN.UchytenieKolikaOtvorene OR SC_OvlGripraStriznika.IdleTime.Q THEN
				SC_OvlGripraStriznika.ResetStep:= TRUE;
				SC_OvlGripraStriznika.Step:= 0;
			END_IF
			
		20:
			SC_OvlGripraStriznika.StepName:= '20 - Zatvorenie gripra';
			SC_OvlGripraStriznika.IdleTime.PT:= T#3s;
			SC_OvlGripraStriznika.AlarmTime.PT:= T#3s;
		
			IF Strihanie_Manual THEN
				SC_OvlGripraStriznika.IdleTime.IN:= TRUE;
			ELSE	
				SC_OvlGripraStriznika.AlarmTime.IN:= TRUE;
			END_IF
		
			IF NOT SC_OvlGripraStriznika.Switch1 THEN
				Vyrazanie.OUT.UchytenieKolikaZatvorit:= TRUE;
				SC_OvlGripraStriznika.Switch1:= TRUE;
			END_IF
		
			IF SC_OvlGripraStriznika.AlarmTime.Q THEN
				Alarmy[45]:= TRUE;
				PoruchaStanicaStrihania:= TRUE;
			END_IF
		
			IF Vyrazanie.IN.UchytenieKolikaDrzimkus OR SC_OvlGripraStriznika.IdleTime.Q THEN
				SC_OvlGripraStriznika.ResetStep:= TRUE;
				SC_OvlGripraStriznika.Step:= 0;
			END_IF
			
	END_CASE		
	
	
	
	
	
END_ACTION
