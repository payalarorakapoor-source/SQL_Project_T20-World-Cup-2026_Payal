CREATE DATABASE T20WorldCup2026_final;
USE T20WorldCup2026_final;
show tables;

-- 1) Tournament
CREATE TABLE tournament(
  tournament_id INT AUTO_INCREMENT PRIMARY KEY,
  tournament_name VARCHAR(100) NOT NULL,
  tournament_year INT NOT NULL,
  host_country VARCHAR(100),
  start_date DATE,
  end_date DATE
 );

-- 2) Cricket Team 
CREATE TABLE cricketteams (
    team_id INT AUTO_INCREMENT PRIMARY KEY,
    team_name VARCHAR(100) ,
    short_name VARCHAR(10),
    country VARCHAR(100),
    country_code VARCHAR(10)null
 ) ENGINE=InnoDB;

-- 3) Venue
CREATE TABLE venue (
  venue_id INT AUTO_INCREMENT PRIMARY KEY,
  venue_name VARCHAR(150) NOT NULL,
  city VARCHAR(100),
  country VARCHAR(100)
  )ENGINE=InnoDB;
  
-- 4) Players
CREATE TABLE players (
  player_id INT AUTO_INCREMENT PRIMARY  KEY,
  player_name VARCHAR(150),
  team_id INT,
  full_name VARCHAR(150),
  batting_style VARCHAR(30),
  bowling_style VARCHAR(30),
  FOREIGN KEY (team_id) REFERENCES cricketteams(team_id)
 )ENGINE=InnoDB;
   
 -- 5) Matches
CREATE TABLE matches (
  match_id INT AUTO_INCREMENT PRIMARY KEY  not null,
  tournament_id INT  not null,
  match_no VARCHAR(20) not null,
  group_num VARCHAR(20) not null,
  match_date DATE  not null,
  venue varchar(100)  not null,
  venue_id INT not null,
  team1_id INT  not null,
  team2_id INT  not null,
  toss_winner_id INT  not null,
  winner_team_id INT  not null,
  win_by_runs INT  not null,
  win_by_wkts INT not null,
  player_of_match VARCHAR(150) not null,
  notes TEXT  not null,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
   FOREIGN KEY (tournament_id) REFERENCES tournament(tournament_id),
  FOREIGN KEY (venue_id) REFERENCES venue(venue_id),
  FOREIGN KEY (team1_id) REFERENCES cricketteams(team_id),
  FOREIGN KEY (team2_id) REFERENCES cricketteams(team_id),
  FOREIGN KEY (toss_winner_id) REFERENCES cricketteams(team_id),
  FOREIGN KEY (winner_team_id) REFERENCES cricketteams(team_id)
) ENGINE=InnoDB;
ALTER TABLE matches ADD COLUMN result VARCHAR(255);


CREATE TABLE officials (
  official_id INT PRIMARY KEY,
  name VARCHAR(150),
  role ENUM('umpire','tv_umpire','referee')
);

CREATE TABLE result_type (
  result_code VARCHAR(20) PRIMARY KEY,
  result_text VARCHAR(150)
);

-- 6) Innings summary
CREATE TABLE innings (
  innings_id INT auto_increment PRIMARY KEY,
  match_id INT,
  innings_no TINYINT,         
  batting_team_id INT,
  bowling_team_id INT ,
  runs INT ,
  wickets INT ,
  overs DECIMAL(4,1),  
  extras INT ,
  wides INT,
  no_balls INT ,
  byes INT ,
  leg_byes INT ,
  powerplay_runs INT,
  powerplay_overs DECIMAL(4,1),
  
  FOREIGN KEY (match_id) REFERENCES matches(match_id),
  FOREIGN KEY (batting_team_id) REFERENCES cricketteams(team_id),
  FOREIGN KEY (bowling_team_id) REFERENCES cricketteams(team_id)
) ENGINE=InnoDB;

-- 7) Player match stats (one row per player per match)
CREATE TABLE player_match_stats (
    stat_id INT ,
    match_id INT,
    player_id INT,
	team_id INT,
	runs_scored INT,
    balls_faced INT,
    fours INT,
    sixes INT,
    dismissal VARCHAR(200),
    strike_rate decimal(5,2),
    overs_bowled INT,
    balls_bowled INT,
    runs_conceded INT,
    wickets_taken INT,
    catches INT,
    runouts INT,
    stumpings INT,
    FOREIGN KEY (match_id)
        REFERENCES matches (match_id),
    FOREIGN KEY (player_id)
        REFERENCES players (player_id),
    FOREIGN KEY (team_id)
        REFERENCES cricketteams (team_id)
)  ENGINE=INNODB;
ALTER TABLE  player_match_stats ADD COLUMN  player_name varchar(100),ADD COLUMN team varchar(100),
  ADD COLUMN  matches INT, ADD COLUMN bowling_strike_rate decimal (4,2); 
