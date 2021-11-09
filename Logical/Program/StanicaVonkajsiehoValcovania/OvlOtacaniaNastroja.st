
ACTION OvlOtacaniaNastroja: 

	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_OvlOtacaniaNastroja);
	
	
	
	CASE SC_OvlOtacaniaNastroja.Step OF
		
		0:
			SC_OvlOtacaniaNastroja.StepName:= '0 - Nulovanie';
			FM_Menic[3].Input.Command.RunForward:= FALSE;
			FM_Menic[3].Input.Command.RunBackward:= FALSE;
			OtacanieNastroja_VPRED:= FALSE;
			OtacanieNastroja_VZAD:= FALSE;
			TP_Valcovanie2_ZamkniOtacVPRED:= FALSE;
			TP_Valcovanie2_ZamkniOtacVZAD:= FALSE;
			IF SC_Valcovanie2.Step <> 0 THEN
				SC_OvlOtacaniaNastroja.ResetStep:= TRUE;
				SC_OvlOtacaniaNastroja.Step:= 1;
			END_IF
	
	
		1:
			SC_OvlOtacaniaNastroja.StepName:= '1 - Rozhodnutie o cinnosti';
			IF OtacanieNastroja_VPRED THEN
				SC_OvlOtacaniaNastroja.Step:= 10;
			ELSIF OtacanieNastroja_VZAD THEN
				SC_OvlOtacaniaNastroja.Step:= 20;
			END_IF
	
		10:
			SC_OvlOtacaniaNastroja.StepName:= '10 - Otacanie nastroja VPRED';
			SC_OvlOtacaniaNastroja.IdleTime.PT:= T#5s;
			SC_OvlOtacaniaNastroja.AlarmTime.PT:= T#3s;
			FM_Menic[3].Input.HighSpeed:= REAL_TO_INT(Valcovanie2_FM_RychlostOtac_Hz * 10); //v Hz
			FM_Menic[3].Input.AccTime:=  REAL_TO_UINT(Valcovanie2_FM_RozbehRampa_s * 10);  //4s
			FM_Menic[3].Input.DecTime:= REAL_TO_UINT(Valcovanie2_FM_DobehRampa_s * 10);  //4s
		    
		
	
			IF NOT SC_OvlOtacaniaNastroja.Switch1 THEN
				FM_Menic[3].Input.Command.RunForward:= TRUE;
				TP_Valcovanie2_ZamkniOtacVZAD:= TRUE;
				SC_OvlOtacaniaNastroja.Switch1:= TRUE;
			END_IF
		
			IF NOT OtacanieNastroja_VPRED THEN
				FM_Menic[3].Input.Command.RunForward:= FALSE;
			END_IF	
		
			IF NOT OtacanieNastroja_VPRED AND NOT FM_Menic[3].Output.Status.Running THEN
				SC_OvlOtacaniaNastroja.ResetStep:= TRUE;
				SC_OvlOtacaniaNastroja.Step:= 0;
			END_IF	
			
		
			
			
			
			
		20:
			SC_OvlOtacaniaNastroja.StepName:= '20 - Otacanie nastroja VZAD';
			SC_OvlOtacaniaNastroja.IdleTime.PT:= T#5s;
			SC_OvlOtacaniaNastroja.AlarmTime.PT:= T#3s;
			FM_Menic[3].Input.HighSpeed:= REAL_TO_INT(Valcovanie2_FM_RychlostOtac_Hz * 10); //v Hz
			FM_Menic[3].Input.AccTime:=  REAL_TO_UINT(Valcovanie2_FM_RozbehRampa_s * 10);  //4s
			FM_Menic[3].Input.DecTime:= REAL_TO_UINT(Valcovanie2_FM_DobehRampa_s * 10);  //4s
		    
	
		
			IF NOT SC_OvlOtacaniaNastroja.Switch1 THEN
				FM_Menic[3].Input.Command.RunBackward:= TRUE;
				TP_Valcovanie2_ZamkniOtacVPRED:= TRUE;
				SC_OvlOtacaniaNastroja.Switch1:= TRUE;
			END_IF
		
			IF NOT OtacanieNastroja_VZAD THEN
				FM_Menic[3].Input.Command.RunBackward:= FALSE;
			END_IF	
		
			IF NOT OtacanieNastroja_VZAD AND NOT FM_Menic[3].Output.Status.Running THEN
				SC_OvlOtacaniaNastroja.ResetStep:= TRUE;
				SC_OvlOtacaniaNastroja.Step:= 0;
			END_IF	
		
			
		
		
		
	
	END_CASE
	
			END_ACTION
