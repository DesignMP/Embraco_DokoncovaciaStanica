
ACTION OvladaniePojazdu: 

	//Prepoèet rýchlosti pojazdu manipulátora//
	KonstantaPojazd_MM:= 8;  //8mm
	KonstantaPojazd_Servo:= 800; //poèet jednotiek za 8mm
	
	
	VstupManipul_Rychlost_MM_s:= TP_VstupManip_RychlostPojazdu;
	VstupManipulator_RychlostPolohov:= (VstupManipul_Rychlost_MM_s / KonstantaPojazd_MM) * KonstantaPojazd_Servo;
	VstupManipulator_RychlJoggingu:= (VstupManipul_RychlostJog_MM_s / KonstantaPojazd_MM) * KonstantaPojazd_Servo;
	VstupManipulator_AktualPozMM;
	
	
	
	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_OvlServoPojazdu);
	
	
	CASE SC_OvlServoPojazdu.Step OF
		
		0:
			SC_OvlServoPojazdu.StepName:= '0 - Nulovanie';
			ServoPojazd_JoggVPRED:= FALSE;
			ServoPojazd_JoggVZAD:= FALSE;
			ServoPojazd_Polohuj:= FALSE;
			VstupManipulator_PojazdHOME:= FALSE;
			Motion[1].cmd.home:= FALSE;
			Motion[1].cmd.moveAbsolute:= FALSE;
			Motion[1].cmd.moveJogNeg:= FALSE;
			Motion[1].cmd.moveJogPos:= FALSE;
			VstupManipulator_PrebiehaHoming:= FALSE;
			IF NOT SC_OvlServoPojazdu.Switch1 AND Motion[1].status.DriveStatus.HomingOk THEN
				Motion[1].cmd.halt:= TRUE;
				SC_OvlServoPojazdu.Switch1:= TRUE;
			END_IF
			IF SC_VstupnyManipulator.Step <> 0 THEN
				SC_OvlServoPojazdu.ResetStep:= TRUE;
				SC_OvlServoPojazdu.Step:= 1;
			END_IF	
	
	
		1:
			SC_OvlServoPojazdu.StepName:= '1 - Rozhodnutie o cinnosti';
			IF ServoPojazd_JoggVPRED THEN
				SC_OvlServoPojazdu.Step:= 10;
			ELSIF ServoPojazd_JoggVZAD THEN
				SC_OvlServoPojazdu.Step:= 20;
			ELSIF ServoPojazd_Polohuj THEN
				SC_OvlServoPojazdu.Step:= 30;
			ELSIF VstupManipulator_PojazdHOME THEN
				SC_OvlServoPojazdu.Step:= 40;
			END_IF
		
		
		10:
			SC_OvlServoPojazdu.StepName:= '10 - Jogging VPRED';
			SC_OvlServoPojazdu.IdleTime.PT:= T#3s;
			SC_OvlServoPojazdu.AlarmTime.PT:= T#3s;
			
			Motion[1].par.velocityJog:= VstupManipulator_RychlJoggingu;
			Motion[1].par.acc := (VstupManipulator_RychlJoggingu*10);
			Motion[1].par.dec := (VstupManipulator_RychlJoggingu*10);
			
		
			IF NOT SC_OvlServoPojazdu.Switch1 THEN
				Motion[1].cmd.moveJogPos:= TRUE;
				SC_OvlServoPojazdu.Switch1:= TRUE;
			END_IF
		
			IF NOT ServoPojazd_JoggVPRED OR diVstupManipul_PrednyLimitSnimac OR VstupManipulator_AktualPozMM >= 610 OR NOT diVstupManipul_ZasunutyHore THEN
				SC_OvlServoPojazdu.ResetStep:= TRUE;
				SC_OvlServoPojazdu.Step:= 0;
			END_IF
		
		
		20:
			SC_OvlServoPojazdu.StepName:= '10 - Jogging VZAD';
			SC_OvlServoPojazdu.IdleTime.PT:= T#3s;
			SC_OvlServoPojazdu.AlarmTime.PT:= T#3s;
			
			
			Motion[1].par.velocityJog:= VstupManipulator_RychlJoggingu;
			Motion[1].par.acc := (VstupManipulator_RychlJoggingu*10);
			Motion[1].par.dec := (VstupManipulator_RychlJoggingu*10);
		
	
			IF NOT SC_OvlServoPojazdu.Switch1 THEN
				Motion[1].cmd.moveJogNeg:= TRUE;
				SC_OvlServoPojazdu.Switch1:= TRUE;
			END_IF
		
			IF NOT ServoPojazd_JoggVZAD OR diVstupManipul_ZadnyLimitSnimac OR VstupManipulator_AktualPozMM < 0 OR NOT diVstupManipul_ZasunutyHore THEN
				SC_OvlServoPojazdu.ResetStep:= TRUE;
				SC_OvlServoPojazdu.Step:= 0;
			END_IF
		
			
		30:
			SC_OvlServoPojazdu.StepName:= '30 - Start polohovanie pojazdu';
			SC_OvlServoPojazdu.IdleTime.PT:= T#100ms;
			SC_OvlServoPojazdu.AlarmTime.PT:= T#3s;
			SC_OvlServoPojazdu.IdleTime.IN:= TRUE;
		
			Motion[1].par.velocity:= VstupManipulator_RychlostPolohov;
			Motion[1].par.acc := (VstupManipulator_RychlostPolohov*10);
			Motion[1].par.dec := (VstupManipulator_RychlostPolohov*10);
			Motion[1].par.position:= (VstupManipulator_ZadanaPozMM * 100);
		
			IF NOT SC_OvlServoPojazdu.Switch1 AND SC_OvlServoPojazdu.IdleTime.Q THEN
				Motion[1].cmd.moveAbsolute:= TRUE;
				SC_OvlServoPojazdu.Switch1:= TRUE;
			END_IF
		
			IF NOT Motion[1].state.StandStill THEN
				SC_OvlServoPojazdu.ResetStep:= TRUE;
				SC_OvlServoPojazdu.Step:= 31;
			ELSIF (VstupManipulator_AktualPozMM = VstupManipulator_ZadanaPozMM) THEN
				SC_OvlServoPojazdu.ResetStep:= TRUE;
				SC_OvlServoPojazdu.Step:= 31;
			END_IF
		
		31:
			
			SC_OvlServoPojazdu.StepName:= '31 - Ukoncenie polohovanie pojazdu';
			SC_OvlServoPojazdu.IdleTime.PT:= T#3s;
			SC_OvlServoPojazdu.AlarmTime.PT:= T#3s;
		
			IF Motion[1].state.StandStill AND (VstupManipulator_AktualPozMM = VstupManipulator_ZadanaPozMM) THEN
				VstupManipulator_PojazdVPOZICI:= TRUE;
				SC_OvlServoPojazdu.ResetStep:= TRUE;
				SC_OvlServoPojazdu.Step:= 0;
			END_IF
		
			IF diVstupManipul_PrednyLimitSnimac OR diVstupManipul_ZadnyLimitSnimac THEN
				Alarmy[26]:= TRUE;
				PoruchaVstupManipulator:= TRUE;
			END_IF
		
	
		40:
			SC_OvlServoPojazdu.StepName:= '40 - Homing,zdvihnutie gripra';
			SC_OvlServoPojazdu.IdleTime.PT:= T#3s;
			SC_OvlServoPojazdu.AlarmTime.PT:= T#3s;
	
			
			
			IF NOT SC_OvlServoPojazdu.Switch1 THEN
				VstupManipulator_PrebiehaHoming:= TRUE;
				Zdvih_Manipulatora:= TRUE;	
				SC_OvlServoPojazdu.Switch1:= TRUE;
			END_IF
		
			IF diVstupManipul_ZasunutyHore THEN
				SC_OvlServoPojazdu.ResetStep:= TRUE;
				SC_OvlServoPojazdu.Step:= 41;
			END_IF
		
		
	
		41:
			SC_OvlServoPojazdu.StepName:= '41 - Homing,spustenie';
			SC_OvlServoPojazdu.IdleTime.PT:= T#3s;
			SC_OvlServoPojazdu.AlarmTime.PT:= T#3s;
		
			IF NOT SC_OvlServoPojazdu.Switch1 THEN
				Motion[1].cmd.home:= TRUE;
				SC_OvlServoPojazdu.Switch1:= TRUE;
			END_IF
		
			IF Motion[1].state.Homing THEN
				SC_OvlServoPojazdu.ResetStep:= TRUE;
				SC_OvlServoPojazdu.Step:= 42;
			END_IF
		
		42:
			SC_OvlServoPojazdu.StepName:= '42 - Homing,ukoncenie';
			SC_OvlServoPojazdu.IdleTime.PT:= T#3s;
			SC_OvlServoPojazdu.AlarmTime.PT:= T#3s;
		
			IF Motion[1].status.DriveStatus.HomingOk AND Motion[1].state.StandStill THEN
				SC_OvlServoPojazdu.ResetStep:= TRUE;
				SC_OvlServoPojazdu.Step:= 0;
			END_IF
			
		
		
		
		
	
	END_CASE
	
END_ACTION
