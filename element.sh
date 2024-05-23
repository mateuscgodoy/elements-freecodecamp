PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else
  # if it is a number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    RESULT=$($PSQL "SELECT elements.atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type 
                        FROM elements 
                        INNER JOIN properties USING (atomic_number) 
                        INNER JOIN types USING (type_id) 
                        WHERE atomic_number=$1;")

  else
    # if it is a symbol
    if [[ $1 =~ ^[A-Z][a-z]?$ ]]
    then
      RESULT=$($PSQL "SELECT elements.atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type 
                        FROM elements 
                        INNER JOIN properties USING (atomic_number) 
                        INNER JOIN types USING (type_id) 
                        WHERE symbol='$1';")
    else
      # it can only be a name now
      RESULT=$($PSQL "SELECT elements.atomic_number, symbol, name, atomic_mass, melting_point_celsius, boiling_point_celsius, type 
                        FROM elements 
                        INNER JOIN properties USING (atomic_number) 
                        INNER JOIN types USING (type_id) 
                        WHERE name='$1';")
    fi
  fi

  if [[ -z $RESULT ]]
  then
    echo "I could not find that element in the database."
  else
    IFS='|' read -r ATOMIC_NUMBER SYMBOL NAME ATOMIC_MASS MELTING BOILING TYPE <<< "$RESULT"
    echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."    
  fi
fi
