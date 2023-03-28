#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# is there a way to check what the datatype is?

# nested if statements — first if running script without argument
if [[ -z $1 ]]
then
  # echo "Please provide an element as an argument."
  echo "Please provide an element as an argument."

else

  # first, see if argument is either a symbol or name, case irrespective
  ARGUMENT_LOOKUP_CHAR=$($PSQL "SELECT * FROM elements WHERE name ILIKE('$1') OR symbol ILIKE('$1')")

  #if successful, then read atomic_number, otherwise, see if argument is atomic_number
  if [[ ! -z $ARGUMENT_LOOKUP_CHAR ]]
  then
    # argument lookup atomic number
    LOOKUP_ATOM_NUM=$($PSQL "SELECT atomic_number FROM elements WHERE name ILIKE('$1') OR symbol ILIKE('$1')")
   # test:  echo $LOOKUP_ATOM_NUM
  else
    # see if argument is atomic number
    LOOKUP_ATOM_NUM=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number='$1'")
    # test: echo $LOOKUP_ATOM_NUM
  fi
    # if we do not derive an atomic_number from this argument, we will print the error message. else, we will print the script
  if [[ -z $LOOKUP_ATOM_NUM ]]
  then
    echo "I could not find that element in the database."
  else
    # already have atomic_number
    # lookup element name
    ELEMENT_NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number='$LOOKUP_ATOM_NUM'")
    # test: echo $ELEMENT_NAME

    # lookup element symbol
    ELEMENT_SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number='$LOOKUP_ATOM_NUM'")
    # test: echo $ELEMENT_SYMBOL

    # lookup element type
    ELEMENT_TYPE=$($PSQL "SELECT type FROM properties INNER JOIN types USING(type_id) WHERE atomic_number='$LOOKUP_ATOM_NUM'")
    # test: echo $ELEMENT_TYPE

    # lookup element melting point
    ELEMENT_MELT_PT=$($PSQL "SELECT melting_point_celsius FROM properties WHERE atomic_number='$LOOKUP_ATOM_NUM'")
    # test: echo $ELEMENT_MELT_PT degrees celsius

    # lookup element boiling point
    ELEMENT_BOIL_PT=$($PSQL "SELECT boiling_point_celsius FROM properties WHERE atomic_number='$LOOKUP_ATOM_NUM'")
    # test: echo $ELEMENT_BOIL_PT degrees celsius

    # lookup element mass
    ELEMENT_MASS=$($PSQL "SELECT atomic_mass FROM properties WHERE atomic_number='$LOOKUP_ATOM_NUM'")
    # test: echo $ELEMENT_MASS amu

    # echo output text
    echo "The element with atomic number $LOOKUP_ATOM_NUM is $ELEMENT_NAME ($ELEMENT_SYMBOL). It's a $ELEMENT_TYPE, with a mass of $ELEMENT_MASS amu. $ELEMENT_NAME has a melting point of $ELEMENT_MELT_PT celsius and a boiling point of $ELEMENT_BOIL_PT celsius."
  fi

  
fi
