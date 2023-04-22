--1 Show all the players and teams that they belong to
CREATE VIEW footballers AS 
SELECT PLAYER.firstname, PLAYER.surname AS , PLAYER.position, TEAM.team_name
FROM PLAYER
	JOIN BELONGING ON BELONGING.player = PLAYER.playerID
	JOIN TEAM ON TEAM.team_name = BELONGING.squad;
SELECT * FROM footballers
DROP VIEW footballers

----2 In how many matches footballer scored above 1 goal and his firstname consist 'a'?

--SELECT COUNT(*) AS 'NO OF MATCHES'
--FROM PLAYER
--	JOIN PLAYING ON PLAYING.footballer = PLAYER.playerID
--	WHERE PLAYING.no_of_goals > 1 AND PLAYER.firstname LIKE '%a%';

----3 Which teams consist of at least 15 players?

--SELECT TEAM.shortcut
--FROM TEAM
--	JOIN STANDING ON STANDING.t	= TEAM.team_name
--	WHERE STANDING.goals_scored > STANDING.goals_lost AND TEAM.no_of_players >= 15;

--1 Which team scored the most goals and which place it got in 2022 ?

SELECT STANDING.place, TEAM.team_name
FROM STANDING
	JOIN TEAM ON TEAM.team_name = STANDING.t
	JOIN EDITION ON EDITION.years = STANDING.years AND EDITION.number = STANDING.number
	WHERE EDITION.years = 2022  AND  STANDING.goals_scored = 
	(SELECT MAX(STANDING.goals_scored) FROM STANDING);


--2 Referee with most matches refereed?

SELECT REFEREE.firstname, REFEREE.refname
FROM REFEREE 
	JOIN (SELECT TOP 1 COUNT(*) AS 'no', refereeID
	FROM REFEREE
		JOIN MATCH ON MATCH.arbiter = REFEREE.refereeID
		GROUP BY REFEREE.refereeID
		ORDER BY no DESC) subquery ON subquery.refereeID = REFEREE.refereeID;

		SELECT TOP 1 REFEREE.firstname, REFEREE.refname, refereeID
	FROM REFEREE
		JOIN MATCH ON MATCH.arbiter = REFEREE.refereeID
		GROUP BY REFEREE.refereeID
		ORDER BY no DESC
--3 Which player scored the most in one match?

SELECT TOP 1 PLAYER.firstname, PLAYER.surname, PLAYING.no_of_goals AS 'no'
FROM PLAYER
	JOIN PLAYING ON PLAYING.footballer = PLAYER.playerID
	ORDER BY no DESC

--4 What is the total number of goals scored by players who were born in the month of October?

SELECT SUM(PLAYING.no_of_goals) AS 'TOTAL'
FROM PLAYER
	JOIN PLAYING ON PLAYING.footballer = PLAYER.playerID
	WHERE PLAYER.day_birth LIKE '%-10-%'

--5 What is the average number of goals scored by teams in each year from the latest year?

SELECT AVG(STANDING.goals_scored) AS 'AVERAGE', EDITION.years AS 'YEAR', EDITION.number
FROM STANDING
	JOIN EDITION ON EDITION.years = STANDING.years AND EDITION.number = STANDING.number
	GROUP BY EDITION.years, EDITION.number
	ORDER BY YEAR DESC

--6 What are the names of players who have scored more than 1 goals and have less than 3 
--  assists in the 2022 and play in the position of "Midfielder"?

SELECT PLAYER.firstname,SUM(PLAYING.no_of_goals)
AS 'SUM GOALS', SUM(PLAYING.no_of_assists) AS 'SUM ASSIST' FROM PLAYER
	JOIN PLAYING ON PLAYING.footballer = PLAYER.playerID
	JOIN MATCH ON MATCH.matchID = PLAYING.game
	WHERE PLAYER.position = 'Midfielder'AND MATCH.edity = 2022
	GROUP BY PLAYER.firstname
	HAVING SUM(PLAYING.no_of_goals) > 1 AND SUM(PLAYING.no_of_assists) < 3;

--7 Retrieve the names of the players who play in the STRIKER position
--and have played less than 50 matches in the current league edition.
SELECT firstname, COUNT(*) AS 'NO OF MATCHES'
FROM PLAYER
	JOIN PLAYING ON PLAYING.footballer = PLAYER.playerID
	WHERE PLAYER.position = 'Striker'
	GROUP BY PLAYER.firstname

--8 Group referees by total sum of yellow cards in descending order

SELECT SUM(PLAYING.yellow) AS 'TOTAL YELLOW', REFEREE.refname 
FROM PLAYING
	JOIN MATCH ON MATCH.matchID = PLAYING.game
	JOIN REFEREE ON REFEREE.refereeID = MATCH.arbiter
	GROUP BY REFEREE.refname
	ORDER BY 'TOTAL YELLOW' DESC
	
--9 Which referee and how many matches lead where Messi was given yellow card? 
SELECT REFEREE.firstname AS 'REF SURNAME', COUNT (*) AS 'NO OF MATCHES'
FROM REFEREE
JOIN MATCH ON MATCH.arbiter = REFEREE.refereeID
JOIN PLAYING ON PLAYING.game = MATCH.matchID
JOIN PLAYER ON PLAYER.playerID = PLAYING.footballer
WHERE PLAYING.yellow = '1' AND PLAYER.firstname = 'Messi'
GROUP BY REFEREE.firstname, REFEREE.refname

--10 What was the average number of advantage during particular editions in 2020?
SELECT	EDITION.years, EDITION.number ,AVG(STANDING.advantage) AS 'Average'
FROM EDITION
JOIN STANDING ON STANDING.years = EDITION.years AND STANDING.number = EDITION.number
JOIN TEAM ON TEAM.team_name = STANDING.t
WHERE EDITION.years = 2020
GROUP BY EDITION.years, EDITION.number
