/* Data obtained from 3/10/2024 and includes games in the 2023-2024 season */
Libname NBA "/home/u63803350/sasuser.v94/BasketballData/UnGroupedPlayerstats"; 
data NBA.AllPlayers ;
	LENGTH PlayerName $ 45;
	MERGE NBA.Aaron_Gordon NBA.Aaron_Nesmith NBA.Alex_Caruso NBA.Alperen_Sengun NBA.Al_Horford NBA.Andrew_Nembhard NBA.Andrew_Wiggins
	NBA.Andre_Drummond NBA.Anfernee_Simons NBA.Anthony_Black NBA.Anthony_Davis NBA.Anthony_Edwards  NBA.Ausar_Thompson NBA.Austin_Reaves
	NBA.Ayo_Dosunmu NBA.Bam_adebayo NBA.Bogdan_Bogdanovic NBA.Bojan_Bogdanovic NBA.Bradley_Beal NBA.Brandon_Ingram NBA.Brandon_Miller NBA.Brook_Lopez
	NBA.Buddy_Hield NBA.Cade_Cunningham NBA.Caleb_Martin NBA.Cameron_Johnson NBA.Cam_Thomas NBA.Cam_Whitmore NBA.Chet_Holmgren NBA.Chris_Paul
	NBA.CJ_McCollum NBA.Clint_Capela NBA.Coby_White NBA.Collin_Sexton NBA.Dalen_Terry NBA.Damian_Lillard NBA.DAngelo_Russell NBA.Daniel_Gafford
	NBA.DeAaron_Fox NBA.DeAndre_Ayton NBA.DeAndre_Hunter NBA.DeAnthony_Melton NBA.Dean_Wade NBA.Dejounte_Murray NBA.DeMar_DeRozan NBA.Deni_Avdija
	NBA.Dennis_Schroder NBA.Dereck_Lively NBA.Derrick_Jones_Jr NBA.Derrick_White NBA.Desmond_Bane NBA.Devin_Booker NBA.Devin_Vassell NBA.Dillon_Brooks
	NBA.Domantas_Sabonis NBA.Donovan_Mitchell NBA.Donte_Divincenzo NBA.Dorian_Finney_Smith NBA.Draymond_Green NBA.Duncan_Robinson NBA.Evan_Mobley
	NBA.Franz_Wagner NBA.Fred_VanVleet NBA.Gary_Trent_Jr NBA.Giannis_Antetokounmpo NBA.Goga_Bitadze NBA.Grant_Williams NBA.Grayson_Allen
	NBA.Harrison_Barnes NBA.Haywood_Highsmith NBA.Herbert_Jones NBA.Immanuel_Quickley NBA.Isaiah_Hartenstein NBA.Isaiah_Stewart NBA.Ivica_Zubac
	NBA.Jabari_Smith_Jr NBA.Jaden_Ivey NBA.Jaden_McDaniels NBA.Jaime_Jacquez NBA.Jakob_Poeltl NBA.Jalen_Brunson NBA.Jalen_Duren NBA.Jalen_Green
	NBA.Jalen_Johnson NBA.Jalen_Suggs NBA.Jalen_Williams NBA.Jamal_Murray NBA.James_Harden NBA.Jaren_Jackson_Jr NBA.Jarrett_Allen NBA.Jaylen_Brown NBA.Jayson_Tatum
	NBA.Jerami_Grant NBA.Jeremy_Sochan NBA.Jevon_Carter NBA.Jimmy_Butler NBA.Joel_Embiid NBA.John_Collins NBA.Jonas_Valanciunas NBA.Jonathan_Kuminga
	NBA.Jordan_Clarkson NBA.Jordan_Poole NBA.Josh_Giddey NBA.Josh_Green NBA.Josh_Hart NBA.Jrue_Holiday NBA.Julian_Phillips NBA.Julius_Randle
	NBA.Jusuf_Nurkic NBA.Karl_Anthony_Towns NBA.Kawhi_Leonard NBA.Keegan_Murray NBA.Keldon_Johnson NBA.Kelly_Oubre_Jr NBA.Kentavious_Caldwell_Pope NBA.Kevin_Durant
	NBA.Kevin_Huerter NBA.Kevin_Love NBA.Kevon_Looney NBA.Keyonte_George NBA.Khris_Middleton NBA.Killian_Hayes NBA.Klay_Thompson NBA.Kristaps_Porzingis
	NBA.Kyle_Kuzma NBA.Kyle_Lowry NBA.Kyrie_Irving NBA.LaMelo_Ball NBA.Lauri_Markkanen NBA.LeBron_James NBA.Luguentz_Dort NBA.Luka_Doncic
	NBA.Luke_Kennard NBA.Malcolm_Brogdon NBA.Malik_Beasley NBA.Malik_Monk NBA.Marcus_Smart NBA.Marvin_Bagley_III NBA.Max_Strus NBA.Michael_Porter_Jr
	NBA.Mikal_Bridges NBA.Mike_Conley NBA.Miles_Bridges NBA.Mitchell_Robinson NBA.Myles_Turner NBA.Naz_Reid NBA.Nick_Richards NBA.Nic_Claxton
	NBA.Nikola_Jokic NBA.Nikola_Vucevic NBA.Nikola_Jovic NBA.Norman_Powell NBA.Obi_Toppin NBA.Onuralp_Bitim NBA.Paolo_Banchero NBA.Pascal_Siakam 
	NBA.Patrick_Williams NBA.Paul_George NBA.Paul_Reed NBA.PJ_Washington NBA.Reggie_Jackson NBA.RJ_Barrett NBA.Rudy_Gobert NBA.Rui_Hachimura
	NBA.Russell_Westbrook NBA.Saddiq_Bey NBA.Santi_Aldama NBA.Scoot_Henderson NBA.Scottie_Barnes NBA.Shaedon_Sharpe NBA.Shai_Gilgeous_Alexander
	NBA.Spencer_Dinwiddie NBA.Stephen_Curry NBA.Talen_Horton_Tucker NBA.Terance_Mann NBA.Tim_Hardaway_Jr NBA.Tobias_Harris NBA.Torrey_Craig 
	NBA.Trae_Young NBA.Trey_Murphy_III NBA.Tre_Jones NBA.Tyler_Herro NBA.Tyrese_Maxey NBA.Tyrese_Haliburton NBA.Tyus_Jones NBA.Victor_Wembanyama NBA.Vince_Williams_Jr NBA.Wendell_Carter_Jr
	NBA.Zach_Collins NBA.Zach_LaVine NBA.Zion_Williamson;
	BY PlayerName;
