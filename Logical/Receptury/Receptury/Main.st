
PROGRAM _INIT
	
	MpRecipeXml_0.Load:= TRUE;
			 
END_PROGRAM

PROGRAM _CYCLIC

	//Na��tanie receptur z pam�te//
	IF MpRecipeXml_0.Load AND (MpRecipeXml_0.CommandDone OR MpRecipeXml_0.Error) THEN
		MpRecipeXml_0.Load:= FALSE;
		old_i:= 1;
		i:= 0;
		IndexZoznam:= 0;
	END_IF	
	
	//Konfigur�cia receptur//
	MpRecipeXml_0.MpLink:= ADR(gRecipeXmlLink);  //takto sa menuje mapp komponenta v configurating view//
	MpRecipeXml_0.Enable:= TRUE;
	MpRecipeXml_0.Category:= ADR('RECEPTURY');
	MpRecipeXml_0.DeviceName:= ADR('HDD');  //N�zov media, kde sa bud� receptury ukladat//
	MpRecipeXml_0.FileName:= ADR('UlozeneReceptury'); //N�zov s�boru do ktor�ho sa recept�ry ulo�ia//
	MpRecipeXml_0();
	
	MpRecipeRegPar_0.MpLink:= ADR(gRecipeXmlLink);
	MpRecipeRegPar_0.Enable:= TRUE;
	MpRecipeRegPar_0.Category:= ADR('RECEPTURY');
	MpRecipeRegPar_0.PVName:= ADR('Receptura'); //N�zov premenn�, kde je vytvoren� �truktura dat pre receptury//
	MpRecipeRegPar_0();

	//Zobrazenie n�zvou recept�r//
	FOR IndexZoznam:=0 TO 20 BY 1 DO
		ZoznamReceptur[IndexZoznam]:= Receptura[IndexZoznam].Nazov;
	END_FOR
	
	//Posun indexu//
	IF MoveUP THEN
		IF i< 20 THEN
			i:= i+1;
		END_IF
		MoveUP:= FALSE;
	END_IF
	
	IF MoveDown THEN
		IF i>0 THEN
			i:= i-1;
		END_IF
		MoveDown:= FALSE;
	END_IF
	
	//Listovanie v ulo�en�ch recepturach//
	IF old_i <> i THEN
		Nazov:= Receptura[i].Nazov;
		Premenna_1:= Receptura[i].Premenna_1;
		Premenna_2:= Receptura[i].Premenna_2;
		Premenna_3:= Receptura[i].Premenna_3;
		Premenna_4:= Receptura[i].Premenna_4;
		Premenna_5:= Receptura[i].Premenna_5;
		Premenna_6:= Receptura[i].Premenna_6;
		old_i:= i;
	END_IF
	
	
	
	//Ulo�enie receptury//
	IF UlozRecepturu THEN
		Receptura[i].Nazov:= Nazov;
		Receptura[i].Premenna_1:= Premenna_1;
		Receptura[i].Premenna_2:= Premenna_2;
		Receptura[i].Premenna_3:= Premenna_3;
		Receptura[i].Premenna_4:= Premenna_4;
		Receptura[i].Premenna_5:= Premenna_5;
		Receptura[i].Premenna_6:= Premenna_6;
		MpRecipeXml_0.Save:= TRUE;
		IF MpRecipeXml_0.CommandDone THEN
			MpRecipeXml_0.Save:= FALSE;
			UlozRecepturu:= FALSE;
		END_IF
	END_IF	
	
	//Na�itanie receptur do premenn�ch//
	IF NacitajRecepturu THEN
		ZvolenyNazovProduktu:= Nazov;
		ZvolenaPremenna_1:= Premenna_1;
		ZvolenaPremenna_2:= Premenna_2;
		ZvolenaPremenna_3:= Premenna_3;
		ZvolenaPremenna_4:= Premenna_4;
		ZvolenaPremenna_5:= Premenna_5;
		ZvolenaPremenna_6:= Premenna_6;
		NacitajRecepturu:= FALSE;
	END_IF
	
	
	
	
END_PROGRAM

PROGRAM _EXIT
	(* Insert code here *)
	 
END_PROGRAM

