
PROGRAM _INIT
	(* Insert code here *)
	 
END_PROGRAM

PROGRAM _CYCLIC
	//0 - Porucha tlaku vzduchu//
	//1 - Bolo stlacene tlacitko CS//
	//2 - Hydraulicke cerpadlo - nizka hladina oleja//
	//3 - Hydraulicke cerpadlo - porucha motora cerpadla//
	//4 - Hydraulicke cerpadlo - vysoka teplota oleja//
	//5 - Hydraulicke cerpadlo - zanesenie olejoveho filtra//
	//10 - Oddelovac - porucha prepnutia oddelovaca //
	//15 - Vstupny dopravnik - porucha vysunutia zdvihu rotora//
	//16 - Vstupny dopravnik - porucha zasunutia zdvihu rotora//
	//17 - Vstupny dopravnik - porucha zdvihu rotora//
	//20 - Vstupny manipulator - porucha zatvorenia gripra//
	//21 - Vstupny manipulator - porucha otvorenia gripra//
	//22 - Vstupny manipulátor - porucha zdvihu//
	//23 - Vstupny manipulator - porucha zostupu//
	//24 - Vstupny manipulator - porucha serva pojazdu//
	//25 - Vstupny manipulator - pretazenie serva pojazdu//
	//26 - Vstupny manipulator - dosiahnuta limitna pozicia pojazdu//
	//30 - Otocny stol - porucha motora//
	//31 - Otocny stol - porucha otocenia stola//
	//32 - Otocny stol - vysoka teplota motora//
	//33 - Otocny stol - blokacia stola aktivna//
    //34 - Otocny stol - naliatok nebol odstrihnuty //
	//40 - Stanica strihania - porucha zdvihu rotora//
	//41 - Stanica strihania - porucha zostupu rotora//
	//42 - Stanica strihania - porucha otvorenia gripra naliatku//
	//43 - Stanica strihania - porucha zatvorenia gripra naliatku//
	//44 - Stanica strihania - porucha otvorenia gripra striznika//
	//45 - Stanica strihania - porucha zatvorenia gripra striznika//
	//46 - Stanica strihania - porucha presunu griprov do vychodiskovej pozicie//
	//47 - Stanica strihania - porucha presunu griprov do pozicie odhodenia//
	//48 - Stanica strihania - v stanici zostal zaseknuty rotor//
	//50 - Stanica razenia - porucha zdvihu rotora//
	//51 - Stanica razenia - porucha zostupu rotora//
	//52 - Stanica razenia - v stanici zostal zaseknuty rotor//
	//53 - Stanica vonkajsieho valcovania - porucha serva zdvihu rotora//
	//54 - Stanica vonkajsieho valcovania - porucha menica otacania nastroja//
	//55 - Stanica vonkajsieho valcovania - pretazenie serva zdvihu rotora//
	//56 - Stanica vonkajsieho valcovania - dosiahnuta limitna pozicia zdvihu rotora//
	//57 - Stanica vonkajsieho valcovania - porucha zdvihu horneho pritlaku//
	//58 - Stanica vonkajsieho valcovania - porucha zostupu horneho pritlaku//
	//59 - Stanica vonkajsieho valcovania - nizky tlak vzduchu v hornom pritlaku//
	//60 - Stanica vnutorneho valcovania - porucha zdvihu rotora//
	//61 - Stanica vnutorneho valcovania - porucha zostupu rotora//
	//62 - Stanica vnutorneho valcovania - zatvorenia gripra//
	//63 - Stanica vnutorneho valcovania - otvorenie gripra//
	//64 - Stanica vnutorneho valcovania - porucha motora otacania rotora//
	//65 - Stanica vnutorneho valcovania - porucha serva zdvihu//
	//66 - Stanica vnutorneho valcovania - pretazenie serva zdvihu//
	//67 - Stanica vnutorneho valcovania - dosiahnuta limitna pozicia zdvihu//
	//68 - Stanica vnutorneho valcovania - vypadnuty nastroj valcovania//
	//70 - Stanica merania - porucha zdvihu rotora//
	//71 - Stanica merania - porucha zostupu rotora//
	//72 - Stanica merania - porucha motora otacania rotora//
	//73 - Stanica merania - v stanici zostal zaseknuty rotor//
	//74 - Stanica vonkajsieho valcovania - v stanici zostal zaseknuty rotor//
	//75 - Stanica vonkajsieho valcovania - rotor nebol vyvalcovany//
	//76 - Stanica vonkajsieho valcovania - porucha otáèania valcovacieho nastroja//
	//80 - Vystupny manipulator - porucha zatvorenia gripra//
	//81 - Vystupny manipulator - porucha otvorenia gripra//
	//82 - Vystupny manipulator - porucha zdvihu//
	//83 - Vystupny manipulator - porucha zostupu//
	//84 - Vystupny manipulator - porucha serva pojazdu//
	//85 - Vystupny manipulator - pretazenie serva pojazdu//
	//86 - Vystupny manipulator - dosiahnuta limitna pozicia pojazdu//
	//90 - Vystupny odsuvac - porucha vysunutia//
	//91 - Vystupny odsuvac - porucha zasunutia//
	//92 - Porucha modulu DB1//
	//93 - Porucha modulu DB2//
	//94 - Porucha modulu DB3//
	//95 - Porucha modulu DB4//
	//96 - Porucha modulu DB5//
	//97 - Porucha modulu DB6//
	
	
	
		
	//*********************************Zistenie alarmu************************************************************//	
	FOR i:=0 TO 100 BY 1 DO
		Alarmy[i];
		IF Alarmy[i] = TRUE THEN
			NastalaPorucha:= TRUE;
		END_IF	
	END_FOR
	
	
	//*********************************Blikanie symbolu poruchy na OP*****************************************//
	IF NastalaPorucha THEN
		ZobrazSymbolAlarmu:= Blikac500ms;
	ELSE
		ZobrazSymbolAlarmu:= FALSE;
	END_IF
	
	//*********************************Ovládanie kontrolky poruchy********************************************//
	IF NastalaPorucha THEN
		doKontrolkaPORUCHA:= Blikac500ms;
	ELSE
		doKontrolkaPORUCHA:= FALSE;
	END_IF	
	
	
	//*********************************Zelené svetlo majáka****************************************************//
	IF Zariadenie_StavAutomat AND NOT Zariadenie_StavPoINIT THEN 
		doMajak_ZeleneSvetlo:= Blikac500ms;
	ELSIF Zariadenie_StavAutomat AND Zariadenie_StavPoINIT THEN 
		doMajak_ZeleneSvetlo:= TRUE;
	ELSE
		doMajak_ZeleneSvetlo:= FALSE;
	END_IF
	
	//**********************************Žlté svetlo majáka*****************************************************//
	IF TP_ZobrazHlasenieDoprOK_Plny = 0 OR TP_ZobrazHlasenieDoprNG_Plny = 0 THEN
		doMajak_ZlteSvetlo:= Blikac500ms;
	ELSE	
		doMajak_ZlteSvetlo:= FALSE;
	END_IF
	
	//**********************************Èervené svetlo majáka***************************************************//
	IF NastalaPorucha THEN
		doMajak_CerveneSvetlo:= Blikac500ms;
	ELSE	
		doMajak_CerveneSvetlo:= FALSE;
	END_IF
	
	//***********************************Zvuková signalizácia majáka*********************************************//
	IF EDGEPOS (NastalaPorucha = TRUE) THEN
		ZapniHukacku:= TRUE;
	END_IF
	
	IF ZapniHukacku THEN
		doMajak_Hukacka:= Blikac500ms;
	ELSE
		doMajak_Hukacka:= FALSE;
	END_IF
	
	IF NOT NastalaPorucha THEN
		ZapniHukacku:= FALSE;
	ELSIF VypnutieHukacky THEN
		ZapniHukacku:= FALSE;
	END_IF	
	
	//*********************************Potvrdenie alarmu**********************************************************//
	IF PotvrdenieAlarmov THEN
		Motion[1].cmd.autoInicialization:= TRUE;
		Motion[2].cmd.autoInicialization:= TRUE;
		Motion[3].cmd.autoInicialization:= TRUE;
		Motion[4].cmd.autoInicialization:= TRUE;
		FM_Menic[1].Input.Command.Acknowledge:= TRUE;
		FM_Menic[2].Input.Command.Acknowledge:= TRUE;
		FM_Menic[3].Input.Command.Acknowledge:= TRUE;
		
		brsmemset(ADR(Alarmy),0,SIZEOF(Alarmy));
		NastalaPorucha:= FALSE;
		CasPotvrdeniaAlarmu.IN:= TRUE;
		PoruchaZdvihuRotora:= FALSE;
		PoruchaOddelovaca:= FALSE;
		PoruchaOtocnyStol:= FALSE;
		PoruchaStanicaMerania:= FALSE;
		PoruchaStanicaRazenia:= FALSE;
		PoruchaStanicaStrihania:= FALSE;
		PoruchaStanicaValcovania:= FALSE;
		PoruchaStanicaValcovania2:= FALSE;
		PoruchaVstupManipulator:= FALSE;
		PoruchaVystupManipulator:= FALSE;
		PoruchaVystupOdsuvac:= FALSE;
		VypnutieHukacky:= TRUE;
		PotvrdenieAlarmov:= FALSE;
	END_IF
	
	IF CasPotvrdeniaAlarmu.Q AND Motion[1].errorID = 0 AND Motion[2].errorID = 0 AND Motion[3].errorID = 0 AND Motion[4].errorID = 0  THEN
		Motion[1].cmd.autoInicialization:= FALSE;
		Motion[2].cmd.autoInicialization:= FALSE;
		Motion[3].cmd.autoInicialization:= FALSE;
		Motion[4].cmd.autoInicialization:= FALSE;
		FM_Menic[1].Input.Command.Acknowledge:= FALSE;
		FM_Menic[2].Input.Command.Acknowledge:= FALSE;
		FM_Menic[3].Input.Command.Acknowledge:= FALSE;
		VypnutieHukacky:= FALSE;
		CasPotvrdeniaAlarmu.IN:= FALSE;
	END_IF
	
	CasPotvrdeniaAlarmu.PT:= T#2s;
	CasPotvrdeniaAlarmu();
	
	
	//******************************Porucha modulu DB1***********************************************************//
	IF SafetyPLC_Nabehlo AND NOT Modul_DB1_OK THEN
		Alarmy[92]:= TRUE;
	END_IF	
	
	
	//******************************Porucha modulu DB2***********************************************************//
	IF SafetyPLC_Nabehlo AND NOT Modul_DB2_OK THEN
		Alarmy[93]:= TRUE;
	END_IF	
	
	//******************************Porucha modulu DB3***********************************************************//
	IF SafetyPLC_Nabehlo AND NOT Modul_DB3_OK THEN
		Alarmy[94]:= TRUE;
	END_IF	
	
	//******************************Porucha modulu DB4***********************************************************//
	IF SafetyPLC_Nabehlo AND NOT Modul_DB4_OK THEN
		Alarmy[95]:= TRUE;
	END_IF	
	
	//******************************Porucha modulu DB5***********************************************************//
	IF SafetyPLC_Nabehlo AND NOT Modul_DB5_OK THEN
		Alarmy[96]:= TRUE;
	END_IF	
	
	//******************************Porucha modulu DB6***********************************************************//
	IF SafetyPLC_Nabehlo AND NOT Modul_DB6_OK THEN
		Alarmy[97]:= TRUE;
	END_IF	
	
		
	//******************************Porucha tlaku vzduchu*********************************************************//
	IF (Zariadenie_StavAutomat OR Zariadenie_StavManual) AND NOT diHlavnyPrivodVzduchu_TlakOK THEN
		Alarmy[0]:= TRUE;
	END_IF	
	
	
	//******************************Stanica vonkajšieho valcovacia - Porucha tlaku vzduchu**********************************//
	IF Valcovanie2_Automat AND NOT diValc2_TlakPritlaku_OK THEN
		Alarmy[59]:= TRUE;
		PoruchaStanicaValcovania2:= TRUE;
	END_IF	
	
	
	
	//******************************Bolo stlaèené tlaèítko CS*****************************************************//
	IF EDGENEG (Stav_CS_Odblokovane = TRUE) THEN
		Alarmy[1]:= TRUE;
	END_IF
	
	
	//*******************************Vstupný manipulátor - Porucha serva pojazdu**********************************************************************//
	IF (VstupManipulator_Automat OR VstupManipulator_Manual) AND Motion[1].error THEN 
		Motion[1].cmd.halt:= TRUE;
		Alarmy[24]:= TRUE;
		PoruchaVstupManipulator:= TRUE;
	END_IF
	
	
	//*******************************Výstupný manipulátor - Porucha serva pojazdu**********************************************************************//
	IF (VystupManipulator_Automat OR VystupManipulator_Manual) AND Motion[2].error THEN 
		Motion[2].cmd.halt:= TRUE;
		Alarmy[84]:= TRUE;
		PoruchaVystupManipulator:= TRUE;
	END_IF
	
	
	//*******************************Stanica vnútorného valcovania  - Porucha serva zdvihu nástroja**********************************************************************//
	IF (Valcovanie_Automat OR Valcovanie_Manual) AND Motion[3].error THEN 
		Motion[3].cmd.halt:= TRUE;
		Alarmy[65]:= TRUE;
		PoruchaStanicaValcovania:= TRUE;
	END_IF
	
	//*******************************Stanica vonkajšieho valcovania  - Porucha serva zdvihu rotora**********************************************************************//
	IF (Valcovanie2_Automat OR Valcovanie2_Manual) AND Motion[4].error THEN 
		Motion[4].cmd.halt:= TRUE;
		Alarmy[53]:= TRUE;
		PoruchaStanicaValcovania2:= TRUE;
	END_IF
	
	
	
	//**********************************Stanica merania - Porucha menièa *********************************************************************//
	IF (Meranie_Automat OR Meranie_Manual) AND (FM_Menic[1].Output.Status.Error OR NOT diMeranie_PoruchaOtacRotora) THEN
		Alarmy[72]:= TRUE;
		PoruchaStanicaMerania:= TRUE;
	END_IF
	
	
	//**********************************Stanica vnútorného valcovania - Porucha menièa *********************************************************************//
	IF (Valcovanie_Automat OR Valcovanie_Manual) AND (FM_Menic[2].Output.Status.Error OR NOT diValcovanie_PoruchaOtacRotora) THEN
		Alarmy[64]:= TRUE;
		PoruchaStanicaValcovania:= TRUE;
	END_IF
	
	
	//**********************************Stanica vonkajšieho valcovania - Porucha menièa *********************************************************************//
	IF (Valcovanie2_Automat OR Valcovanie2_Manual) AND (FM_Menic[3].Output.Status.Error OR NOT diValc2_PorMotoraOtacania) THEN
		Alarmy[54]:= TRUE;
		PoruchaStanicaValcovania2:= TRUE;
	END_IF
	
	
	//************************************Vstupný manipulátor - Pretazenie serva pojazdu************************************************************************//
	IF (VstupManipulator_Automat OR VstupManipulator_Manual) AND Motion[1].status.ActTorque > 1.7 THEN
		Motion[1].cmd.halt:= TRUE;
		Alarmy[25]:= TRUE;
		PoruchaVstupManipulator:= TRUE;
	END_IF
	
		
	//************************************Výstupný manipulátor - Pretazenie serva pojazdu************************************************************************//
	IF (VystupManipulator_Automat OR VystupManipulator_Manual) AND Motion[2].status.ActTorque > 1.7 THEN
		Motion[2].cmd.halt:= TRUE;
		Alarmy[85]:= TRUE;
		PoruchaVystupManipulator:= TRUE;
	END_IF
	
	//************************************Stanica vnútorného valcovania - Pretazenie serva zdvihu************************************************************************//
	IF (Valcovanie_Automat OR Valcovanie_Manual) AND Motion[3].status.ActTorque > 15.0 THEN
		Motion[3].cmd.halt:= TRUE;
		Alarmy[66]:= TRUE;
		PoruchaStanicaValcovania:= TRUE;
	END_IF
	
	//************************************Stanica vonkajšieho valcovania - Pretazenie serva zdvihu rotora************************************************************************//
	IF (Valcovanie2_Automat OR Valcovanie2_Manual) AND Motion[4].status.ActTorque > 15.0 THEN
		Motion[4].cmd.halt:= TRUE;
		Alarmy[55]:= TRUE;
		PoruchaStanicaValcovania2:= TRUE;
	END_IF
	
	
	
	//************************************Hydraulika - Nízka hladina oleja**************************************************************************************//
	IF NOT diHydraulika_HladinaOlejaOK THEN
		CasKontrolyOlejaHydrauliky.IN:= TRUE;
	ELSE	
		CasKontrolyOlejaHydrauliky.IN:= FALSE;
	END_IF	
	
	IF (Strihanie_Automat OR Razenie_Automat OR Strihanie_Manual OR Razenie_Manual) AND CasKontrolyOlejaHydrauliky.Q THEN
		Alarmy[2]:= TRUE;
		doHydraulika_ChodCerpadla:= FALSE;
		PoruchaStanicaRazenia:= TRUE;
		PoruchaStanicaStrihania:= TRUE;
	END_IF	

	CasKontrolyOlejaHydrauliky.PT:= T#5s;
	CasKontrolyOlejaHydrauliky();
	
	
	
	//************************************Hydraulika - Porucha motora èerpadla***********************************************************************************//
	IF (Strihanie_Automat OR Razenie_Automat OR Strihanie_Manual OR Razenie_Manual) AND NOT diHydraulika_PoruchaCerpadla THEN
		Alarmy[3]:= TRUE;
		doHydraulika_ChodCerpadla:= FALSE;
		PoruchaStanicaRazenia:= TRUE;
		PoruchaStanicaStrihania:= TRUE;
	END_IF	
	
