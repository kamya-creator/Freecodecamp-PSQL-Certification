#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE games, teams;")
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != year ]]
  then
    echo $YEAR
    Winner_id=$($PSQL "select team_id from teams where name='$WINNER';")
    if [[ -z $Winner_id ]]
    then
      echo "Inserting in teams table"
      Insert_Winner_Result=$($PSQL "insert into teams(name) values('$WINNER');")
      echo $Insert_Winner_Result
    fi

    Opponent_id=$($PSQL "select team_id from teams where name='$OPPONENT';")
    if [[ -z $Opponent_id ]]
    then
      echo "Inserting in teams table"
      Insert_Opponet_Result=$($PSQL "insert into teams(name) values('$OPPONENT');")
      echo $Insert_Opponet_Result
    fi


    # inserting into games table
    WINNER_ID=$($PSQL "select team_id from teams where name='$WINNER'")
    OPPONENT_ID=$($PSQL "select team_id from teams where name='$OPPONENT'")
    Insert_Games_Result=$($PSQL "insert into games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) 
    values($YEAR,'$ROUND',$WINNER_ID,'$OPPONENT_ID',$WINNER_GOALS,$OPPONENT_GOALS);")
    echo $Insert_Games_Result
  fi  
done

