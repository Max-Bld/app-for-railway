#!/bin/bash

head -n -4 $PWD/openapi.yml > tmp.yml && mv tmp.yml openapi.yml


NGROK_PID=$(pgrep ngrok)
kill $NGROK_PID

FLASK_PID=$(pgrep python3)
kill $FLASK_PID

ngrok http 5000 &
sleep 2

URL=$(curl -s localhost:4040/api/tunnels | jq -r ".tunnels[0].public_url")
echo $URL

TXT=$"-  url: $URL"
echo $TXT
echo "servers:" >> $PWD/openapi.yml
echo $TXT >> $PWD/openapi.yml

python3 api_flask.py &
