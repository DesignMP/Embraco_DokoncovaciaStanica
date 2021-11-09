
ACTION OvladanieZdvihuServa: 

	//Prepoèet rýchlosti pojazdu manipulátora//
	KonstantaZdvihu_MM:= 10;  //10mm
	KonstantaZdvihu_Servo:= 1000; //poèet jednotiek za 10mm
	
	Valcovanie_Rychlost_MM_s:= TP_Valcovanie_RychlostZdvihu;
	Valcovanie_ServoRychlostPolohov:= (Valcovanie_Rychlost_MM_s / KonstantaZdvihu_MM) * KonstantaZdvihu_Servo;
	Valcovanie_ServoRychlJoggingu:= (Valcovanie_RychlostJog_MM_s / KonstantaZdvihu_MM) * KonstantaZdvihu_Servo;
	Valcovanie_AktualPozMM;
	
	
	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_OvlServoZdvihu);
	
	
	CASE SC_OvlServoZdvihu.Step OF
		
		0:
			SC_OvlServoZdvihu.StepName:= '0 - Nulovanie';
			ServoZdvih_JoggDOLE:= FALSE;
			ServoZdvih_JoggHORE:= FALSE;
			ServoZdvih_Polohuj:= FALSE;
			Valcovanie_ZdvihHOME:= FALSE;
			Motion[3].cmd.home:= FALSE;
			Motion[3].cmd.moveAbsolute:= FALSE;
			Motion[3].cmd.moveJogNeg:= FALSE;
			Motion[3].cmd.moveJogPos:= FALSE;
			Valcovanie_PrebiehaHoming:= FALSE;
			IF NOT SC_OvlServoZdvihu.Switch1 AND Motion[3].status.DriveStatus.HomingOk THEN
				Motion[3].cmd.halt:= TRUE;
				SC_OvlServoZdvihu.Switch1:= TRUE;
			END_IF
				
			IF SC_Valcovanie.Step <> 0 THEN
				SC_OvlServoZdvihu.ResetStep:= TRUE;
				SC_OvlServoZdvihu.Step:= 1;
			END_IF	
	
	
		1:
			SC_OvlServoZdvihu.StepName:= '1 - Rozhodnutie o cinnosti';
			IF ServoZdvih_JoggDOLE THEN
				SC_OvlServoZdvihu.Step:= 10;
			ELSIF ServoZdvih_JoggHORE THEN
				SC_OvlServoZdvihu.Step:= 20;
			ELSIF ServoZdvih_Polohuj THEN
				SC_OvlServoZdvihu.Step:= 30;
			ELSIF Valcovanie_ZdvihHOME THEN
				SC_OvlServoZdvihu.Step:= 40;
			END_IF
		
		
		10:
			SC_OvlServoZdvihu.StepName:= '10 - Jogging DOLE';
			SC_OvlServoZdvihu.IdleTime.PT:= T#3s;
			SC_OvlServoZdvihu.AlarmTime.PT:= T#3s;
			
			Motion[3].par.velocityJog:= Valcovanie_ServoRychlJoggingu;
			Motion[3].par.acc := (Valcovanie_ServoRychlJoggingu*10);
			Motion[3].par.dec := (Valcovanie_ServoRychlJoggingu*10);
			
		
			IF NOT SC_OvlServoZdvihu.Switch1 THEN
				Motion[3].cmd.moveJogPos:= TRUE;
				SC_OvlServoZdvihu.Switch1:= TRUE;
			END_IF
		
			IF NOT ServoZdvih_JoggDOLE OR diValcovanie_SpodnyLimitSnimac OR Valcovanie_AktualPozMM >= 200 THEN
				SC_OvlServoZdvihu.ResetStep:= TRUE;
				SC_OvlServoZdvihu.Step:= 0;
			END_IF
		
		
		
		20:
			SC_OvlServoZdvihu.StepName:= '20 - Jogging HORE';
			SC_OvlServoZdvihu.IdleTime.PT:= T#3s;
			SC_OvlServoZdvihu.AlarmTime.PT:= T#3s;
			
			Motion[3].par.velocityJog:= Valcovanie_ServoRychlJoggingu;
			Motion[3].par.acc := (Valcovanie_ServoRychlJoggingu*10);
			Motion[3].par.dec := (Valcovanie_ServoRychlJoggingu*10);
			
		
			IF NOT SC_OvlServoZdvihu.Switch1 THEN
				Motion[3].cmd.moveJogNeg:= TRUE;
				SC_OvlServoZdvihu.Switch1:= TRUE;
			END_IF
		
			IF NOT ServoZdvih_JoggHORE OR diValcovanie_HornyLimitSnimac OR Valcovanie_AktualPozMM < 5 THEN
				SC_OvlServoZdvihu.ResetStep:= TRUE;
				SC_OvlServoZdvihu.Step:= 0;
			END_IF
		
		
		30:
			SC_OvlServoZdvihu.StepName:= '30 - Start polohovanie zdvihu';
			SC_OvlServoZdvihu.IdleTime.PT:= T#3s;
			SC_OvlServoZdvihu.AlarmTime.PT:= T#3s;
		
			Motion[3].par.velocity:= Valcovanie_ServoRychlostPolohov;
			Motion[3].par.acc := (Valcovanie_ServoRychlostPolohov*20);
			Motion[3].par.dec := (Valcovanie_ServoRychlostPolohov*20);
			Motion[3].par.position:= (Valcovanie_ZadanaPozMM * 100);
		
			IF NOT SC_OvlServoZdvihu.Switch1 THEN
				Motion[3].cmd.moveAbsolute:= TRUE;
				SC_OvlServoZdvihu.Switch1:= TRUE;
			END_IF
		
				
			IF NOT Motion[3].state.StandStill THEN
				SC_OvlServoZdvihu.ResetStep:= TRUE;
				SC_OvlServoZdvihu.Step:= 31;
			ELSIF (Valcovanie_AktualPozMM = Valcovanie_ZadanaPozMM) THEN
				SC_OvlServoZdvihu.ResetStep:= TRUE;
				SC_OvlServoZdvihu.Step:= 31;
			END_IF
		
		31:
			
			SC_OvlServoZdvihu.StepName:= '31 - Ukoncenie polohovanie pojazdu';
			SC_OvlServoZdvihu.IdleTime.PT:= T#3s;
			SC_OvlServoZdvihu.AlarmTime.PT:= T#3s;
		
			
					
			IF Motion[3].status.ActTorque >= 5 THEN
				Motion[3].cmd.halt:= TRUE;
				Priznak_ValcovanieNG:= TRUE;
				SC_OvlServoZdvihu.ResetStep:= TRUE;
				SC_OvlServoZdvihu.Step:= 35;		
			ELSIF Motion[3].state.StandStill AND (Valcovanie_AktualPozMM = Valcovanie_ZadanaPozMM) THEN
				Valcovanie_ZdvihVPOZICI:= TRUE;
				SC_OvlServoZdvihu.ResetStep:= TRUE;
				SC_OvlServoZdvihu.Step:= 0;
			END_IF
		
			IF diValcovanie_HornyLimitSnimac OR diValcovanie_SpodnyLimitSnimac THEN
				Alarmy[67]:= TRUE;
				PoruchaStanicaValcovania:= TRUE;
			END_IF
		
		35:
			SC_OvlServoZdvihu.StepName:= '35 - Cakanie na zastavenie serva po dosiahnuti limitneho momentu';
			SC_OvlServoZdvihu.IdleTime.PT:= T#1s;
			SC_OvlServoZdvihu.AlarmTime.PT:= T#3s;	
		
			SC_OvlServoZdvihu.IdleTime.IN:= TRUE;
			
			IF SC_OvlServoZdvihu.IdleTime.Q AND Motion[3].state.StandStill THEN
				Motion[3].cmd.halt:= FALSE;
				Valcovanie_ZdvihVPOZICI:= TRUE;
				SC_OvlServoZdvihu.ResetStep:= TRUE;
				SC_OvlServoZdvihu.Step:= 0;
			END_IF
			
			
		40:
			SC_OvlServoZdvihu.StepName:= '40 - Start homingu';
			SC_OvlServoZdvihu.IdleTime.PT:= T#3s;
			SC_OvlServoZdvihu.AlarmTime.PT:= T#3s;
		
			IF NOT SC_OvlServoZdvihu.Switch1 THEN
				Motion[3].cmd.home:= TRUE;
				Valcovanie_PrebiehaHoming:= TRUE;
				SC_OvlServoZdvihu.Switch1:= TRUE;
			END_IF
		
			IF Motion[3].state.Homing THEN
				SC_OvlServoZdvihu.ResetStep:= TRUE;
				SC_OvlServoZdvihu.Step:= 41;
			END_IF
		
		41:
			SC_OvlServoZdvihu.StepName:= '41 - Ukoncenie homingu';
			SC_OvlServoZdvihu.IdleTime.PT:= T#3s;
			SC_OvlServoZdvihu.AlarmTime.PT:= T#3s;
		
			IF Motion[3].status.DriveStatus.HomingOk THEN
				SC_OvlServoZdvihu.ResetStep:= TRUE;
				SC_OvlServoZdvihu.Step:= 0;
			END_IF
		
		
		
	
	END_CASE
	
	
END_ACTION
