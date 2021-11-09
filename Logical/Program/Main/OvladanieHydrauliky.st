
ACTION OvladanieHydrauliky: 

	
	//Ovládanie èerpadla//
	//Zapnutie èerpadla hydrauliky//
	IF (Strihanie_Automat OR Razenie_Automat) AND NOT Stol_StavPrazdnyStol THEN
		CasVypnutiaHydrauliky.IN:= FALSE;
		doZatvorenieOdvzdHydrauliky:= FALSE;
		CasZapnutiaHydrauliky.IN:= TRUE;
	ELSIF Strihanie_Manual OR Razenie_Manual THEN
		CasVypnutiaHydrauliky.IN:= FALSE;
		doZatvorenieOdvzdHydrauliky:= FALSE;
		CasZapnutiaHydrauliky.IN:= TRUE;
	ELSE	
		CasVypnutiaHydrauliky.IN:= TRUE;
		CasZapnutiaHydrauliky.IN:= FALSE;
	END_IF	
	
	IF CasZapnutiaHydrauliky.Q THEN
		doHydraulika_ChodCerpadla:= TRUE;
	END_IF	
	
	IF CasVypnutiaHydrauliky.Q THEN
		doZatvorenieOdvzdHydrauliky:= TRUE;
		doHydraulika_ChodCerpadla:= FALSE;
		Vyrazanie.OUT.VyrazanieZasunut:= FALSE;
		Vyrazanie.OUT.VyrazanieVysunut:= FALSE;
		doRazenie_ZostupRotora:= FALSE;
	END_IF	
	
	
	

	CasZapnutiaHydrauliky.PT:= T#1s;
	CasZapnutiaHydrauliky();
	
	CasVypnutiaHydrauliky.PT:= T#60s;
	CasVypnutiaHydrauliky();
	
END_ACTION