//	************************************Hydraulika - Vysoká teplota oleja***********************************************************************************//
	IF (Strihanie_Automat OR Razenie_Automat OR Strihanie_Manual OR Razenie_Manual) AND NOT diHydraulika_TeplotaOlejaOK THEN
		Alarmy[4]:= TRUE;
		doHydraulika_ChodCerpadla:= FALSE;
		PoruchaStanicaRazenia:= TRUE;
		PoruchaStanicaStrihania:= TRUE;
	END_IF		
	
	//************************************Hydraulika - Zanesenie olejového filtra***********************************************************************************//
	IF (Strihanie_Automat OR Razenie_Automat OR Strihanie_Manual OR Razenie_Manual) AND diHydraulika_Stav_FilterZaneseny THEN
		Alarmy[5]:= TRUE;
		doHydraulika_ChodCerpadla:= FALSE;
		PoruchaStanicaRazenia:= TRUE;
		PoruchaStanicaStrihania:= TRUE;
	END_IF	
	
	
	
	//****************************************Otoèný stol - porucha motora*****************************************************************************************//
	IF (Stol_Automat OR Stol_Manual) AND NOT diStol_PoruchaOtacStola THEN
		Alarmy[30]:= TRUE;
		PoruchaOtocnyStol:= TRUE;
	END_IF
	
	//***************************************Otoèný stol - vysoka teplota motora****************************************************************************************//
	IF (Stol_Automat OR Stol_Manual) AND diStol_TeplotaMotoraOK THEN
		Alarmy[32]:= TRUE;
		PoruchaOtocnyStol:= TRUE;
	END_IF
	
	
	
	
	 
		END_PROGRAM

PROGRAM _EXIT
		(* Insert code here *)
	 
		END_PROGRAM

