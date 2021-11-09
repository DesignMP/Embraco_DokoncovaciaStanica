
ACTION OvladaniePojazdu: 

	//Prepoèet rýchlosti pojazdu manipulátora//
	KonstantaPojazd_MM:= 8;  //8mm
	KonstantaPojazd_Servo:= 800; //poèet jednotiek za 8mm
	
	VystupManipul_Rychlost_MM_s:= TP_VystupManip_RychlostPojazdu;
	VystupManipulator_RychlostPoloho:= (VystupManipul_Rychlost_MM_s / KonstantaPojazd_MM) * KonstantaPojazd_Servo;
	VystupManipulator_RychlJoggingu:= (VystupManipul_RychlostJog_MM_s / KonstantaPojazd_MM) * KonstantaPojazd_Servo;
	VystupManipulator_AktualPozMM;
	
	
	
	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_OvlServoPojazdu);
	
	
	CASE SC_OvlServoPojazdu.Step OF
		
		0:
			SC_OvlServoPojazdu.StepName:= '0 - Nulovanie';
			ServoPojazd_JoggVPRED:= FALSE;
			ServoPojazd_JoggVZAD:= FALSE;
			ServoPojazd_Polohuj:= FALSE;
			VystupManipulator_PojazdHOME:= FALSE;
			Motion[2].cmd.home:= FALSE;
			Motion[2].cmd.moveAbsolute:= FALSE;
			Motion[2].cmd.moveJogNeg:= FALSE;
			Motion[2].cmd.moveJogPos:= FALSE;
			VystupManipulator_PrebiehaHoming:= FALSE;
			IF NOT SC_OvlServoPojazdu.Switch1 AND Motion[2].status.DriveStatus.HomingOk THEN
				Motion[2].cmd.halt:= TRUE;
				SC_OvlServoPojazdu.Switch1:= TRUE;
			END_IF
			IF SC_VystupnyManipulator.Step <> 0 THEN
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
			ELSIF VystupManipulator_PojazdHOME THEN
				SC_OvlServoPojazdu.Step:= 40;
			END_IF
		
		
		10:
			SC_OvlServoPojazdu.StepName:= '10 - Jogging VPRED';
			SC_OvlServoPojazdu.IdleTime.PT:= T#3s;
			SC_OvlServoPojazdu.AlarmTime.PT:= T#3s;
			
			Motion[2].par.velocityJog:= VystupManipulator_RychlJoggingu;
			Motion[2].par.acc := (VystupManipulator_RychlJoggingu*10);
			Motion[2].par.dec := (VystupManipulator_RychlJoggingu*10);
			
		
			IF NOT SC_OvlServoPojazdu.Switch1 THEN
				Motion[2].cmd.moveJogPos:= TRUE;
				SC_OvlServoPojazdu.Switch1:= TRUE;
			END_IF
		
			IF NOT ServoPojazd_JoggVPRED OR diVystupManipul_PrednyLimSnimac OR VystupManipulator_AktualPozMM >= 360 OR NOT diVystupManipul_ZasunutyHore THEN
				SC_OvlServoPojazdu.ResetStep:= TRUE;
				SC_OvlServoPojazdu.Step:= 0;
			END_IF
		
		
		20:
			SC_OvlServoPojazdu.StepName:= '10 - Jogging VZAD';
			SC_OvlServoPojazdu.IdleTime.PT:= T#3s;
			SC_OvlServoPojazdu.AlarmTime.PT:= T#3s;
			
			Motion[2].par.velocityJog:= VystupManipulator_RychlJoggingu;
			Motion[2].par.acc := (VystupManipulator_RychlJoggingu*10);
			Motion[2].par.dec := (VystupManipulator_RychlJoggingu*10);
		
	
			IF NOT SC_OvlServoPojazdu.Switch1 THEN
				Motion[2].cmd.moveJogNeg:= TRUE;
				SC_OvlServoPojazdu.Switch1:= TRUE;
			END_IF
		
			IF NOT ServoPojazd_JoggVZAD OR diVystupManipul_ZadnyLimSnimac OR VystupManipulator_AktualPozMM <= 0 OR NOT diVystupManipul_ZasunutyHore THEN
				SC_OvlServoPojazdu.ResetStep:= TRUE;
				SC_OvlServoPojazdu.Step:= 0;
			END_IF
		
		
		30:
			SC_OvlServoPojazdu.StepName:= '30 - Start polohovanie pojazdu';
			SC_OvlServoPojazdu.IdleTime.PT:= T#3s;
			SC_OvlServoPojazdu.AlarmTime.PT:= T#3s;
		
			Motion[2].par.velocity:= VystupManipulator_RychlostPoloho;
			Motion[2].par.acc := (VystupManipulator_RychlostPoloho*10);
			Motion[2].par.dec := (VystupManipulator_RychlostPoloho*10);
			Motion[2].par.position:= (VystupManipulator_ZadanaPozMM * 100);
		
			IF NOT SC_OvlServoPojazdu.Switch1 THEN
				Motion[2].cmd.moveAbsolute:= TRUE;
				SC_OvlServoPojazdu.Switch1:= TRUE;
			END_IF
		
			IF NOT Motion[2].state.StandStill THEN 
				SC_OvlServoPojazdu.ResetStep:= TRUE;
				SC_OvlServoPojazdu.Step:= 31;
			ELSIF (VystupManipulator_AktualPozMM = VystupManipulator_ZadanaPozMM) THEN
				SC_OvlServoPojazdu.ResetStep:= TRUE;
				SC_OvlServoPojazdu.Step:= 31;
			END_IF
		
		31:
			
			SC_OvlServoPojazdu.StepName:= '31 - Ukoncenie polohovanie pojazdu';
			SC_OvlServoPojazdu.IdleTime.PT:= T#3s;
			SC_OvlServoPojazdu.AlarmTime.PT:= T#3s;
		
			IF Motion[2].state.StandStill (*AND (VystupManipulator_AktualPozMM = VystupManipulator_ZadanaPozMM)*) THEN
				VystupManipulator_PojazdVPOZICI:= TRUE;
				SC_OvlServoPojazdu.ResetStep:= TRUE;
				SC_OvlServoPojazdu.Step:= 0;
			END_IF
		
			IF diVystupManipul_PrednyLimSnimac OR diVystupManipul_ZadnyLimSnimac THEN
				Alarmy[86]:= TRUE;
				PoruchaVystupManipulator:= TRUE;
			END_IF
	
		
		40:
			SC_OvlServoPojazdu.StepName:= '40 - Homing,zdvihnutie gripra';
			SC_OvlServoPojazdu.IdleTime.PT:= T#3s;
			SC_OvlServoPojazdu.AlarmTime.PT:= T#3s;
		
			IF NOT SC_OvlServoPojazdu.Switch1 THEN
				Zdvih_Manipulatora:= TRUE;
				SC_OvlServoPojazdu.Switch1:= TRUE;
			END_IF
		
			IF diVystupManipul_ZasunutyHore THEN
				SC_OvlServoPojazdu.ResetStep:= TRUE;
				SC_OvlServoPojazdu.Step:= 41;
			END_IF
		
		
		
		
		41:
			SC_OvlServoPojazdu.StepName:= '41 - Homing,spustenie';
			SC_OvlServoPojazdu.IdleTime.PT:= T#3s;
			SC_OvlServoPojazdu.AlarmTime.PT:= T#3s;
		
			IF NOT SC_OvlServoPojazdu.Switch1 THEN
				Motion[2].cmd.home:= TRUE;
				VystupManipulator_PrebiehaHoming:= TRUE;
				SC_OvlServoPojazdu.Switch1:= TRUE;
			END_IF
		
			IF Motion[2].state.Homing THEN
				SC_OvlServoPojazdu.ResetStep:= TRUE;
				SC_OvlServoPojazdu.Step:= 42;
			END_IF
		
		42:
			SC_OvlServoPojazdu.StepName:= '42 - Homing,ukoncenie';
			SC_OvlServoPojazdu.IdleTime.PT:= T#3s;
			SC_OvlServoPojazdu.AlarmTime.PT:= T#3s;
		
			IF Motion[2].status.DriveStatus.HomingOk THEN
				SC_OvlServoPojazdu.ResetStep:= TRUE;
				SC_OvlServoPojazdu.Step:= 0;
			END_IF
			
		
		
		
		
	
	END_CASE
	
	
	
	
END_ACTION
