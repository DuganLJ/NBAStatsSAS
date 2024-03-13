libname NBA "/home/u63803350/sasuser.v94/BasketballData/UnGroupedPlayerstats";
%LET Team=CHI;
/* Team you're searching for players from */
%LET Opponent=IND;
/* Team they're playing against*/

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
ODS noproctitle;
PROC SQL ;
	CREATE TABLE work.sorted as
	SELECT PlayerName, MP, FP, PTS, TRB, AST, STL, BLK, TOV
	FROM nba.allplayers
	WHERE Tm="&team" AND Opp="&Opponent" AND Start ne "DNP"
	ORDER BY PlayerName;
QUIT;
/* Pulls only players from &Team from larger database for report */
TITLE "Average Player from &Team statline vs. &Opponent";
PROC MEANS data=work.sorted mean;
	VAR FP PTS TRB AST STL blk TOV;
	BY PlayerName;
	OUTPUT out=work.Report;
run;
/* Creates Average Statlines (with Fantasy Points Average) using table from PROC SQL Statement */
Title "Individual games for Players from &Team vs. &Opponent";
PROC PRINT
	data=work.sorted;
run;
/* Prints individual box scores sorted by PlayerName to scout for outliers */
PROC SQL ;
	CREATE TABLE work.sorted2 as
	SELECT PlayerName, MP, FP, PTS, TRB, AST, STL, BLK, TOV
	FROM "/home/u63803350/sasuser.v94/BasketballData/UnGroupedPlayerstats/allplayers.sas7bdat"
	WHERE Tm="&Opponent" AND Opp="&Team" AND Start ne "DNP"
	ORDER BY PlayerName;
QUIT;
TITLE "Average Player from &Opponent statline vs. &Team";
PROC MEANS data=work.sorted2 mean;
	VAR FP PTS TRB AST STL blk TOV;
	BY PlayerName;
	OUTPUT out=work.Report;
run;
Title "Individual games for Players from &Opponent vs. &Team";
PROC PRINT
	data=work.sorted2;
run;
/* Repeats with inverse &team and &Opponent to see how players from opposing team will do */
ods proctitle;
Title;

	