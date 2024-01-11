#!/bin/sh

envConfig=""
path="$PWD"
# Funcitons
function readInFile() {
    input=$PWD/"envConf.txt"
    while IFS= read -r line || [[ -n "$line" ]]
    do
    echo "$line"$'\n'
        envConfig+="$line"$'\n'
    done < "$input"
}

function addAuth(){
    if [ ! -f "getCurrentSession.js" ]
        then
           callFileText="export async function getCurrentSession(supabase, req) {
            const cookies = req.headers.cookie;
            const access_token = cookies.split('; ')[0].split('=')[1];

            const refresh_token = cookies.split('; ')[1].split('=')[1];
            const { sessionData, sessionError } = supabase.auth.setSession({
                access_token,
                refresh_token,
            })

            if (sessionError) {

                console.error('session error', sessionError);

                throw sessionError;

            }

            const {

                data: { user },

            } = await supabase.auth.getUser();
        return supabase;
}";

echo -e "$callFileText" > getCurrentSession.js 

        fi
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
                addAuth
            cd ..
        else
        cd "$folder"
        cd "code"
        addEnv
        addAuth
        cd ../..
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
clone_or_pull "animal-details" "https://github.com/HangoutSafari/animal-details.git"

chmod 777 -R *


addEnvToAll
cd ..


if [[ ! -d "Hangout-Safari" ]]
then
git clone https://github.com/HangoutSafari/Hangout-Safari.git
cd "Hangout-Safari"
npm install
npm audit fix
cd ..
fi

#docker compose up



