ALTER TABLE player_match_stats
  DROP COLUMN dismissal,
  DROP COLUMN runs_conceded,
  DROP COLUMN catches,
  DROP COLUMN runouts,
  DROP COLUMN stumpings;
  ALTER TABLE player_match_stats MODIFY strike_rate  decimal (5,2);
  ALTER TABLE  player_match_stats ADD COLUMN bowling_strike_rate decimal (5,2); 
  describe player_match_stats;
  
  -- 1) TOURNAMENT
-- -----------------------
INSERT INTO tournament (tournament_id, tournament_name, tournament_year)
VALUES (1, "ICC Men's T20 World Cup", 2026);

select * from tournament;

-- 2) TEAMS
ALTER TABLE cricketteams MODIFY country_code VARCHAR(10) NULL;

-- -----------------------
--  Insert all 20 teams
INSERT INTO cricketteams (team_id, team_name, short_name, country)
VALUES
  (1, 'India', 'IND', 'India'),
  (2, 'Sri Lanka', 'SL', 'Sri Lanka'),
  (3, 'Afghanistan', 'AFG', 'Afghanistan'),
  (4, 'Australia', 'AUS', 'Australia'),
  (5, 'Bangladesh', 'BAN', 'Bangladesh'),
  (6, 'England', 'ENG', 'England'),
  (7, 'South Africa', 'SA', 'South Africa'),
  (8, 'USA', 'USA', 'USA'),
  (9, 'West Indies', 'WI', 'West Indies'),
  (10, 'Ireland', 'IRE', 'Ireland'),
  (11, 'New Zealand', 'NZ', 'New Zealand'),
  (12, 'Pakistan', 'PAK', 'Pakistan'),
  (13, 'Canada', 'CAN', 'Canada'),
  (14, 'Italy', 'ITA', 'Italy'),
  (15, 'Netherlands', 'NED', 'Netherlands'),
  (16, 'Namibia', 'NAM', 'Namibia'),
  (17, 'Zimbabwe', 'ZIM', 'Zimbabwe'),
  (18, 'Nepal', 'NEP', 'Nepal'),
  (19, 'Oman', 'OMA', 'Oman'),
  (20, 'United Arab Emirates', 'UAE', 'UAE');
-- View the data

SELECT * FROM cricketteams;
SELECT team_name, short_name FROM cricketteams;

-- 3) VENUES
-- -----------------------
INSERT INTO venue (venue_id, venue_name, city, country)
VALUES
  (1, 'Sinhalese Sports Club Ground', 'Colombo', 'Sri Lanka'),
  (2, 'R. Premadasa Stadium', 'Colombo', 'Sri Lanka'),
  (3, 'Pallekele International Cricket Stadium', 'Pallekele', 'Sri Lanka'),
  (4, 'Eden Gardens', 'Kolkata', 'India'),
  (5, 'Wankhede Stadium', 'Mumbai', 'India'),
  (6, 'MA Chidambaram Stadium', 'Chennai', 'India'),
  (7, 'Narendra Modi Stadium', 'Ahmedabad', 'India'),
  (8, 'Arun Jaitley Stadium', 'Delhi', 'India');
  
  select * from venue;
  SELECT venue_name, city FROM venue WHERE country = 'India';
  
  -- -----------------------
-- 4) PLAYERS (only those needed for Player of the Match)
-- -----------------------
ALTER TABLE players
DROP COLUMN full_name;

SHOW CREATE TABLE players;

-- India (team_id = 1)
INSERT INTO players (player_id, team_id, player_name)
VALUES
  (3, 1, 'Virat Kohli'),
  (4, 1, 'Rohit Sharma'),
  (5, 1, 'Suryakumar Yadav'),
  (6, 1, 'Hardik Pandya'),
  (8, 1, 'Ishan Kishan'),
  (7, 1, 'Jasprit Bumrah');

-- Pakistan (team_id = 12)
INSERT INTO players (player_id, team_id, player_name)
VALUES
  (13, 12, 'Babar Azam'),
  (9, 12, 'Shaheen Afridi'),
  (10, 12, 'Shadab Khan'),
  (11, 12, 'Mohammad Rizwan'),
  (12, 12, 'Fakhar Zaman');

