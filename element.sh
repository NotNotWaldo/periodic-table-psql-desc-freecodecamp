#! /bin/bash

PSQL="psql -X --username=freecodecamp --tuples-only --dbname=periodic_table -c"

#echo "$($PSQL "SELECT * FROM elements WHERE symbol='$1'")"

ELEM_PREV() {
  echo "$1" | while read ATOM_NUM BAR SYM BAR NAME BAR ATOM_MASS BAR MELT_POINT BAR BOIL_POINT BAR TYPE
  do
    #echo "$ATOM_NUM - $SYM - $NAME - $ATOM_MASS - $MELT_POINT - $BOIL_POINT - $TYPE"
    echo "The element with atomic number $ATOM_NUM is $NAME ($SYM). It's a $TYPE, with a mass of $ATOM_MASS amu. $NAME has a melting point of $MELT_POINT celsius and a boiling point of $BOIL_POINT celsius."
  done
}

if [[ ! $1 ]]
then 
  echo "Please provide an element as an argument."
elif [[ $1 =~ ^[0-9]+$ ]]
  then
  ELEM_RES=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE atomic_number=$1")
  if [[ -z $ELEM_RES ]] 
    then
    echo "I could not find that element in the database."
  else
    ELEM_PREV "$ELEM_RES"
  fi
elif [[ $1 =~ ^[a-zA-Z]+$ ]]
  then 
  SYM_RES=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE symbol='$1'")
  NAME_RES=$($PSQL "SELECT atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM elements FULL JOIN properties USING(atomic_number) FULL JOIN types USING(type_id) WHERE name='$1'")
  if [[ ! -z $SYM_RES ]]
    then
    ELEM_PREV "$SYM_RES"
  elif [[ ! -z $NAME_RES ]]
  then 
    ELEM_PREV "$NAME_RES"
  else
  echo "I could not find that element in the database."
  fi
fi

