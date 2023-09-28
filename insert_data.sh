#!/bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
TRUNCATE=$($PSQL "TRUNCATE games, teams")
RESTART_SERIES_GAME_ID=$($PSQL "ALTER SEQUENCE games_game_id_seq RESTART WITH 1")
RESTART_SERIES_TEAM_ID=$($PSQL "ALTER SEQUENCE teams_team_id_seq RESTART WITH 1")

cat games.csv | while IFS="," read YEAR ROUND TEAM_WIN TEAM_OPP GOAL_WIN GOAL_OPP
do
  

  # Do not do anything for the row headers
  if [[ $YEAR == "year" ]]
  then
    continue
  fi
  


  # Get team_id of TEAM_WIN to check if it is already in the `teams` table
  TEAM_WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$TEAM_WIN'")
  
  # Inserting values from TEAM_WIN to the `teams` table
  if [[ -z $TEAM_WIN_ID ]]
  then
    INSERT_TEAM_WIN=$($PSQL "INSERT INTO teams(name) VALUES('$TEAM_WIN')")
    if [[ $INSERT_TEAM_WIN == "INSERT 0 1" ]]
    then
      TEAM_WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$TEAM_WIN'")
      echo Inserted into winning teams, $TEAM_WIN
    fi
  fi
  


  # Get team_id of TEAM_OPP to check if it is already in the `teams` table
  TEAM_OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$TEAM_OPP'")

  # Inserting values from TEAM_OPP to the `teams` table
  if [[ -z $TEAM_OPP_ID ]]
  then
    INSERT_TEAM_OPP=$($PSQL "INSERT INTO teams(name) VALUES('$TEAM_OPP')")
    if [[ $INSERT_TEAM_OPP == "INSERT 0 1" ]]
    then
      TEAM_OPP_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$TEAM_OPP'")
      echo Inserted into opposing teams, $TEAM_OPP
    fi
  fi
    
  

  # Insert year, round, winner_id, opponent_id, winner_goals, and opponent_goals to the `games` table
  INSERT_YEAR=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals)
                       VALUES($YEAR, '$ROUND', $TEAM_WIN_ID, $TEAM_OPP_ID, $GOAL_WIN, $GOAL_OPP)")
  echo Inserted a game into games from $YEAR, $ROUND, $TEAM_WIN, $TEAM_OPP
  
done
