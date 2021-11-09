
ACTION OvlHornehoPritlaku: 

	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_OvlHornehoPritlaku);
	
	
	
	CASE SC_OvlHornehoPritlaku.Step OF
		
		0:
			SC_OvlHornehoPritlaku.StepName:= '0 - Nulovanie';
			HornyPritlak_DOLE:= FALSE;
			HornyPritlak_HORE:= FALSE;
			doValc2_ZdvihPritlakuHORE:= FALSE;
//			doValcovanie2_ZostupPritlakuDOLE:= FALSE;
			IF SC_Valcovanie2.Step <> 0 THEN
				SC_OvlHornehoPritlaku.ResetStep:= TRUE;
				SC_OvlHornehoPritlaku.Step:= 1;
			END_IF
	
	
		1:
			SC_OvlHornehoPritlaku.StepName:= '1 - Rozhodnutie o cinnosti';
			IF HornyPritlak_HORE THEN
				SC_OvlHornehoPritlaku.Step:= 10;
			ELSIF HornyPritlak_DOLE THEN
				SC_OvlHornehoPritlaku.Step:= 20;
			END_IF	
	
	
		10:
			SC_OvlHornehoPritlaku.StepName:= '10 - Zodvihnutie horneho pritlaku hore';
			SC_OvlHornehoPritlaku.IdleTime.PT:= T#3s;
			SC_OvlHornehoPritlaku.AlarmTime.PT:= T#3s;
		
			IF Valcovanie2_Manual THEN
				SC_OvlHornehoPritlaku.IdleTime.IN:= TRUE;
			ELSE	
				SC_OvlHornehoPritlaku.AlarmTime.IN:= TRUE;
			END_IF
		
			IF NOT SC_OvlHornehoPritlaku.Switch1 THEN
				doValc2_ZostupPritlakuDOLE:= FALSE;
				doValc2_ZdvihPritlakuHORE:= TRUE;
				SC_OvlHornehoPritlaku.Switch1:= TRUE;
			END_IF
		
			IF SC_OvlHornehoPritlaku.AlarmTime.Q THEN
				Alarmy[57]:= TRUE;
				PoruchaStanicaValcovania2:= TRUE;
			END_IF
		
			IF diValc2_PritlakZasunuty OR SC_OvlHornehoPritlaku.IdleTime.Q THEN
				SC_OvlHornehoPritlaku.ResetStep:= TRUE;
				SC_OvlHornehoPritlaku.Step:= 0;
			END_IF	
		
		20:
			SC_OvlHornehoPritlaku.StepName:= '20 - Zostup horneho pritlaku dole';
			SC_OvlHornehoPritlaku.IdleTime.PT:= T#3s;
			SC_OvlHornehoPritlaku.AlarmTime.PT:= T#3s;
		
			IF Valcovanie2_Manual THEN
				SC_OvlHornehoPritlaku.IdleTime.IN:= TRUE;
			ELSE	
				SC_OvlHornehoPritlaku.AlarmTime.IN:= TRUE;
			END_IF
		
			IF NOT SC_OvlHornehoPritlaku.Switch1 THEN
				doValc2_ZdvihPritlakuHORE:= FALSE;
				doValc2_ZostupPritlakuDOLE:= TRUE;
				SC_OvlHornehoPritlaku.Switch1:= TRUE;
			END_IF
		
			IF SC_OvlHornehoPritlaku.AlarmTime.Q THEN
				Alarmy[58]:= TRUE;
				PoruchaStanicaValcovania2:= TRUE;
			END_IF
		
			IF diValc2_PritlakVysunuty OR SC_OvlHornehoPritlaku.IdleTime.Q THEN
				SC_OvlHornehoPritlaku.ResetStep:= TRUE;
				SC_OvlHornehoPritlaku.Step:= 0;
			END_IF	
		
	END_CASE
	
	
	
	
	
END_ACTION
