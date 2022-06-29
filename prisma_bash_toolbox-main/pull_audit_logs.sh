#!/usr/bin/env bash
# Requires jq to be installed
# Author Kyle Butler


source ./secrets/secrets
source ./func/func.sh

# Time filter. Assign the appropriate values. This will pull the last month's worth of audit logs. 
TIMEAMOUNT=1
TIMEUNIT="month"
TIMETYPE="relative"


#### NO EDITS NEEDED BELOW

pce-var-check

AUTH_PAYLOAD=$(cat <<EOF
{"username": "$PC_ACCESSKEY", "password": "$PC_SECRETKEY"}
EOF
)


PC_JWT_RESPONSE=$(curl --request POST \
                       --url "$PC_APIURL/login" \
                       --header 'Accept: application/json; charset=UTF-8' \
                       --header 'Content-Type: application/json; charset=UTF-8' \
                       --data "${AUTH_PAYLOAD}")

quick_check "/login"

PC_JWT=$( printf %s "$PC_JWT_RESPONSE" | jq -r '.token' )

# returns as json
curl --request GET \
     --url "$PC_APIURL/audit/redlock?timeType=$TIMETYPE&timeAmount=$TIMEAMOUNT&timeUnit=$TIMEUNIT" \
     --header "x-redlock-auth: $PC_JWT" | jq

quick_check "/audit/redlock?timeType=$TIMETYPE&timeAmount=$TIMEAMOUNT&timeUnit=$TIMEUNIT"
exit