-- West Indies (team_id = 9)
INSERT INTO players (player_id, team_id, player_name)
VALUES
  (18, 9, 'Nicholas Pooran'),
  (14, 9, 'Andre Russell'),
  (15, 9, 'Jason Holder'),
  (16, 9, 'Shimron Hetmyer'),
  (17, 9, 'Brandon King');

-- Australia (team_id = 4)
INSERT INTO players (player_id, team_id, player_name)
VALUES
  (23, 4, 'David Warner'),
  (19, 4, 'Glenn Maxwell'),
  (20, 4, 'Pat Cummins'),
  (21, 4, 'Mitchell Marsh'),
  (22, 4, 'Josh Hazlewood');

-- England (team_id = 6)
INSERT INTO players (player_id, team_id, player_name)
VALUES
  (28, 6, 'Jos Buttler'),
  (24, 6, 'Ben Stokes'),
  (25, 6, 'Jofra Archer'),
  (26, 6, 'Harry Brook'),
  (27, 6, 'Moeen Ali');
  
  INSERT INTO players (player_id, player_name, team_id)
VALUES (101, 'Sahibzada Farhan', 5),
       (102, 'Sanju Samson', 1),
       (103, 'Jasprit Bumrah', 1),
       (104, 'Tim Seifert', 2),
       (105, 'Varun Chakaravarthy', 1);

SELECT player_id, player_name FROM players;
   
  -- 5) MATCHES
  
  describe matches;
  INSERT INTO matches
(
  match_id, tournament_id, match_no, group_num,
  match_date, venue_id,
  team1_id, team2_id,
  toss_winner_id, 
  winner_team_id,
  win_by_runs, win_by_wkts, player_of_match,
  notes, updated_at
)
VALUES
  (1, 1, 'Match 1', 'Group A', '2026-02-07', 1, 12, 15, 12, 12, 25, NULL, 'Babar Azam', 'Opening game', CURRENT_TIMESTAMP),
  (2, 1, 'Match 2', 'Group A', '2026-02-08', 4, 1, 6, 1, 1, NULL, 5, 'Virat Kohli', 'India vs England', CURRENT_TIMESTAMP),
  (3, 1, 'Match 3', 'Group B', '2026-02-09', 5, 4, 9, 9, 9, NULL, 3, 'Nicholas Pooran', 'West Indies fixture', CURRENT_TIMESTAMP),
  (4, 1, 'Match 4', 'Group B', '2026-02-10', 2, 2, 11, 11, 11, 40, NULL, 'Kane Williamson', 'Sri Lanka vs NZ', CURRENT_TIMESTAMP),
  (5, 1, 'Match 5', 'Group C', '2026-02-11', 7, 6, 7, 6, 6, NULL, 7, 'Jos Buttler', 'England group match', CURRENT_TIMESTAMP),
  (6, 1, 'Match 6', 'Group C', '2026-02-12', 3, 8, 3, 8, 8, 15, NULL, 'Aaron Jones', 'USA vs Bangladesh', CURRENT_TIMESTAMP),
  (7, 1, 'Match 7', 'Group D', '2026-02-13', 6, 13, 14, 13, 13, NULL, 6, 'Mohammad Rizwan', 'Pakistan group match', CURRENT_TIMESTAMP),
  (8, 1, 'Match 8', 'Group D', '2026-02-14', 5, 16, 17, 16, 17, 10, NULL, 'Sikandar Raza', 'Zimbabwe fixture', CURRENT_TIMESTAMP),
  (9, 1, 'Match 9', 'Group E', '2026-02-15', 4, 18, 19, 18, 18, NULL, 4, 'Paras Khadka', 'Nepal debut match', CURRENT_TIMESTAMP),
  (10, 1, 'Match 10', 'Group E', '2026-02-16', 7, 20, 2, 20, 2, 30, NULL, 'Kusal Mendis', 'Sri Lanka fixture', CURRENT_TIMESTAMP);
  
  select player_of_match from matches;
  

INSERT INTO matches (match_id, match_date, venue, team1_id, team2_id, winner_team_id, result)
VALUES
(101, '2026-06-01', 'Delhi', 1, 2, 1, 'India won by 5 wickets'),
(102, '2026-06-02', 'Mumbai', 3, 4, 3, 'Australia won by 20 runs'),
(103, '2026-06-03', 'Chennai', 5, 6, 5, 'Pakistan won by 7 wickets'),
(104, '2026-06-04', 'Kolkata', 7, 8, 7, 'South Africa won by 3 wickets'),
(105, '2026-06-05', 'Bangalore', 9, 10, 9, 'New Zealand won by 15 runs'),
(106, '2026-06-06', 'Hyderabad', 11, 12, 11, 'Sri Lanka won by 4 wickets');

SELECT match_no, match_date, player_of_match, notes
FROM matches;

