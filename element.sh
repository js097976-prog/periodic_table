#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  # Determinar si el argumento es un número o texto
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    CONDITION="elements.atomic_number = $1"
  else
    CONDITION="symbol = '$1' OR name = '$1'"
  fi

  # Consulta SQL con JOINs
  DATA=$($PSQL "SELECT elements.atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE $CONDITION")

  if [[ -z $DATA ]]
  then
    echo "I could not find that element in the database."
  else
    # Procesar el resultado
    echo "$DATA" | while IFS="|" read ATOMIC_NUMBER NAME SYMBOL TYPE MASS MELT BOIL
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
    done
  fi
fi
# Final check
