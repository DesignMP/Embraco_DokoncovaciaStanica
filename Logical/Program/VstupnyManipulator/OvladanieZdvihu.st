
ACTION OvladanieZdvihu: 

	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_OvlZdvihu);
	
	
	CASE SC_OvlZdvihu.Step OF
		
		0:
			SC_OvlZdvihu.StepName:= '0 - Nulovanie';
			Zdvih_Manipulatora:= FALSE;
			Zostup_Manipulatora:= FALSE;
			doVstupManipul_ZDVIH:= FALSE;
			doVstupManipul_ZOSTUP:= FALSE;
			IF SC_VstupnyManipulator.Step <> 0 THEN
				SC_OvlZdvihu.ResetStep:= TRUE;
				SC_OvlZdvihu.Step:= 1;
			END_IF	
	
		
		1:
			SC_OvlZdvihu.StepName:= '1 - Rozhodnutie o cinnosti';
			IF Zdvih_Manipulatora THEN
				SC_OvlZdvihu.Step:= 10;
			ELSIF Zostup_Manipulatora THEN
				SC_OvlZdvihu.Step:= 20;
			END_IF
		
		10:
			SC_OvlZdvihu.StepName:= '10 - Zdvih manipulatora';
			SC_OvlZdvihu.IdleTime.PT:= T#3s;
			SC_OvlZdvihu.AlarmTime.PT:= T#3s;
			
			IF VstupManipulator_Manual THEN
				SC_OvlZdvihu.IdleTime.IN:= TRUE;
			ELSE	
				SC_OvlZdvihu.AlarmTime.IN:= TRUE;
			END_IF
		
			IF NOT SC_OvlZdvihu.Switch1 THEN
				doVstupManipul_ZDVIH:= TRUE;
				SC_OvlZdvihu.Switch1:= TRUE;
			END_IF
		
			IF SC_OvlZdvihu.AlarmTime.Q THEN
				Alarmy[22]:= TRUE;
				PoruchaVstupManipulator:= TRUE;
			END_IF
		
			IF diVstupManipul_ZasunutyHore OR SC_OvlZdvihu.IdleTime.Q THEN
				SC_OvlZdvihu.ResetStep:= TRUE;
				SC_OvlZdvihu.Step:= 0;
			END_IF
		
		20:
			SC_OvlZdvihu.StepName:= '20 - Zostup manipulatora';
			SC_OvlZdvihu.IdleTime.PT:= T#2s;
			SC_OvlZdvihu.AlarmTime.PT:= T#3s;	
			SC_OvlZdvihu.IdleTime.IN:= TRUE;
					
			IF VstupManipulator_Manual THEN
				SC_OvlZdvihu.IdleTime.IN:= TRUE;
			ELSE	
				SC_OvlZdvihu.AlarmTime.IN:= TRUE;
			END_IF
			
						
			IF NOT SC_OvlZdvihu.Switch1 THEN
				doVstupManipul_ZOSTUP:= TRUE;
				SC_OvlZdvihu.Switch1:= TRUE;
			END_IF
		
			IF EDGEPOS (diVstupManipul_ZdvihStredPoloha = TRUE) THEN
				doVstupManipul_ZDVIH:= TRUE;
			END_IF	
			
			IF SC_OvlZdvihu.AlarmTime.Q THEN
				Alarmy[23]:= TRUE;
				PoruchaVstupManipulator:= TRUE;
			END_IF
						
			
			IF diVstupManipul_VysunutyDole OR SC_OvlZdvihu.IdleTime.Q THEN
				SC_OvlZdvihu.ResetStep:= TRUE;
				SC_OvlZdvihu.Step:= 0;
			END_IF
		
		
	END_CASE
	
END_ACTION
