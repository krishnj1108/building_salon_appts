#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

MAIN_MENU() {
  echo "How may I help you?"
  echo -e "\n1) Haircut\n2) Massage\n3) Taxes"
  read SERVICE_ID_SELECTED
}

SERVICE_MENU() {
  echo -e "\nPlease enter your phone number:"
  read CUSTOMER_PHONE 

  # check whether customer already exists
  CHECK_PHONE=$($PSQL "select phone from customers where phone='$CUSTOMER_PHONE'")
  if [[ -z $CHECK_PHONE ]]
  then
    echo -e "\nPlease enter your name:"
    read CUSTOMER_NAME
    INSERT_CUSTOMER=$($PSQL "insert into customers(phone, name) values('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  else 
    CUSTOMER_NAME=$($PSQL "select name from customers where phone='$PHONE_NUMBER'")
  fi


  # get their appt time
  echo -e "\nPlease enter your appt. time:"
  read SERVICE_TIME

  # insert the appointment
  CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
  INSERT_APPT=$($PSQL "insert into appointments(customer_id, service_id, time) values($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

  # output final message
  SERVICE_SELECTED=$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED")
  
  echo -e "I have put you down for a $SERVICE_SELECTED at $SERVICE_TIME, $CUSTOMER_NAME."
}

MAIN_MENU

case $SERVICE_ID_SELECTED in 
  [1-3]) SERVICE_MENU ;;
  *) MAIN_MENU ;;
esac 
