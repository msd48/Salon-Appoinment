#! /bin/bash
PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"

OPTIONS() {
SERVICES=$($PSQL "SELECT * FROM services")
echo "$SERVICES" | while IFS="|" read SERVICE_ID SERVICE
do
echo "$SERVICE_ID) $SERVICE"
done
SERVICE_SELECTION
}

SERVICE_SELECTION() {
read SERVICE_ID_SELECTED
if [[ $SERVICE_ID_SELECTED > 5 ]]
then
echo I could not find that service. What would you like today?
OPTIONS
else
echo "What's your phone number?"
read CUSTOMER_PHONE
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")
if [[ -z $CUSTOMER_NAME ]]
then
echo "I don't have a record for that phone number, what's your name?"
read CUSTOMER_NAME
fi
CUST_DETAILS=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name = '$CUSTOMER_NAME'")
SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
echo -e "\ntime would you like your $SERVICE, $CUSTOMER_NAME?"
read SERVICE_TIME
APPMNT_DETAILS=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
if [[ $APPMNT_DETAILS == 'INSERT 0 1' ]]
then
echo -e "I have put you down for a $SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
fi
fi
}

echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo Welcome to My Salon, how can I help you?
OPTIONS