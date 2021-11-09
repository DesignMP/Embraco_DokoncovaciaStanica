
ACTION OvladanieOdsuvania: 


	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_OvlOdsuvaca);
	
	
	CASE SC_OvlOdsuvaca.Step OF
		
		0:
			SC_OvlOdsuvaca.StepName:= '0 - Nulovanie';
			Odsuvac_VYSUN:= FALSE;
			Odsuvac_ZASUN:= FALSE;
			doVystDopr_OdsuvacZASUN:= FALSE;
			doVystDopr_OdsuvacVYSUN:= FALSE;
			IF SC_VystupnyOdsuvac.Step <> 0 THEN
				SC_OvlOdsuvaca.ResetStep:= TRUE;
				SC_OvlOdsuvaca.Step:= 1;
			END_IF	
	
	
		1:
			SC_OvlOdsuvaca.StepName:= '1 - Rozhodnutie o cinnosti';
			IF Odsuvac_VYSUN THEN
				SC_OvlOdsuvaca.Step:= 10;
			ELSIF Odsuvac_ZASUN THEN
				SC_OvlOdsuvaca.Step:= 20;
			END_IF
		
		10:
			SC_OvlOdsuvaca.StepName:= '10 - Vysunutie odsuvaca vpred';
			SC_OvlOdsuvaca.IdleTime.PT:= T#3s;
			SC_OvlOdsuvaca.AlarmTime.PT:= T#3s;
		
			IF VystupOdsuvac_Manual THEN
				SC_OvlOdsuvaca.IdleTime.IN:= TRUE;
			ELSE	
				SC_OvlOdsuvaca.AlarmTime.IN:= TRUE;
			END_IF
		
			IF NOT SC_OvlOdsuvaca.Switch1 THEN
				doVystDopr_OdsuvacVYSUN:= TRUE;
				SC_OvlOdsuvaca.Switch1:= TRUE;
			END_IF
		
			IF SC_OvlOdsuvaca.AlarmTime.Q THEN
				Alarmy[90]:= TRUE;
				PoruchaVystupOdsuvac:= TRUE;
			END_IF
		
			IF diVystDopr_OdsuvacVysunuty OR SC_OvlOdsuvaca.IdleTime.Q THEN
				SC_OvlOdsuvaca.ResetStep:= TRUE;
				SC_OvlOdsuvaca.Step:= 0;
			END_IF
			
		
		20:
			SC_OvlOdsuvaca.StepName:= '20 - Zasunutie odsuvaca vzad';
			SC_OvlOdsuvaca.IdleTime.PT:= T#3s;
			SC_OvlOdsuvaca.AlarmTime.PT:= T#3s;
		
			IF VystupOdsuvac_Manual THEN
				SC_OvlOdsuvaca.IdleTime.IN:= TRUE;
			ELSE	
				SC_OvlOdsuvaca.AlarmTime.IN:= TRUE;
			END_IF
		
			IF NOT SC_OvlOdsuvaca.Switch1 THEN
				doVystDopr_OdsuvacZASUN:= TRUE;
				SC_OvlOdsuvaca.Switch1:= TRUE;
			END_IF
		
			IF SC_OvlOdsuvaca.AlarmTime.Q THEN
				Alarmy[91]:= TRUE;
				PoruchaVystupOdsuvac:= TRUE;
			END_IF
		
			IF diVystDopr_OdsuvacZasunuty OR SC_OvlOdsuvaca.IdleTime.Q THEN
				SC_OvlOdsuvaca.ResetStep:= TRUE;
				SC_OvlOdsuvaca.Step:= 0;
			END_IF
		
		
	
	END_CASE
	
	
	
	
END_ACTION
