%LET playername=Jakob_Poeltl ;
/* Player Name (with underscores instead of spaces) */
Libname NBA "/home/u63803350/sasuser.v94/BasketballData/UnGroupedPlayerstats"; 
/* library Name */
PROC IMPORT datafile="/home/u63803350/sasuser.v94/BasketballData/UnGroupedPlayerstats/&playername" 
	OUT=NBA.&playername
	DBMS=xlsx REPLACE;
	getnames=yes;
run;
/* convert xlsx into SAS tables */
data NBA.&playername;
	SET NBA.&playername;
	PlayerName="&playername";
	KEEP _ALL_;
run;
/* add "PlayerName" variable to determine who the box score belongs to when files are merged into one dataset */
Data NBA.&playername;
	SET NBA.&playername;
	Start="YES";
	KEEP _ALL_;
run;
/* Gs imported as a numeric string if player hasn't missed games and a character string if they have resulting in issues when merging tables */
/* Make "Start" variable for next step to properly label so things like "Inactive" under Gs don't cause issues merging tables*/
DATA NBA.&playername;
	SET NBA.&playername;
	IF Gs=1 THEN Start="YES";
	ELSE Start="DNP";
	IF Gs=0 THEN Start="NO";
	DROP Gs;
	KEEP _ALL_;
run;
/* Add proper label for "Start" variable and drop the "Gs" column to solve issues when merging tables */


	