SELECT 
    m.match_no,
    m.match_date,
    v.venue_name,
    t1.team_name AS team1,
    t2.team_name AS team2,
    tw.team_name AS toss_winner,
    wt.team_name AS match_winner,
    m.win_by_runs,
    m.win_by_wkts,
    m.player_of_match,
    m.notes,
    m.updated_at
FROM matches m
JOIN venue v 
    ON m.venue_id = v.venue_id
JOIN cricketteams t1 
    ON m.team1_id = t1.team_id
JOIN cricketteams t2 
    ON m.team2_id = t2.team_id
LEFT JOIN cricketteams tw 
    ON m.toss_winner_id = tw.team_id
LEFT JOIN cricketteams wt 
    ON m.winner_team_id = wt.team_id
ORDER BY m.match_date ASC;

---------------------------
ALTER TABLE innings
  DROP COLUMN extras,
  DROP COLUMN no_balls,
  DROP COLUMN byes,
  DROP COLUMN leg_byes,
  DROP COLUMN powerplay_runs,
  DROP COLUMN powerplay_overs;
  
ALTER TABLE innings DROP COLUMN extras;
ALTER TABLE innings DROP COLUMN leg_byes;
describe innings;

-- -----------------------
-- Match 1 innings: NED 147 all out (19.5), PAK 148/7 (19.3), target 148

INSERT INTO innings
(
  innings_id, match_id, innings_no,
  batting_team_id, bowling_team_id,
  runs, wickets, overs
)
VALUES
  (1, 1, 1, 1, 2, 180, 5, 20.0),
  (2, 1, 2, 2, 1, 160, 8, 20.0),
  (3, 2, 1, 3, 4, 200, 4, 19.5),
  (4, 2, 2, 4, 3, 175, 9, 20.0);

describe player_match_stats;

SELECT player_id, player_name FROM players;

INSERT INTO player_match_stats (player_name, team, matches, runs_scored) VALUES
('Sahibzada Farhan', 'Pakistan', 7, 383),
('Tim Seifert', 'New Zealand', 9, 326),
('Sanju Samson', 'India', 5, 321),
('Ishan Kishan', 'India', 9, 317),
('Finn Allen', 'New Zealand', 9, 298);

-- Top run scorer across the series
SELECT distinct player_name, team, runs_scored
FROM player_match_stats
ORDER BY runs_scored DESC
LIMIT 5;


describe player_match_stats;

-- Best strike rate (average across matches):
-- Insert Top 5 Batting SR Data
INSERT INTO player_match_stats (player_name, team, runs_scored, balls_faced, strike_rate) VALUES
('Finn Allen', 'New Zealand', 298, 149, 200.00),
('Sanju Samson', 'India', 321, 161, 199.37),
('Mitchell Marsh', 'Australia', 118, 60, 196.66),
('Ishan Kishan', 'India', 317, 164, 193.29),
('Shimron Hetmyer', 'West Indies', 248, 133, 186.46);

 -- SELECT QUERY: Top 5 Batting Strike Rates
SELECT distinct player_name, team, runs_scored, strike_rate
FROM player_match_stats
ORDER BY strike_rate DESC
LIMIT 5;
-- Insert Top 5 Bowling SR Data
INSERT INTO player_match_stats (player_name, team, overs_bowled, wickets_taken, bowling_strike_rate) VALUES
('Shadley van Schalkwyk', 'USA', 14.5, 13, 6.85),
('Josh Little', 'Ireland', 4.0, 3, 8.00),
('Wanindu Hasaranga', 'Sri Lanka', 4.0, 3, 8.00),
('Mohammed Siraj', 'India', 4.0, 3, 8.00),
('Romario Shepherd', 'West Indies', 8.2, 6, 8.33);



-- SELECT QUERY: Top 5 Bowling Strike Rates (Lowest is best)
SELECT player_name, team, wickets_taken, bowling_strike_rate
FROM player_match_stats
ORDER BY bowling_strike_rate desc
LIMIT 5;

-- Top wicket taker:
INSERT INTO player_match_stats (player_name, team, matches, wickets_taken) VALUES
('Jasprit Bumrah', 'India', 8, 14),
('Varun Chakravarthy', 'India', 9, 14),
('Blessing Muzarabani', 'Zimbabwe', 6, 13),
('Adil Rashid', 'England', 8, 13),
('Shadley van Schalkwyk', 'USA', 4, 13);

-- Select the top 5 wicket-takers

SELECT distinct player_name, team, matches, wickets_taken
FROM player_match_stats
ORDER BY wickets_taken desc
LIMIT 5;

commit;









  



 

