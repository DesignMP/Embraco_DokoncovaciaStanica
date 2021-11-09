
ACTION OvladanieOtacaniaRotora: 
	
	//Zadanie rýchlosti otáèania rotora//
	Valcovanie_FM_RychlostOtac_Hz:= TP_Valcovanie_RychlostOtacania;
	
	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_OvlOtacania);
	
	
	CASE SC_OvlOtacania.Step OF
		
		0:
			SC_OvlOtacania.StepName:= '0 - Nulovanie';
			FM_Menic[2].Input.Command.RunForward:= FALSE;
			FM_Menic[2].Input.Command.RunBackward:= FALSE;
			RotorOtacaj_VPRED:= FALSE;
			RotorOtacaj_VZAD:= FALSE;
			IF SC_Valcovanie.Step <> 0 THEN
				SC_OvlOtacania.ResetStep:= TRUE;
				SC_OvlOtacania.Step:= 1;
			END_IF
	
	
		1:
			SC_OvlOtacania.StepName:= '1 - Rozhodnutie o cinnosti';
			IF RotorOtacaj_VPRED THEN
				SC_OvlOtacania.Step:= 10;
			ELSIF RotorOtacaj_VZAD THEN
				SC_OvlOtacania.Step:= 20;
			END_IF
		
		10:
			SC_OvlOtacania.StepName:= '10 - Otacanie rotora VPRED';
			SC_OvlOtacania.IdleTime.PT:= T#5s;
			SC_OvlOtacania.AlarmTime.PT:= T#15s;
			FM_Menic[2].Input.HighSpeed:= (Valcovanie_FM_RychlostOtac_Hz * 10); //v Hz
			FM_Menic[2].Input.AccTime:= 1;  //0.1s
			FM_Menic[2].Input.DecTime:= 1;  //0.1s
			RotorOtacaj_VZAD:= FALSE;
			
			IF NOT SC_OvlOtacania.Switch1 THEN
				FM_Menic[2].Input.Command.RunForward:= TRUE;
				SC_OvlOtacania.Switch1:= TRUE;
			END_IF
		
			IF NOT RotorOtacaj_VPRED THEN
				SC_OvlOtacania.ResetStep:= TRUE;
				SC_OvlOtacania.Step:= 0;
			END_IF	
		
		
		20:
			SC_OvlOtacania.StepName:= '20 - Otacanie rotora VZAD';
			SC_OvlOtacania.IdleTime.PT:= T#5s;
			SC_OvlOtacania.AlarmTime.PT:= T#15s;
			FM_Menic[2].Input.HighSpeed:= (Valcovanie_FM_RychlostOtac_Hz * 10); //v Hz
			FM_Menic[2].Input.AccTime:= 1;  //0.1s
			FM_Menic[2].Input.DecTime:= 1;  //0.1s
			RotorOtacaj_VPRED:= FALSE;
			
			IF NOT SC_OvlOtacania.Switch1 THEN
				FM_Menic[2].Input.Command.RunBackward:= TRUE;
				SC_OvlOtacania.Switch1:= TRUE;
			END_IF
		
			IF NOT RotorOtacaj_VZAD THEN
				SC_OvlOtacania.ResetStep:= TRUE;
				SC_OvlOtacania.Step:= 0;
			END_IF	
		
	
	
	END_CASE
	
	
	
END_ACTION
