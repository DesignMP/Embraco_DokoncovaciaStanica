
ACTION OvladanieOdkloneniaGriprov: 

	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_OvlOdklonenia);
	
	
	CASE SC_OvlOdklonenia.Step OF
		
		0:
			SC_OvlOdklonenia.StepName:= '0 - Nulovanie';
			OdklonGriprov_ODOBERANIE:= FALSE;
			OdklonGriprov_ZAHODENIE:= FALSE;
			Vyrazanie.OUT.OdhadzovanieVysunut:= FALSE;
			Vyrazanie.OUT.OdhadzovanieZasunut:= FALSE;
			IF SC_Strihanie.Step <> 0 THEN
				SC_OvlOdklonenia.ResetStep:= TRUE;
				SC_OvlOdklonenia.Step:= 1;
			END_IF
	
	
		1:
			SC_OvlOdklonenia.StepName:= '1 - Rozhodnutie o cinnosti';
			IF OdklonGriprov_ODOBERANIE THEN
				SC_OvlOdklonenia.Step:= 10;
			ELSIF OdklonGriprov_ZAHODENIE THEN
				SC_OvlOdklonenia.Step:= 20;
			END_IF
		
		10:
			SC_OvlOdklonenia.StepName:= '10 - Odklopenie griprov do pozicie odoberania';
			SC_OvlOdklonenia.IdleTime.PT:= T#3s;
			SC_OvlOdklonenia.AlarmTime.PT:= T#7s;
		
			IF Strihanie_Manual THEN
				SC_OvlOdklonenia.IdleTime.IN:= TRUE;
			ELSE	
				SC_OvlOdklonenia.AlarmTime.IN:= TRUE;
			END_IF
		
			IF NOT SC_OvlOdklonenia.Switch1 THEN
				Vyrazanie.OUT.OdhadzovanieVysunut:= TRUE;
				SC_OvlOdklonenia.Switch1:= TRUE;
			END_IF
		
			IF SC_OvlOdklonenia.AlarmTime.Q THEN
				Alarmy[46]:= TRUE;
				PoruchaStanicaStrihania:= TRUE;
			END_IF
		
			IF (Vyrazanie.IN.OdhadzovanieJeVpredu AND Vyrazanie.IN.OdhadzovanieJeVpredu2) OR SC_OvlOdklonenia.IdleTime.Q THEN
				SC_OvlOdklonenia.ResetStep:= TRUE;
				SC_OvlOdklonenia.Step:= 0;
			END_IF
		
		20:
			SC_OvlOdklonenia.StepName:= '20 - Odklopenie griprov do pozicie zahodenia';
			SC_OvlOdklonenia.IdleTime.PT:= T#3s;
			SC_OvlOdklonenia.AlarmTime.PT:= T#7s;
		
			IF Strihanie_Manual THEN
				SC_OvlOdklonenia.IdleTime.IN:= TRUE;
			ELSE	
				SC_OvlOdklonenia.AlarmTime.IN:= TRUE;
			END_IF
		
			IF NOT SC_OvlOdklonenia.Switch1 THEN
				Vyrazanie.OUT.OdhadzovanieZasunut:= TRUE;
				SC_OvlOdklonenia.Switch1:= TRUE;
			END_IF
		
			
			IF SC_OvlOdklonenia.AlarmTime.Q THEN
				Alarmy[47]:= TRUE;
				PoruchaStanicaStrihania:= TRUE;
			END_IF
		
			IF Vyrazanie.IN.OdhadzovanieJeVzadu OR SC_OvlOdklonenia.IdleTime.Q THEN
				SC_OvlOdklonenia.ResetStep:= TRUE;
				SC_OvlOdklonenia.Step:= 0;
			END_IF
			
	
	
	END_CASE
	
	
END_ACTION
