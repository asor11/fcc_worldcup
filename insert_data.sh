#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE teams,games")
cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WIN_G OPP_G 
do
if [[ $YEAR != "year" ]]
then
W_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
O_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
if [[ -z $W_ID ]]
then
INS_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
W_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
fi
if [[ -z $O_ID ]]
then
INS_OPP=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
O_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
fi
GAMES_IN=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$W_ID,$O_ID,$WIN_G,$OPP_G)")
fi
done

echo $($PSQL "SELECT * FROM teams")
echo $($PSQL "SELECT * FROM games")
