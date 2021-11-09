
ACTION OvladanieGripra: 

	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_OvlGripra);
	
	CASE SC_OvlGripra.Step OF
		
		0:
			SC_OvlGripra.StepName:= '0 - Nulovanie';
			Otvor_Griper:= FALSE;
			Zatvor_Griper:= FALSE;
			doVystupManipul_GriperOTVOR:= FALSE;
			doVystupManipul_GriperZATVOR:= FALSE;
			IF SC_VystupnyManipulator.Step <> 0 THEN
				SC_OvlGripra.ResetStep:= TRUE;
				SC_OvlGripra.Step:= 1;
			END_IF	
	
		1:
			SC_OvlGripra.StepName:= '1 - Rozhodnutie o cinnosti';
			IF Otvor_Griper THEN
				SC_OvlGripra.Step:= 10;
			ELSIF Zatvor_Griper THEN
				SC_OvlGripra.Step:= 20;
			END_IF
			
		10:
			SC_OvlGripra.StepName:= '10 - Otvorenie gripra';
			SC_OvlGripra.IdleTime.PT:= T#3s;
			SC_OvlGripra.AlarmTime.PT:= T#3s;
			
			IF VystupManipulator_Manual THEN
				SC_OvlGripra.IdleTime.IN:= TRUE;
			ELSE	
				SC_OvlGripra.AlarmTime.IN:= TRUE;
			END_IF
		
			IF NOT SC_OvlGripra.Switch1 THEN
				doVystupManipul_GriperOTVOR:= TRUE;
				SC_OvlGripra.Switch1:= TRUE;
			END_IF
			
			IF SC_OvlGripra.AlarmTime.Q THEN
				Alarmy[81]:= TRUE;
				PoruchaVystupManipulator:= TRUE;
			END_IF
		
			IF diVystupManipul_GriperOtvoreny OR SC_OvlGripra.IdleTime.Q THEN
				SC_OvlGripra.ResetStep:= TRUE;
				SC_OvlGripra.Step:= 0;
			END_IF
			
		20:
			SC_OvlGripra.StepName:= '20 - Zatvorenie gripra';
			SC_OvlGripra.IdleTime.PT:= T#3s;
			SC_OvlGripra.AlarmTime.PT:= T#3s;
			
			IF VystupManipulator_Manual THEN
				SC_OvlGripra.IdleTime.IN:= TRUE;
			ELSE	
				SC_OvlGripra.AlarmTime.IN:= TRUE;
			END_IF
		
			IF NOT SC_OvlGripra.Switch1 THEN
				doVystupManipul_GriperZATVOR:= TRUE;
				SC_OvlGripra.Switch1:= TRUE;
			END_IF
			
			IF SC_OvlGripra.AlarmTime.Q THEN
				Alarmy[80]:= TRUE;
				PoruchaVystupManipulator:= TRUE;
			END_IF
			
			IF diVystupManipul_GriperZatvoreny OR SC_OvlGripra.IdleTime.Q THEN
				SC_OvlGripra.ResetStep:= TRUE;
				SC_OvlGripra.Step:= 0;
			END_IF
			
	END_CASE		
	
	
	
	
	
	
END_ACTION
