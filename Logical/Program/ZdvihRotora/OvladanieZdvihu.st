
ACTION OvladanieZdvihu: 

	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_OvlZdvihu);
	
	CASE SC_OvlZdvihu.Step OF
		
		0:
			SC_OvlZdvihu.StepName:= '0 - Nulovanie';
			ZdvihniRotor:= FALSE;
			PolozRotor:= FALSE;
			IF SC_ZdvihRotora.Step <> 0 THEN
				SC_OvlZdvihu.ResetStep:= TRUE;
				SC_OvlZdvihu.Step:= 1;
			END_IF
		
		1:
			SC_OvlZdvihu.StepName:= '1 - Rozhodnutie o cinnosti';
			IF ZdvihniRotor THEN
				SC_OvlZdvihu.Step:= 10;
			ELSIF PolozRotor THEN
				SC_OvlZdvihu.Step:= 20;
			END_IF
		
		10:
			SC_OvlZdvihu.StepName:= '10 - Vysunutie zdvihu';
			SC_OvlZdvihu.IdleTime.PT:= T#1s;
			SC_OvlZdvihu.AlarmTime.PT:= T#3s;
			IF ZdvihRotora_Manual THEN
				SC_OvlZdvihu.IdleTime.IN:= TRUE;
			ELSE	
				SC_OvlZdvihu.AlarmTime.IN:= TRUE;
			END_IF
		
			IF NOT SC_OvlZdvihu.Switch1 THEN
				doVstupDopr_VysunZdvihRotora:= TRUE;
				SC_OvlZdvihu.Switch1:= TRUE;
			END_IF
		
			IF SC_OvlZdvihu.AlarmTime.Q THEN
				Alarmy[15]:= TRUE;
				PoruchaZdvihuRotora:= TRUE;
			END_IF
		
			IF diVstupDopr_ZdvihRotora_HORE OR SC_OvlZdvihu.IdleTime.Q THEN
				SC_OvlZdvihu.ResetStep:= TRUE;
				SC_OvlZdvihu.Step:= 0;
			END_IF
		
		
		20:
			SC_OvlZdvihu.StepName:= '20 - Zasunutie zdvihu';
			SC_OvlZdvihu.IdleTime.PT:= T#1s;
			SC_OvlZdvihu.AlarmTime.PT:= T#3s;
			IF ZdvihRotora_Manual THEN
				SC_OvlZdvihu.IdleTime.IN:= TRUE;
			ELSE	
				SC_OvlZdvihu.AlarmTime.IN:= TRUE;
			END_IF
		
		
			IF NOT SC_OvlZdvihu.Switch1 THEN
				doVstupDopr_VysunZdvihRotora:= FALSE;
				SC_OvlZdvihu.Switch1:= TRUE;
			END_IF
		
			IF SC_OvlZdvihu.AlarmTime.Q THEN
				Alarmy[16]:= TRUE;
				PoruchaZdvihuRotora:= TRUE;
			END_IF
		
			IF diVstupDopr_ZdvihRotora_DOLE OR SC_OvlZdvihu.IdleTime.Q THEN
				SC_OvlZdvihu.ResetStep:= TRUE;
				SC_OvlZdvihu.Step:= 0;
			END_IF
		
		
		
		
		
		
	END_CASE
	
	
	
END_ACTION
