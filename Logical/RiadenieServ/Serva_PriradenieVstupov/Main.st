
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	
	
	//Pojazd vstupného manipulátora//
	Servo1_PriradenieSnimacov.Axis:= ADR(gAxis01);
	Servo1_PriradenieSnimacov.Enable:= TRUE;
	Servo1_PriradenieSnimacov.PosHWSwitch:= diVstupManipul_PrednyLimitSnimac;
	Servo1_PriradenieSnimacov.NegHWSwitch:= diVstupManipul_ZadnyLimitSnimac;
	Servo1_PriradenieSnimacov();
	
	//Pojazd výstupného manipulátora//
	Servo2_PriradenieSnimacov.Axis:= ADR(gAxis02);
	Servo2_PriradenieSnimacov.Enable:= TRUE;
	Servo2_PriradenieSnimacov.PosHWSwitch:= diVystupManipul_PrednyLimSnimac;
	Servo2_PriradenieSnimacov.NegHWSwitch:= diVystupManipul_ZadnyLimSnimac;
	Servo2_PriradenieSnimacov();

	//Zdvih valcovaèky - stanica valcovania 1//
	Servo3_PriradenieSnimacov.Axis:= ADR(gAxis03);
	Servo3_PriradenieSnimacov.Enable:= TRUE;
	Servo3_PriradenieSnimacov.PosHWSwitch:= diValcovanie_SpodnyLimitSnimac;
	Servo3_PriradenieSnimacov.NegHWSwitch:= diValcovanie_HornyLimitSnimac;
	Servo3_PriradenieSnimacov();
	
	//Zdvih rotora - stanica valcovania 2//
	Servo4_PriradenieSnimacov.Axis:= ADR(gAxis04);
	Servo4_PriradenieSnimacov.Enable:= TRUE;
	Servo4_PriradenieSnimacov.PosHWSwitch:= diValc2_ZdvihHornyLimit;
	Servo4_PriradenieSnimacov.NegHWSwitch:= diValc2_ZdvihSpodnyLimit;
	Servo4_PriradenieSnimacov();	
	
	
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

