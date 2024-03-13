Libname NBA "/home/u63803350/sasuser.v94/BasketballData/UnGroupedPlayerstats";
%LET team=CHI;
/* Change player Name here using underscores instead of spaces */
/* LOOKUP FOR TEAMS IS IN ABBREVIATED FORMAT */
/* Eastern conference:                              Western conference:        */
/* Atlanta      = ATL								Dallas               = DAL */
/* Brooklyn     = BKN								Denver				 = DEN */
/* Boston       = BOS								Golden State		 = GSW */
/* Chicago      = CHI								Houston				 = HOU */
/* Charlotte    = CHO								Los Angeles Clippers = LAC */
/* Cleveland    = CLE								Los Angeles Lakers   = LAL */
/* Detroit      = DET								Memphis				 = MEM */
/* Indiana      = IND								Minnesota			 = MIN */
/* Miami        = MIA								New Orleans			 = NOP */
/* Milwaukee    = MIL								Oklahoma City		 = OKC */
/* New York     = NYK								Phoenix				 = PHO */
/* Orlando      = ORL								Portland			 = POR */
/* Philidelphia = PHI								Sacramento			 = SAC */
/* Toronto      = TOR								San Antonio			 = SAS */
/* Washington   = WAS								Utah				 = UTA */
/* Only players with more than 40 Games started or more than 10 points scored per game included */
ODS NOPROCTITLE;
ODS GRAPHICS ON;
PROC SQL ;
	CREATE TABLE work.teamreportraw as
	SELECT PlayerName, GmSc, PTS, TRB, AST, STL, BLK, TOV, FG, FGA, '3P'n, '3PA'n, FT, FTA, H 
	FROM NBA.allplayers
	WHERE Tm="&Team" AND Start ne "DNP"
	ORDER BY PlayerName;
QUIT;
/* pull data from all players for &team */
data work.teamreportdataWL;
	SET work.teamreportraw;
	WL=substr(H,1,1);
run;
/* Generate WL variable using substring to pull from H column (which also includes difference in scores) */
PROC MEANS data=work.teamreportdataWL;
	VAR GmSc PTS TRB AST STL BLK TOV;
	BY PlayerName ;
	CLASS WL;
run;
/* Generate average stat lines for each player in wins and losses */