#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ $1 ]]
then
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    DOES_ELEMENT_EXIST=$($PSQL "SELECT * FROM elements WHERE atomic_number=$1")
    if [[ ! -z $DOES_ELEMENT_EXIST ]]
    then
      echo $($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number=$1") | while IFS="|" read N S FULL METAL MASS MELT BOIL
      do
        echo "The element with atomic number $N is $FULL ($S). It's a $METAL, with a mass of $MASS amu. $FULL has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
      done
    fi
  else
    DOES_SYMBOL_EXIST=$($PSQL "SELECT * FROM elements WHERE symbol='$1'")
    DOES_NAME_EXIST=$($PSQL "SELECT * FROM elements WHERE name='$1'")
    if [[ ! -z $DOES_SYMBOL_EXIST ]]
    then
      echo $($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE symbol='$1'") | while IFS="|" read N S FULL METAL MASS MELT BOIL
      do
        echo "The element with atomic number $N is $FULL ($S). It's a $METAL, with a mass of $MASS amu. $FULL has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
      done
    else
      if [[ ! -z $DOES_NAME_EXIST ]]
      then
        echo $($PSQL "SELECT atomic_number, symbol, name, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements INNER JOIN properties USING(atomic_number) INNER JOIN types USING(type_id) WHERE name='$1'") | while IFS="|" read N S FULL METAL MASS MELT BOIL
        do
          echo "The element with atomic number $N is $FULL ($S). It's a $METAL, with a mass of $MASS amu. $FULL has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
        done
      else
        echo "I could not find that element in the database."
      fi
    fi
  fi
else
  echo "Please provide an element as an argument."
fi
