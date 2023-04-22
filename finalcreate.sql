CREATE TABLE PLAYER(
	playerID int PRIMARY KEY ,
	surname varchar(20) CHECK(surname NOT LIKE '%[^A-Z]%') NOT NULL,
	firstname varchar(20) CHECK(firstname NOT LIKE '%[^A-Z]%') NOT NULL,
	position varchar(20) CHECK(position NOT LIKE '%[^A-Z]%'),
	day_birth date CHECK(day_birth BETWEEN '1900-01-01' AND CAST(GETDATE() as date)),
	phone_no varchar(9) CHECK(phone_no LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]')
);

CREATE TABLE EDITION(
	years int CHECK(years >= 2020),
	number int CHECK(number > 0),
	total_fans int CHECK(total_fans > 0) ,
	goals int CHECK(goals >= 0),
	PRIMARY KEY (years, number)
);

CREATE TABLE STADIUM(
	stadiumID int PRIMARY KEY ,
	city varchar(30) CHECK(city NOT LIKE '%[^A-Z]%'),
	building_no int CHECK(building_no > 0),
	postcode varchar(6) CHECK(postcode LIKE '[0-9][0-9]-[0-9][0-9][0-9]'),
	capacity int CHECK(capacity > 0)
);

CREATE TABLE REFEREE(
	refereeID int PRIMARY KEY,
	refname varchar(20) CHECK(refname NOT LIKE '%[^A-Z]%') NOT NULL,
	firstname varchar(20) CHECK(firstname NOT LIKE '%[^A-Z]%') NOT NULL,
	since_year varchar(4) CHECK(since_year <= YEAR(CAST(GETDATE() as DATE))),
	email varchar(50) CHECK(email LIKE '%_@__%.__%') ,
	phone varchar(9) CHECK(phone LIKE '[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]') ,
);

CREATE TABLE TEAM(
	team_name varchar(20)  CHECK(team_name NOT LIKE '%[^A-Z]%') PRIMARY KEY,
	no_of_players int CHECK(no_of_players >= 0 AND no_of_players <= 20) NOT NULL,
	shortcut varchar(3) CHECK(shortcut LIKE '[A-Z][A-Z][A-Z]') NOT NULL,
	email varchar(50) CHECK(email LIKE '%_@__%.__%'),
);

CREATE TABLE STANDING(
	standingID int PRIMARY KEY,
	place int CHECK(place > 0) NOT NULL,
	points int CHECK(points > 0) NOT NULL,
	goals_scored int CHECK(goals_scored >= 0),
	goals_lost int CHECK(goals_lost >= 0),
	advantage int CHECK(advantage >= 0),
	loss int CHECK(loss >= 0),
	t varchar(20) REFERENCES TEAM ON DELETE SET NULL,
	years int,
	number int,
	FOREIGN KEY(years, number) REFERENCES EDITION(years, number) ON DELETE CASCADE
);

CREATE TABLE BELONGING(
	belongingID int PRIMARY KEY,
	no_of_goals int CHECK(no_of_goals >= 0),
	no_of_assists int CHECK(no_of_assists >= 0),
	since date CHECK(since BETWEEN '2020-01-01' AND CAST(GETDATE() as date)),
	finished date CHECK(finished BETWEEN '2020-01-01' AND CAST(GETDATE() as date)),
	squad varchar(20) REFERENCES TEAM ON DELETE SET NULL,
	player int REFERENCES PLAYER ON DELETE SET NULL
);

CREATE TABLE MATCH(
	matchID int PRIMARY KEY,
	fans int CHECK(fans >= 0),
	t1_goals int CHECK(t1_goals >= 0) NOT NULL,
	t2_goals int CHECK(t2_goals >= 0) NOT NULL,
	matchday date CHECK(matchday BETWEEN '2020-01-01' AND CAST(GETDATE() as date)),
	t1 varchar(20) REFERENCES TEAM ON DELETE SET NULL,
	t2 varchar(20) REFERENCES TEAM ON DELETE NO ACTION,
	edity int,
	editn int,
	arbiter int REFERENCES REFEREE ON DELETE SET NULL,
	stad int REFERENCES STADIUM ON DELETE SET NULL,
	FOREIGN KEY(edity, editn) REFERENCES EDITION(years, number) ON DELETE CASCADE
);

CREATE TABLE GOAL(
	goal_no int CHECK(goal_no > 0),
	body_part varchar(20) CHECK(body_part NOT LIKE '%[^A-Z]%') ,
	game int REFERENCES MATCH ON DELETE CASCADE,
	assistant int REFERENCES PLAYER ON DELETE SET NULL,
	scorer int REFERENCES PLAYER ON DELETE NO ACTION,
	PRIMARY KEY(goal_no, game)
);

CREATE TABLE PLAYING(
	minutes_played int CHECK(minutes_played >= 0),
	no_of_goals int CHECK(no_of_goals >= 0),
	no_of_assists int CHECK(no_of_assists >= 0),
	yellow int,
	red bit,
	game int REFERENCES MATCH ON DELETE CASCADE,
	footballer int REFERENCES PLAYER ON DELETE CASCADE,
	PRIMARY KEY(game, footballer)
);

CREATE TABLE CONTAIN(
	arbiter int REFERENCES REFEREE ON DELETE CASCADE,
	edity int ,
	editn int,
	FOREIGN KEY(edity, editn) REFERENCES EDITION(years, number) ON DELETE CASCADE,
	PRIMARY KEY(arbiter, edity, editn)
);

CREATE TABLE PARTICIPATION(
	edity int,
	editn int,
	FOREIGN KEY(edity, editn) REFERENCES EDITION(years, number) ON DELETE CASCADE,
	squad varchar(20) REFERENCES TEAM ON DELETE CASCADE,
	PRIMARY KEY(squad, edity, editn)
);
