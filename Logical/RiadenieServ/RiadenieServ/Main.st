
PROGRAM _INIT
	Motion[1].par.axis:= ADR(gAxis01);  //Vstupny manipulator//
	Motion[2].par.axis:= ADR(gAxis02);  //Vystupny manipulator//
	Motion[3].par.axis:= ADR(gAxis03);  //Zdvih valcovacky - stanica valcovania 1//
	Motion[4].par.axis:= ADR(gAxis04);  //Zdvih rotora - stanica valcovania 2//
	
END_PROGRAM

PROGRAM _CYCLIC
	
	FOR idx:=1 TO MAX_MOTION DO 
		Motion[idx].enable := TRUE;
		Motion[idx];
	END_FOR
	
	IF BezpOkruhCS_Aktivovany THEN
		Motion[1].cmd.power:= TRUE;
		Motion[2].cmd.power:= TRUE;
		Motion[3].cmd.power:= TRUE;
		Motion[4].cmd.power:= TRUE;
	ELSE
		Motion[1].cmd.power:= FALSE;
		Motion[2].cmd.power:= FALSE;
		Motion[3].cmd.power:= FALSE;
		Motion[4].cmd.power:= FALSE;
	END_IF	
	 
	IF EDGEPOS (BezpOkruhOplotenia_Aktivovany = TRUE) THEN
		Motion[1].cmd.autoInicialization:= TRUE;
		Motion[2].cmd.autoInicialization:= TRUE;
		Motion[3].cmd.autoInicialization:= TRUE;
		Motion[4].cmd.autoInicialization:= TRUE;
		CasVypnutiaAutoInitServ.IN:= TRUE;
	END_IF
	IF CasVypnutiaAutoInitServ.Q AND Motion[1].errorID = 0 AND Motion[2].errorID = 0 AND Motion[3].errorID = 0 AND Motion[4].errorID = 0  THEN
		Motion[1].cmd.autoInicialization:= FALSE;
		Motion[2].cmd.autoInicialization:= FALSE;
		Motion[3].cmd.autoInicialization:= FALSE;
		Motion[4].cmd.autoInicialization:= FALSE;
		CasVypnutiaAutoInitServ.IN:= FALSE;
	END_IF
	
	CasVypnutiaAutoInitServ.PT:= T#3s;
	CasVypnutiaAutoInitServ();
		
	
	//Stavy homingov serv//
	VstupManipulator_HomingOK:= Motion[1].status.DriveStatus.HomingOk;
	VystupManipulator_HomingOK:= Motion[2].status.DriveStatus.HomingOk;
	Valcovanie_HomingOK:= Motion[3].status.DriveStatus.HomingOk;
	Valcovanie2_HomingOK:= Motion[4].status.DriveStatus.HomingOk;
	
	//Zobrazenie aktuálnej pozície serv//
	VstupManipulator_AktualPozMM:= (Motion[1].status.ActPosition / 100);
	VystupManipulator_AktualPozMM:= (Motion[2].status.ActPosition / 100);
	Valcovanie_AktualPozMM:= (Motion[3].status.ActPosition / 100);
	Valcovanie2_AktualPozMM:= (Motion[4].status.ActPosition / 100);
	
	//Stav serva Ready//
	IF Motion[1].errorID = 0 AND Motion[2].errorID = 0 AND Motion[3].errorID = 0 AND Motion[4].errorID = 0 THEN
		Stav_ServaREADY:= TRUE;
	ELSE	
		Stav_ServaREADY:= FALSE;
	END_IF	
	
	
	
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