run;
/* Merges all player tables into one larger table so lookups can be run from a single table */
data NBA.AllPlayers ;
	SET NBA.AllPlayers ;
	IF Start ne "DNP" THEN
	FP = ((PTS)+(TRB*1.2)+(AST*1.5)+(STL*3)+(BLK*3)-(TOV));
run;
/* Generates Fantasy Points (using FanDuel scoring system) for each game a player participated in */
OPTIONS VALIDVARNAME=ANY;
DATA NBA.ALLPlayers;
	SET NBA.allplayers;
	KEEP _ALL_;
	LABEL
		Rk="Game Number for Team"
		G="Game Number for Player"
		Tm="Team"
		F="Home or Away"
		FG="Field Goals Made"
		FGA="Field Goal Attempts"
		'FG%'n="Percentage of Field Goals Made"
		'3P'n="3 Pointers Made"
		'3PA'n="3 Point Attempts"
		'3P%'n="Percentage of 3 Pointers Made"
		FT="Free Throws Made"
		FTA="Free Throw Attempts"
		'FT%'n="Percentage of Free Throws Made"
		TRB="Total Rebounds"
		ORB="Offensive Rebounds"
		DRB="Defensive Rebounds"
		AST="Assists"
		STL="Steals"
		BLK="Blocks"
		TOV="Turnovers"
		PF="Personal Fouls"
		GmSc="Game Score"
		FP="Fantasy Points (FanDuel)"
		MP="Minutes Played"
		H="Win/Loss";
run;
/* Label Variables for ease of use */