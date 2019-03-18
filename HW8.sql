use MLB;
create table Players(
	player_id		int PRIMARY KEY NOT NULL IDENTITY(1,1),
	name			varchar(20),
	givenName		varchar(20),
	birthday		date,
	deathDay		date,
	throwing_hand	char(1) check (throwing_hand = 'L' OR throwing_hand = 'R' OR throwing_hand = 'A'),
	batting_hand	char(1) check (batting_hand = 'L' OR batting_hand = 'R' OR batting_hand = 'A'),
	birthCity		varchar(20),
	firstGame		date,
	lastGame		date
);
create table Seasons(
	year	int check (year>1900),
	primary key (year)
);
create table Teams(
	team_id			int PRIMARY KEY NOT NULL IDENTITY(1,1),
	name			varchar(20),
	league			varchar(20),
	year_founded	int check (year_founded >1900),
	year_last		int check (year_last >= 1900),
);
create table FieldingStats(
	player_id		int,
	year			int,
	errors			int check (errors >= 0),
	put_outs		int check (put_outs >= 0),
	primary key(player_id,year),
	foreign key(player_id) references Players(player_id),
	foreign key(year) references Seasons(year)
);
create table PlayerSeason(
	player_id		int,
	year			int,
	games_played		int check (games_played >= 0),
	salary			int check (salary > 0),
	primary key(player_id,year),
	foreign key(player_id) references Players(player_id),
	foreign key(year) references Seasons(year)
);
create table PitchingStats(
	player_id		int,
	year			int,
	outs_pitched	int check (outs_pitched >=0),
	earned_runs_allowed		int check (earned_runs_allowed >=0),
	strikeouts		int check (strikeouts >=0),
	walks			int check (walks >=0),
	wins			int check (wins >=0),
	losses			int check (losses >=0),
	wild_pitches	int check (wild_pitches >=0),
	batters_faced	int check (batters_faced >=0),
	hit_batters		int check (hit_batters >=0),
	saves			int check (saves >=0),
	primary key(player_id,year),
	foreign key(player_id) references Players(player_id),
	foreign key(year) references Seasons(year)
);
create table BattingStats(
	player_id		int,
	year			int,
	at_bats			int check (at_bats >=0),
	hits			int check (hits >=0),
	doubles			int check (doubles >=0),
	triples			int check (triples >=0),
	homeRuns		int check (homeRuns >=0),
	runs_batted_in	int check (runs_batted_in >=0),
	strikeouts		int check (strikeouts >=0),
	walks			int check (walks >=0),
	hit_by_pitch	int check (hit_by_pitch >=0),
	intentional_walks	int check (intentional_walks >=0),
	steals			int check (steals >=0),
	steals_attempted	int check (steals_attempted >=0),
	primary key(player_id,year),
	foreign key(player_id) references Players(player_id),
	foreign key(year) references Seasons(year)
);
create table CatchingStats(
	player_id		int,
	year			int,
	passed_balls	int  check (passed_balls >=0),
	wild_pitches	int check (wild_pitches >=0),
	steals_allowed	int check (steals_allowed >=0),
	steals_caught	int check (steals_caught >=0),
	primary key(player_id,year),
	
	foreign key(year) references Seasons(year)
);
create table TeamSeason(
	team_id			int,
	year			int,
	games_played	int check (games_played >=0),
	wins			int check (wins >=0),
	losses			int check (losses >=0),
	rank			int check (rank >=0),
	total_attendance	int check (total_attendance >=0),
	primary key(team_id,year),
	foreign key(team_id) references Teams(team_id),
	foreign key(year) references Seasons(year)
);
create table TeamSeasonPlayer(
	team_id		int,
	year		int,
	player_id	int,
	primary key(team_id,year,player_id),
	foreign key(player_id) references Players(player_id),
	foreign key(team_id) references Teams(team_id),
	foreign key(year) references Seasons(year)
);
GO
create FUNCTION ties(@team_id int,@year int)
returns int
AS
BEGIN
	DECLARE @ties int;
	Declare @win int;
	Declare @loss int;
	Select @ties = games_played, @win = wins, @loss = losses
	From TeamSeason as t
	Where t.team_id = @team_id AND t.year = @year;
	Set @ties = @ties - @win - @loss;
	RETURN @ties;
END;
GO