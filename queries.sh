#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=worldcup --no-align --tuples-only -c"

# Do not change code above this line. Use the PSQL variable above to query your database.

echo -e "\nTotal number of goals in all games from winning teams:"
echo "$($PSQL "SELECT SUM(winner_goals) FROM games")"

echo -e "\nTotal number of goals in all games from both teams combined:"
echo "$($PSQL "SELECT SUM(winner_goals) + SUM(opponent_goals) FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams:"
echo "$($PSQL "SELECT AVG(winner_goals) FROM games")"

echo -e "\nAverage number of goals in all games from the winning teams rounded to two decimal places:"
echo "$($PSQL "SELECT ROUND(AVG(winner_goals), 2) FROM games")"

echo -e "\nAverage number of goals in all games from both teams:"
echo  "$($PSQL "SELECT (AVG(winner_goals + opponent_goals)) FROM games")"

echo -e "\nMost goals scored in a single game by one team:"
echo "$($PSQL "SELECT MAX(winner_goals) FROM games")"

echo -e "\nNumber of games where the winning team scored more than two goals:"
echo "$($PSQL "SELECT COUNT(*) FROM games WHERE winner_goals>2")"

echo -e "\nWinner of the 2018 tournament team name:"
echo "$($PSQL "SELECT name FROM teams 
               LEFT JOIN games
               ON teams.team_id=games.winner_id
               WHERE year=2018 AND round='Final'
               ")"

echo -e "\nList of teams who played in the 2014 'Eighth-Final' round:"
# echo "$($PSQL "SELECT t1.name AS team_names FROM games
#                RIGHT JOIN teams as t1 ON t1.team_id=games.winner_id
#                WHERE year=2014 and round='Eighth-Final'
#                UNION
#                SELECT t2.name AS team_names FROM games
#                RIGHT JOIN teams as t2 ON t2.team_id=games.opponent_id
#                WHERE year=2014 and round='Eighth-Final'
#                ORDER BY team_names ASC
#                ")"
# echo "$($PSQL "SELECT name FROM teams
#                LEFT JOIN games ON teams.team_id=games.winner_id
#                WHERE year=2014 and round='Eighth-Final'
#                UNION
#                SELECT name FROM teams
#                LEFT JOIN games ON teams.team_id=games.opponent_id
#                WHERE year=2014 and round='Eighth-Final'
#                ORDER BY name ASC
#                ")"
echo "$($PSQL "SELECT DISTINCT name FROM teams
               LEFT JOIN games g1 ON teams.team_id=g1.winner_id
               LEFT JOIN games g2 ON teams.team_id=g2.opponent_id
               WHERE g1.year=2014 AND g1.round='Eighth-Final'
                  OR g2.year=2014 AND g2.round='Eighth-Final' 
               ORDER BY name ASC
               ")"

echo -e "\nList of unique winning team names in the whole data set:"
echo "$($PSQL "SELECT DISTINCT name FROM teams
               RIGHT JOIN games ON teams.team_id=games.winner_id
               ORDER BY name ASC
               ")"

echo -e "\nYear and team name of all the champions:"
echo "$($PSQL "SELECT year, name FROM teams
               RIGHT JOIN games ON teams.team_id=games.winner_id
               WHERE round='Final'
               ORDER BY year ASC
               ")"

echo -e "\nList of teams that start with 'Co':"
echo "$($PSQL "SELECT name FROM teams
               WHERE name LIKE 'Co%'
               ORDER BY name ASC
               ")"
