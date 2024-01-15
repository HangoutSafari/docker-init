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
           callFileText="
import * as dotenv from "'"'"dotenv"'"'";

import { createClient} from "'"'"@supabase/supabase-js"'"'";

dotenv.config({ path: 'variables.env' });
const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_KEY
);

export async function getCurrentSession(req) {
    
            const cookies = req.headers.cookie;
            if (cookies == null) return { code: 1, error: "'"'"cookies error"'"'"};
            const access_token = cookies.split('; ')[0].split('=')[1];

            const refresh_token = cookies.split('; ')[1].split('=')[1];
            const { sessionData, sessionError } = supabase.auth.setSession({
                access_token,
                refresh_token,
            })

            if (sessionError) {

                console.error('session error', sessionError);

                return { code: 1, error: "'"'"supabaseError"'"'"};

            }

            const {

                data: { user },

            } = await supabase.auth.getUser();
        return { code:0, client: supabase};
}

export async function getAnimals(req, res) {
  const session = await getCurrentSession(req);
  if (session['code'] == 1) res.send(\`error in session: \${session['error']}\`);
  else {
    const supabaseInstance = session['client'];
    
    if (error) res.send(\`query error in supabase: \${error.message}\`);
    else {
      res.set("'"'"Access-Control-Allow-Credentials"'"'", "'"'"true"'"'");
      res.set("'"'"Access-Control-Allow-Origin"'"'", "'"'"http://localhost:5173"'"'");
      res.status(200).json(data); 
    } 
  }
}
export async function getDataFrom(req, res, tableName, id = null) {
  const {data, error} = await chooseData(supabase, tableName, id);
  sendToClient(res, await data, await error);
}

export async function getAuthDataFrom(req, res, tableName, id = null) {
  const session = await getCurrentSession(req);
  if (session['code'] == 1) res.send(\`error in session: \${session['error']}\`);
  else {
    const supabaseInstance = session['client'];
    const {data, error} = await chooseData(supabaseInstance, tableName, id);
    sendToClient(res, await data, await error, true)
  }
}

async function chooseData(supabaseInstance, tableName, id) {
    if (id == null) {
        return await supabaseInstance.from(tableName).select();
    } else {
        return await supabaseInstance.from(tableName).select().eq("'"'"id"'"'", id).single();
    }
}
function sendToClient(res, data, error, isAuth = false)
{
    
    if (error) res.send(\`query error in supabase: \${error.message}\`);
    else {
        if (isAuth) {
            res.set("'"'"Access-Control-Allow-Credentials"'"'", "'"'"true"'"'");
            res.set("'"'"Access-Control-Allow-Origin"'"'", "'"'"http://localhost:5173"'"'");
        }
        res.status(200).json(data); 
    } 
}
";

echo -e "$callFileText" > getCurrentSession.js 


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
        else
        cd "$folder"
        cd "code"
        addEnv
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



















