
ACTION OvladanieZdvihu: 

	
	//Volanie funkcie SequenceControl//
	SequenceControl(SC:= SC_OvlZdvihu);
	
	CASE SC_OvlZdvihu.Step OF
		
		0:
			SC_OvlZdvihu.StepName:= '0 - Nulovanie';
			Rotor_ZDVIHNI:= FALSE;
			Rotor_POLOZ:= FALSE;
			Rotor_POLOZ_CasOFF:= FALSE;
			RR_Rotor_ZDVIHNI:= FALSE;
			doRazenie_ZdvihRotora:= FALSE;
			doRazenie_ZostupRotora:= FALSE;
			IF SC_Razenie.Step <> 0 THEN
				SC_OvlZdvihu.ResetStep:= TRUE;
				SC_OvlZdvihu.Step:= 1;
			END_IF
	
		1:
			SC_OvlZdvihu.StepName:= '1 - Rozhodnutie o cinnosti';
			IF Rotor_ZDVIHNI THEN
				SC_OvlZdvihu.Step:= 10;
			ELSIF Rotor_POLOZ THEN
				SC_OvlZdvihu.Step:= 20;
			ELSIF RR_Rotor_ZDVIHNI THEN
				SC_OvlZdvihu.Step:= 30;
			ELSIF Rotor_POLOZ_CasOFF THEN
				SC_OvlZdvihu.Step:= 40;	
			END_IF	
	
	
		10:
			SC_OvlZdvihu.StepName:= '10 - Zodvihnutie rotora';
			IF Razenie_Automat THEN
				SC_OvlZdvihu.IdleTime.PT:= T#500ms;
			ELSIF Razenie_Manual THEN	
				SC_OvlZdvihu.IdleTime.PT:= T#6s;
			END_IF	
			SC_OvlZdvihu.AlarmTime.PT:= T#6s;
		
			IF Razenie_Automat THEN
				SC_OvlZdvihu.AlarmTime.IN:= TRUE;
				IF diRazenie_ZdvihHornaPoloha THEN
					SC_OvlZdvihu.IdleTime.IN:= TRUE;
				END_IF
			ELSIF Razenie_Manual THEN
				SC_OvlZdvihu.IdleTime.IN:= TRUE;
			END_IF
		
			IF NOT SC_OvlZdvihu.Switch1 THEN
				doRazenie_ZostupRotora:= FALSE;
				doRazenie_ZdvihRotora:= TRUE;
				SC_OvlZdvihu.Switch1:= TRUE;
			END_IF
		
			IF SC_OvlZdvihu.AlarmTime.Q THEN
				Alarmy[50]:= TRUE;
				PoruchaStanicaRazenia:= TRUE;
			END_IF
		
			
			IF SC_OvlZdvihu.IdleTime.Q THEN
				Zdvih_Napolohovany:= TRUE;
				SC_OvlZdvihu.ResetStep:= TRUE;
				SC_OvlZdvihu.Step:= 0;
			END_IF	
			
		20:
			SC_OvlZdvihu.StepName:= '20 - Polozenie rotora';
			SC_OvlZdvihu.IdleTime.PT:= T#6s;
			SC_OvlZdvihu.AlarmTime.PT:= T#6s;
		
			IF Razenie_Manual THEN
				SC_OvlZdvihu.IdleTime.IN:= TRUE;
			ELSE	
				SC_OvlZdvihu.AlarmTime.IN:= TRUE;
			END_IF
		
			IF NOT SC_OvlZdvihu.Switch1 THEN
				doRazenie_ZdvihRotora:= FALSE;
				doRazenie_ZostupRotora:= TRUE;
				SC_OvlZdvihu.Switch1:= TRUE;
			END_IF
		
			IF SC_OvlZdvihu.AlarmTime.Q THEN
				Alarmy[51]:= TRUE;
				PoruchaStanicaRazenia:= TRUE;
			END_IF
		
			IF diRazenie_ZdvihSpodnaPoloha OR SC_OvlZdvihu.IdleTime.Q THEN
				SC_OvlZdvihu.ResetStep:= TRUE;
				SC_OvlZdvihu.Step:= 0;
			END_IF	
			
		30:
			SC_OvlZdvihu.StepName:= '30 - Zodvihnutie rotora v rucnom rezime';
			SC_OvlZdvihu.IdleTime.PT:= T#6s;
			SC_OvlZdvihu.AlarmTime.PT:= T#6s;
		
					
			IF NOT SC_OvlZdvihu.Switch1 THEN
				doRazenie_ZostupRotora:= FALSE;
				doRazenie_ZdvihRotora:= TRUE;
				SC_OvlZdvihu.Switch1:= TRUE;
			END_IF
		
					
			IF diRazenie_ZdvihHornaPoloha OR NOT RR_Rotor_ZDVIHNI THEN
				doRazenie_ZostupRotora:= FALSE;
				doRazenie_ZdvihRotora:= FALSE;
				SC_OvlZdvihu.ResetStep:= TRUE;
				SC_OvlZdvihu.Step:= 0;
			END_IF
		
		40:
			SC_OvlZdvihu.StepName:= '40 - Polozenie rotora';
			SC_OvlZdvihu.IdleTime.PT:= T#3s;
			SC_OvlZdvihu.AlarmTime.PT:= T#6s;
			SC_OvlZdvihu.IdleTime.IN:= TRUE;
					
			IF NOT SC_OvlZdvihu.Switch1 THEN
				doRazenie_ZdvihRotora:= FALSE;
				doRazenie_ZostupRotora:= TRUE;
				SC_OvlZdvihu.Switch1:= TRUE;
			END_IF
		
					
			IF SC_OvlZdvihu.IdleTime.Q THEN
				SC_OvlZdvihu.ResetStep:= TRUE;
				SC_OvlZdvihu.Step:= 0;
			END_IF	
		
		
		
		
	END_CASE		
	
END_ACTION
