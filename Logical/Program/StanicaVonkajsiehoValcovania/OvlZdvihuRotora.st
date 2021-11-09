
ACTION OvlZdvihuRotora: 

	//Parametre zdvihu rotora//
	Valcovanie2_ServoJoggRychl_MM_s;
	Valcovanie2_ServoPracRychl1_MM_s; //R˝chlost priblÌûenia
	Valcovanie2_ServoPracRychl2_MM_s; //R˝chlosù valcovania
	Valcovanie2_FM_RozbehRampa_s;
	Valcovanie2_FM_DobehRampa_s;
	Valcovanie2_MomentPritlaku_Nm:= 3; //3Nm


	
	
	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_OvlZdvihuRotora);
	
	
	CASE SC_OvlZdvihuRotora.Step OF
		
		0:
			SC_OvlZdvihuRotora.StepName:= '0 - Nulovanie';
			ZdvihRotora_JoggDOLE:= FALSE;
			ZdvihRotora_JoggHORE:= FALSE;
			ZdvihRotora_HOME:= FALSE;
			ZdvihRotora_VALCOVANIE:= FALSE;
			ZdvihRotora_PoziciaSTART:= FALSE;
			ZdvihRotora_PoziciaVALCOVANIA:= FALSE;
			Motion[4].cmd.home:= FALSE;
			Motion[4].cmd.moveAbsolute:= FALSE;
			Motion[4].cmd.moveJogNeg:= FALSE;
			Motion[4].cmd.moveJogPos:= FALSE;
			Motion[4].cmd.moveVelocity:= FALSE;
			Valcovanie2_PrebiehaHoming:= FALSE;
			Motion[4].par.direction:= 0;
			
			IF SC_Valcovanie2.Step <> 0 AND (NOT Motion[4].status.DriveStatus.HomingOk OR Motion[4].state.StandStill) THEN
				Motion[4].cmd.halt:= FALSE;
				SC_OvlZdvihuRotora.ResetStep:= TRUE;
				SC_OvlZdvihuRotora.Step:= 1;
			END_IF	
	
	
		1:
			SC_OvlZdvihuRotora.StepName:= '1 - Rozhodnutie o cinnosti';
			IF ZdvihRotora_JoggDOLE THEN
				SC_OvlZdvihuRotora.Step:= 10;
			ELSIF ZdvihRotora_JoggHORE THEN
				SC_OvlZdvihuRotora.Step:= 20;
			ELSIF ZdvihRotora_HOME THEN
				SC_OvlZdvihuRotora.Step:= 30;
			ELSIF ZdvihRotora_VALCOVANIE THEN
				SC_OvlZdvihuRotora.Step:= 40;
			ELSIF ZdvihRotora_PoziciaSTART THEN
				SC_OvlZdvihuRotora.Step:= 50;
			ELSIF ZdvihRotora_PoziciaVALCOVANIA THEN
				SC_OvlZdvihuRotora.Step:= 60;	
			END_IF
	
		10:
			SC_OvlZdvihuRotora.StepName:= '10 - Jogging DOLE';
			SC_OvlZdvihuRotora.IdleTime.PT:= T#3s;
			SC_OvlZdvihuRotora.AlarmTime.PT:= T#3s;
			
			Motion[4].par.velocityJog:= (Valcovanie2_ServoJoggRychl_MM_s * 100);
			Motion[4].par.acc := (Valcovanie2_ServoJoggRychl_MM_s * 1000);
			Motion[4].par.dec := (Valcovanie2_ServoJoggRychl_MM_s * 1000);
	
			IF NOT SC_OvlZdvihuRotora.Switch1 THEN
				Motion[4].cmd.moveJogNeg:= TRUE;
				SC_OvlZdvihuRotora.Switch1:= TRUE;
			END_IF
		
			IF (NOT ZdvihRotora_JoggDOLE OR Valcovanie2_AktualPozMM <= 13)THEN
				Motion[4].cmd.moveJogNeg:= FALSE;
				SC_OvlZdvihuRotora.ResetStep:= TRUE;
				SC_OvlZdvihuRotora.Step:= 0;
			END_IF	
			
			IF diValc2_ZdvihSpodnyLimit THEN
				Motion[4].cmd.halt:= TRUE;
				Alarmy[56]:= TRUE;
				PoruchaStanicaValcovania2:= TRUE;
			END_IF
	
	
		20:
			SC_OvlZdvihuRotora.StepName:= '20 - Jogging HORE';
			SC_OvlZdvihuRotora.IdleTime.PT:= T#3s;
			SC_OvlZdvihuRotora.AlarmTime.PT:= T#3s;
			
			Motion[4].par.velocityJog:= (Valcovanie2_ServoJoggRychl_MM_s * 100);
			Motion[4].par.acc := (Valcovanie2_ServoJoggRychl_MM_s * 1000);
			Motion[4].par.dec := (Valcovanie2_ServoJoggRychl_MM_s * 1000);
	
			IF NOT SC_OvlZdvihuRotora.Switch1 THEN
				Motion[4].cmd.moveJogPos:= TRUE;
				SC_OvlZdvihuRotora.Switch1:= TRUE;
			END_IF
		
			IF (NOT ZdvihRotora_JoggHORE OR Valcovanie2_AktualPozMM >= 185)THEN
				Motion[4].cmd.moveJogPos:= FALSE;
				SC_OvlZdvihuRotora.ResetStep:= TRUE;
				SC_OvlZdvihuRotora.Step:= 0;
			END_IF	
			
			IF diValc2_ZdvihHornyLimit THEN
				Motion[4].cmd.halt:= TRUE;
				Alarmy[56]:= TRUE;
				PoruchaStanicaValcovania2:= TRUE;
			END_IF
		
		30:
			SC_OvlZdvihuRotora.StepName:= '30 - Start homingu';
			SC_OvlZdvihuRotora.IdleTime.PT:= T#500ms;
			SC_OvlZdvihuRotora.AlarmTime.PT:= T#3s;
				
				
			IF NOT SC_OvlZdvihuRotora.Switch1 THEN
				Motion[4].cmd.home:= TRUE;
				Valcovanie2_PrebiehaHoming:= TRUE;
				SC_OvlZdvihuRotora.IdleTime.IN:= TRUE;
				SC_OvlZdvihuRotora.Switch1:= TRUE;
			END_IF
		
			IF SC_OvlZdvihuRotora.IdleTime.Q THEN
				SC_OvlZdvihuRotora.ResetStep:= TRUE;
				SC_OvlZdvihuRotora.Step:= 31;
			END_IF
		
		31:
			SC_OvlZdvihuRotora.StepName:= '31 - Ukoncenie homingu';
			SC_OvlZdvihuRotora.IdleTime.PT:= T#3s;
			SC_OvlZdvihuRotora.AlarmTime.PT:= T#3s;
		
			IF Valcovanie2_HomingOK AND Motion[4].state.StandStill THEN
				SC_OvlZdvihuRotora.ResetStep:= TRUE;
				SC_OvlZdvihuRotora.Step:= 0;
			END_IF	
		
			
			
			
		40:
			SC_OvlZdvihuRotora.StepName:= '40 - Valcovanie,chod rychlo na spomalovaci snimac';
			SC_OvlZdvihuRotora.IdleTime.PT:= T#3s;
			SC_OvlZdvihuRotora.AlarmTime.PT:= T#3s;
			
			Motion[4].par.velocity:= (Valcovanie2_ServoPracRychl1_MM_s * 100);
			Motion[4].par.acc := (Valcovanie2_ServoPracRychl1_MM_s * 1000);
			Motion[4].par.dec := (Valcovanie2_ServoPracRychl1_MM_s * 1000);
			Motion[4].par.direction:= 0;
			
			
			IF NOT SC_OvlZdvihuRotora.Switch1 THEN
				Motion[4].cmd.moveVelocity:= TRUE;
				PocetCyklovValcovania:= PocetCyklovValcovania + 1;
				TaktTime.IN:= TRUE;
				SC_OvlZdvihuRotora.Switch1:= TRUE;
			END_IF
		
			IF EDGEPOS(diValc2_SpomalenieZdvihu) THEN
				SC_OvlZdvihuRotora.ResetStep:= TRUE;
				SC_OvlZdvihuRotora.Step:= 41;
			ELSIF Valcovanie2_AktualPozMM >= 118 THEN
				SC_OvlZdvihuRotora.ResetStep:= TRUE;
				SC_OvlZdvihuRotora.Step:= 41;
			ELSIF diValc2_ZdvihHornyLimit THEN
				Motion[4].cmd.halt:= TRUE;
				Alarmy[56]:= TRUE;
				PoruchaStanicaValcovania2:= TRUE;
			END_IF	
		
		41:
			SC_OvlZdvihuRotora.StepName:= '41 - Valcovanie,chod pomaly na poziciu';
			SC_OvlZdvihuRotora.IdleTime.PT:= T#1s;
			SC_OvlZdvihuRotora.AlarmTime.PT:= T#3s;
			
			
			
			Motion[4].par.velocity:= (Valcovanie2_ServoPracRychl2_MM_s * 100);
			Motion[4].par.acc := (Valcovanie2_ServoPracRychl2_MM_s * 1000);
			Motion[4].par.dec := (Valcovanie2_ServoPracRychl2_MM_s * 1000);
			Motion[4].par.position:= (Valcovanie2_ZadanaPozMM * 100); //180mm
			
						
			IF NOT SC_OvlZdvihuRotora.Switch1 THEN
				Motion[4].cmd.moveAbsolute:= TRUE;
				IF PocetCyklovValcovania >= Valcovanie2_PocetCyklStrekuOleja THEN
					Valcovanie2_DavkaOleja:= TRUE;
					PocetCyklovValcovania:= 0;
				END_IF	
				SC_OvlZdvihuRotora.Switch1:= TRUE;
			END_IF
		
					
			IF (Valcovanie2_AktualPozMM = Valcovanie2_ZadanaPozMM) AND Motion[4].state.StandStill THEN
				SC_OvlZdvihuRotora.ResetStep:= TRUE;
				SC_OvlZdvihuRotora.Step:= 45;
			ELSIF Motion[4].status.ActTorque >= 20 THEN
				Motion[4].cmd.halt:= TRUE;
				Priznak_ValcovanieNG:= TRUE;
				SC_OvlZdvihuRotora.ResetStep:= TRUE;
				SC_OvlZdvihuRotora.Step:= 42;
			ELSIF diValc2_ZdvihHornyLimit THEN
				Motion[4].cmd.halt:= TRUE;
				Alarmy[56]:= TRUE;
				PoruchaStanicaValcovania2:= TRUE;
			END_IF		
		
		42:
			SC_OvlZdvihuRotora.StepName:= '42 - Valcovanie,zastavenie po dosiahnutÌ momentu';
			SC_OvlZdvihuRotora.IdleTime.PT:= T#1s;
			SC_OvlZdvihuRotora.AlarmTime.PT:= T#3s;
			SC_OvlZdvihuRotora.IdleTime.IN:= TRUE;
			
			IF NOT Motion[4].cmd.halt THEN
				SC_OvlZdvihuRotora.ResetStep:= TRUE;
				SC_OvlZdvihuRotora.Step:= 45;
			END_IF	
			
			IF SC_OvlZdvihuRotora.IdleTime.Q THEN
				Motion[4].cmd.halt:= FALSE;
			END_IF
			
		45:
			SC_OvlZdvihuRotora.StepName:= '45 - Valcovanie,chod pomalou rychlostou dole';
			SC_OvlZdvihuRotora.IdleTime.PT:= T#50ms;
			SC_OvlZdvihuRotora.AlarmTime.PT:= T#3s;
			SC_OvlZdvihuRotora.IdleTime.IN:= TRUE;
			
					
			Motion[4].par.velocity:= (Valcovanie2_ServoPracRychl1_MM_s * 100);
			Motion[4].par.acc := (Valcovanie2_ServoPracRychl1_MM_s * 1000);
			Motion[4].par.dec := (Valcovanie2_ServoPracRychl1_MM_s * 1000);
			Motion[4].par.direction:= 1;
			
			
			IF NOT SC_OvlZdvihuRotora.Switch1 AND SC_OvlZdvihuRotora.IdleTime.Q THEN
				Motion[4].cmd.moveVelocity:= TRUE;
				SC_OvlZdvihuRotora.Switch1:= TRUE;
			END_IF
		
			IF NOT diValc2_SpomalenieZdvihu AND Valcovanie2_AktualPozMM < 118 THEN
				SC_OvlZdvihuRotora.ResetStep:= TRUE;
				SC_OvlZdvihuRotora.Step:= 46;
			ELSIF Valcovanie2_AktualPozMM <= 95 THEN
				SC_OvlZdvihuRotora.ResetStep:= TRUE;
				SC_OvlZdvihuRotora.Step:= 46;
			ELSIF diValc2_ZdvihSpodnyLimit THEN
				Motion[4].cmd.halt:= TRUE;
				Alarmy[56]:= TRUE;
				PoruchaStanicaValcovania2:= TRUE;
			END_IF	
		
		
		46:
			SC_OvlZdvihuRotora.StepName:= '46 - Valcovanie, chod rychlo do vychodiskovej pozicie';
			SC_OvlZdvihuRotora.IdleTime.PT:= T#3s;
			SC_OvlZdvihuRotora.AlarmTime.PT:= T#3s;
			
			Motion[4].par.velocity:= (Valcovanie2_ServoPracRychl1_MM_s * 100);
			Motion[4].par.acc := (Valcovanie2_ServoPracRychl1_MM_s * 1000);
			Motion[4].par.dec := (Valcovanie2_ServoPracRychl1_MM_s * 1000);
			Motion[4].par.position:= 1300; //13mm
		
		
			IF NOT SC_OvlZdvihuRotora.Switch1 THEN
				Motion[4].cmd.moveAbsolute:= TRUE;
				SC_OvlZdvihuRotora.Switch1:= TRUE;
			END_IF
		
			IF (Valcovanie2_AktualPozMM = 13) AND Motion[4].state.StandStill AND NOT Priznak_ValcovanieNG THEN
				Priznak_ValcovanieOK:= TRUE;
				NameranyTaktime:= TaktTime.ET;
				TaktTime.IN:= FALSE;
				SC_OvlZdvihuRotora.ResetStep:= TRUE;
				SC_OvlZdvihuRotora.Step:= 0;
			ELSIF diValc2_ZdvihSpodnyLimit THEN
				Motion[4].cmd.halt:= TRUE;
				Alarmy[56]:= TRUE;
				PoruchaStanicaValcovania2:= TRUE;
			END_IF		
			
			
			
			
			
			
			
		50:
			SC_OvlZdvihuRotora.StepName:= '50 - Presun do pozicie START';
			SC_OvlZdvihuRotora.IdleTime.PT:= T#3s;
			SC_OvlZdvihuRotora.AlarmTime.PT:= T#3s;
		
			Motion[4].par.velocity:= (Valcovanie2_ServoPracRychl1_MM_s * 100);
			Motion[4].par.acc := (Valcovanie2_ServoPracRychl1_MM_s * 1000);
			Motion[4].par.dec := (Valcovanie2_ServoPracRychl1_MM_s * 1000);
			Motion[4].par.position:= 1300; //13mm
		
		
			IF NOT SC_OvlZdvihuRotora.Switch1 THEN
				Motion[4].cmd.moveAbsolute:= TRUE;
				SC_OvlZdvihuRotora.Switch1:= TRUE;
			END_IF
		
			IF (Valcovanie2_AktualPozMM = 13) AND Motion[4].state.StandStill THEN
				Valcovanie2_ZdvihVPOZICI:= TRUE;
				SC_OvlZdvihuRotora.ResetStep:= TRUE;
				SC_OvlZdvihuRotora.Step:= 0;
			ELSIF diValc2_ZdvihSpodnyLimit THEN
				Motion[4].cmd.halt:= TRUE;
				Alarmy[56]:= TRUE;
				PoruchaStanicaValcovania2:= TRUE;
			END_IF	
		
		
		60:
			SC_OvlZdvihuRotora.StepName:= '60 - Presun do pozicie VALCOVANIA';
			SC_OvlZdvihuRotora.IdleTime.PT:= T#3s;
			SC_OvlZdvihuRotora.AlarmTime.PT:= T#3s;
		
		
			
			Motion[4].par.velocity:= (Valcovanie2_ServoPracRychl2_MM_s * 100);
			Motion[4].par.acc := (Valcovanie2_ServoPracRychl2_MM_s * 1000);
			Motion[4].par.dec := (Valcovanie2_ServoPracRychl2_MM_s * 1000);
			Motion[4].par.position:= (Valcovanie2_ZadanaPozMM * 100); //180mm
			
						
			IF NOT SC_OvlZdvihuRotora.Switch1 THEN
				Motion[4].cmd.moveAbsolute:= TRUE;
				SC_OvlZdvihuRotora.Switch1:= TRUE;
			END_IF
		
					
			IF (Valcovanie2_AktualPozMM = Valcovanie2_ZadanaPozMM) AND Motion[4].state.StandStill THEN
				Valcovanie2_ZdvihVPOZICI:= TRUE;
				SC_OvlZdvihuRotora.ResetStep:= TRUE;
				SC_OvlZdvihuRotora.Step:= 0;
			ELSIF Motion[4].status.ActTorque >= 5 THEN
				Motion[4].cmd.halt:= TRUE;
				SC_OvlZdvihuRotora.ResetStep:= TRUE;
				SC_OvlZdvihuRotora.Step:= 0;
			ELSIF diValc2_ZdvihHornyLimit THEN
				Motion[4].cmd.halt:= TRUE;
				Alarmy[56]:= TRUE;
				PoruchaStanicaValcovania2:= TRUE;
			END_IF		
		
			
		
	END_CASE
	
	TaktTime.PT:= T#20s;
	TaktTime();
	
	
END_ACTION
