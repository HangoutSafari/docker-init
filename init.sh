#!/bin/sh

envConfig=""
# Funcitons
function readInFile() {
    input=$PWD/"envConf.txt"
    while IFS= read -r line || [[ -n "$line" ]]
    do
    echo "$line"$'\n'
        envConfig+="$line"$'\n'
    done < "$input"
}




function addEnv(){
    if [ ! -f "variables.env" ]
        then
            cp variables.example.env variables.env
             echo "$envConfig" >> variables.env
        fi
}

function addEnvToAll(){
# Checking for .env files
for folder in ./*; do
    if [ -d "$folder" ]; then
        if [ "$folder" != "./api-gateway" ]
        then
            cd "$folder"
                addEnv
            cd ..
        fi
    fi
done    
}

# Reading in .envConf
readInFile

# checking github for repos
function clone_or_pull() {
    local repo_name=$1
    local repo_url=$2

    if [ ! -d "$repo_name" ]; then
        git clone "$repo_url"
    else
        pushd "$repo_name"
        git stash
        git pull
        popd
    fi
}

# Create backend directory if not exists
if [ ! -d "backend" ]; then
  mkdir "backend"
fi
cd "backend" || exit 1

# Clone or pull repositories
clone_or_pull "animals-ms" "https://github.com/HangoutSafari/animals-ms.git"
clone_or_pull "events-ms" "https://github.com/HangoutSafari/events-ms.git"
clone_or_pull "users-ms" "https://github.com/HangoutSafari/users-ms.git"
clone_or_pull "models-ms" "https://github.com/HangoutSafari/models-ms.git"
clone_or_pull "api-gateway" "https://github.com/HangoutSafari/api-gateway.git"


chmod 777 -R *


addEnvToAll
cd ..


if [[ ! -d "Hangout-Safari" ]]
then
git clone https://github.com/HangoutSafari/Hangout-Safari.git
npm install
fi

#docker compose up
