
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	
	//V·lcovanie 2 - Ovl·danie brzdy motora v·lcovacieho n·stroja//
	IF diValc2_OdbrzdOtacNastrojaMenic THEN
		doValc2_BrzdaOtacNastroja:= TRUE;
	ELSIF diValc2_OdbrzdOtacNastrojaRuka THEN
		doValc2_BrzdaOtacNastroja:= TRUE;
	ELSE
		doValc2_BrzdaOtacNastroja:= FALSE;
	END_IF	
	
	
	
	
	
	
	//Valcovanie 2 - Kontrola ot·Ëania n·stroja//
	IF (*Valcovanie2_Automat AND*) FM_Menic[3].Output.Status.Running THEN
		Valc2_CasKontrolyOtacaniaNastr.IN:= NOT diValc2_SnimacOtacaniaNastroja;
	ELSE
		Valc2_CasKontrolyOtacaniaNastr.IN:= FALSE;
	END_IF
	
	
	IF Valc2_CasKontrolyOtacaniaNastr.Q THEN
		Alarmy[76]:= TRUE;
		PoruchaStanicaValcovania2:= TRUE;
	END_IF	
	
	
	
	
	
	Valc2_CasKontrolyOtacaniaNastr.PT:= T#2s;
	Valc2_CasKontrolyOtacaniaNastr();
	
	
	
	
	
	
	 
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

