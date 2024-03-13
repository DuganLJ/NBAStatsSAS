Libname NBA "/home/u63803350/sasuser.v94/BasketballData/UnGroupedPlayerstats";
%LET playername=Cam_Thomas;
/* Change player Name here using underscores instead of spaces */
/* Only players with more than 40 Games started or more than 10 points scored per game included */
ODS NOPROCTITLE;
ODS GRAPHICS ON;
FOOTNOTE "Data taken from basketball-reference on 3/10/24 and includes all games from the 2023-2024 season.";
PROC SQL ;
	CREATE TABLE work.playerreportdata as
	SELECT  G, GmSc, FP, PTS, TRB, AST, STL, BLK, TOV, FG, FGA, '3P'n, '3PA'n, FT, FTA, Opp, H, PlayerName, F
	FROM NBA.allplayers
	WHERE PlayerName="&playername" AND Start ne "DNP"
	ORDER BY G;
QUIT;
/* Pulls playerdata using &playername to eliminate box scores not from target player */
Title "Overview for &playername";
Title2 "Average Stats Against All Opponents";
PROC MEANS data=work.playerreportdata mean min max maxdec=2 ;
	VAR GmSc FP PTS TRB AST STL BLK TOV FG FGA '3P'n '3PA'n FT FTA;
run;
/* produces average statlines over a season */
Title2 "Performance Over the Season";
PROC SGPLOT data=work.playerreportdata;
	reg x=G y=GmSc;
run;
/* creates scatter plot with G on the x axis and GmSc on the y axis.  Regression line to show whether a player is trending up or down */
PROC SORT data=work.playerreportdata;
	BY Opp;
run;
/* Sorts playerreportdata by opponent for following steps */
Title2 "Average Stats Against Separated by Opposing team";
PROC MEANS data=work.playerreportdata mean maxdec=2;
	VAR GmSc FP PTS TRB AST STL BLK TOV FG FGA '3P'n '3PA'n FT FTA;
	BY Opp;
run;
/* Produces average statline against each individual team */
Title2 "Graph of Game Score By Opponent";
proc sgplot data=work.playerreportdata;
	vbar Opp / response=GmSc group=GmSc groupdisplay=cluster stat=mean;
	yaxis grid;
run;
/* Creates bar graph with game score clustered by opponent */
data work.playerreportdataWL;
	SET work.playerreportdata;
	WL=substr(H,1,1);
	LABEL WL="Win/Loss";
run;
/* Adds win/loss column with substring in work table*/
PROC SORT data=work.playerreportdataWL;
	BY WL;
run;
/* Sort by Win/Loss (WL) for following step */
Title2 "Player Statistics by Win/Loss";
PROC MEANS data=work.playerreportdataWL mean;
	VAR GmSc PTS TRB AST STL BLK TOV;
	BY PlayerName;
	CLASS WL;
run;
/* Reports player stats separated by Wins and Losses */
DATA work.playerreportdataHA;
	SET work.playerreportdata;
	IF F="@" THEN HomeAway="Away";
	ELSE HomeAway="Home";
run;
/* Generates Home or away column from F variable.  Necessary because value is either empty or @ */
PROC SORT data=work.playerreportdataHA;
	BY HomeAway;
run;
/* Sort By home or away for next PROC MEANS step*/
Title2 "Player Statistics by Home or Away";
PROC MEANS data=work.playerreportdataHA mean;
	VAR GmSc PTS TRB AST STL BLK TOV;
	BY PlayerName;
	CLASS HomeAway;
run;
ods graphics / reset;
ODS PROCTITLE;
Title;
footnote;
