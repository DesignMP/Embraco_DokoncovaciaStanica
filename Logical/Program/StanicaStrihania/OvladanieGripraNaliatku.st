
ACTION OvladanieGripraNaliatku: 

	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_OvlGripraNaliatku);
	
	
	CASE SC_OvlGripraNaliatku.Step OF
		0:
			SC_OvlGripraNaliatku.StepName:= '0 - Nulovanie';
			GriperNaliatku_OTVOR:= FALSE;
			GriperNaliatku_ZATVOR:= FALSE;
			Vyrazanie.OUT.UchytenieNaliatkuOtvorit:= FALSE;
			Vyrazanie.OUT.UchytenieNaliatkuZatvorit:= FALSE;
			IF SC_Strihanie.Step <> 0 THEN
				SC_OvlGripraNaliatku.ResetStep:= TRUE;
				SC_OvlGripraNaliatku.Step:= 1;
			END_IF
	
		1:
			SC_OvlGripraNaliatku.StepName:= '1 - Rozhodnutie o cinnosti';	
			IF GriperNaliatku_OTVOR THEN
				SC_OvlGripraNaliatku.Step:= 10;
			ELSIF GriperNaliatku_ZATVOR THEN
				SC_OvlGripraNaliatku.Step:= 20;
			END_IF
		
		10:
			SC_OvlGripraNaliatku.StepName:= '10 - Otvorenie gripra';
			SC_OvlGripraNaliatku.IdleTime.PT:= T#3s;
			SC_OvlGripraNaliatku.AlarmTime.PT:= T#3s;
		
			IF Strihanie_Manual THEN
				SC_OvlGripraNaliatku.IdleTime.IN:= TRUE;
			ELSE	
				SC_OvlGripraNaliatku.AlarmTime.IN:= TRUE;
			END_IF
		
			IF NOT SC_OvlGripraNaliatku.Switch1 THEN
				Vyrazanie.OUT.UchytenieNaliatkuOtvorit:= TRUE;
				SC_OvlGripraNaliatku.Switch1:= TRUE;
			END_IF
		
			IF SC_OvlGripraNaliatku.AlarmTime.Q THEN
				Alarmy[42]:= TRUE;
				PoruchaStanicaStrihania:= TRUE;
			END_IF
		
			IF Vyrazanie.IN.UchytenieNaliatkuOtvorene OR SC_OvlGripraNaliatku.IdleTime.Q THEN
				SC_OvlGripraNaliatku.ResetStep:= TRUE;
				SC_OvlGripraNaliatku.Step:= 0;
			END_IF
		
		
		20:
			SC_OvlGripraNaliatku.StepName:= '20 - Zatvorenie gripra';
			SC_OvlGripraNaliatku.IdleTime.PT:= T#3s;
			SC_OvlGripraNaliatku.AlarmTime.PT:= T#3s;
		
			IF Strihanie_Manual THEN
				SC_OvlGripraNaliatku.IdleTime.IN:= TRUE;
			ELSE	
				SC_OvlGripraNaliatku.AlarmTime.IN:= TRUE;
			END_IF
					
					
			IF NOT SC_OvlGripraNaliatku.Switch1 THEN
				Vyrazanie.OUT.UchytenieNaliatkuZatvorit:= TRUE;
				SC_OvlGripraNaliatku.Switch1:= TRUE;
			END_IF
		
			IF SC_OvlGripraNaliatku.AlarmTime.Q THEN
				Alarmy[43]:= TRUE;
				PoruchaStanicaStrihania:= TRUE;
			END_IF
		
			IF (Vyrazanie.IN.UchytenieNaliatkuDrzimkus OR Vyrazanie.IN.UchytenieKolikaDrzimkus) OR SC_OvlGripraNaliatku.IdleTime.Q THEN
				SC_OvlGripraNaliatku.ResetStep:= TRUE;
				SC_OvlGripraNaliatku.Step:= 0;
			END_IF
		
		
		
		
		
	END_CASE		
	
	
	
	
	
	
	
			END_ACTION
