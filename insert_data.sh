#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo "$($PSQL "TRUNCATE TABLE games, teams")"

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  #Skip the first line
  if [[ $WINNER != "winner" ]]
  then
    #get team_id
    WINNER_ID="$($PSQL "SELECT team_id FROM TEAMS WHERE name = '$WINNER'")"

    #if not found
    if [[ -z $WINNER_ID ]]
    then
      #insert the team
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      echo $INSERT_WINNER_RESULT

      #get the WINNER team_id
      WINNER_ID="$($PSQL "SELECT team_id FROM TEAMS WHERE name = '$WINNER'")"
    fi

    #get team_id
    OPPONENT_ID="$($PSQL "SELECT team_id FROM TEAMS WHERE name = '$OPPONENT'")"

    #if not found
    if [[ -z $OPPONENT_ID ]]
    then
      #insert the team
      INSERT_OPPONENT_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      echo $INSERT_OPPONENT_RESULT

      #get the OPPONENT team_id
      OPPONENT_ID="$($PSQL "SELECT team_id FROM TEAMS WHERE name = '$OPPONENT'")"
    fi
  fi
done

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  #Skip the first line
  if [[ $WINNER != "winner" ]]
  then
    #get Winner team_id
    WINNER_ID="$($PSQL "SELECT team_id FROM TEAMS WHERE name = '$WINNER'")"

    #get opponent team_id
    OPPONENT_ID="$($PSQL "SELECT team_id FROM TEAMS WHERE name = '$OPPONENT'")"
    
    #get game_id
    GAME_ID=$($PSQL "SELECT game_id FROM games WHERE winner_id=$WINNER_ID AND opponent_id=$OPPONENT_ID")

    #if not found
    if [[ -z $GAME_ID ]]
    then
      #insert the game
      INSERT_GAME_RESULT="$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")"
      echo $INSERT_GAME_RESULT   

    fi
  fi
done
