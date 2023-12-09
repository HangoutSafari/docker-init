# Docker initialization
## What is it for?
This repository is make the docker setup process easier by automating it with a bash script.
## How does it work?
The bash script checks if the repository has been cloned already. If not it will clone the repositories and set the env files for the microservices. If yes it will pull the latest changes for the microservices, and leave the frontend unchanged.

## <span style="color:red">!! Important !!</span>
I highly advise you to use git bash for these commands, and also when you use git commands (git add, git commit, etc).
## How to use
1. Clone this repository to your desired folder. You will be met with the following files:
	1. envConf.txt.example
	2. init.sh
	3. docker-compose-dev.yml
	4. docker-compose-prod-yml
2. Use the `cp envConfig.txt.example envConfig.txt` command to create a copy of the example file.
3. Open the newly created file and add the Supabase URL and API key respectively. 
4. Save the file and close it.
5. Run the `init.sh` using git bash (`./init.sh`). This will clone all the repositories and add the env files to the microservices, so that we can create connection to the Supabase database. Your folder structure will be like this:
```
.  
├── backend  
│   ├── animals-ms  
│   ├── api-gateway  
│   ├── events-ms  
│   ├── models-ms  
│   └── users-ms  
├── docker-compose-dev.yml  
├── docker-compose-prod.yml  
├── envConf.txt.example  
├── Hangout-Safari  
│   ├── Dockerfile  
│   ├── jsconfig.json  
│   ├── LICENSE  
│   ├── package.json  
│   ├── package-lock.json  
│   ├── postcss.config.js  
│   ├── README.md  
│   ├── src  
│   ├── static  
│   ├── svelte.config.js  
│   ├── tailwind.config.js  
│   ├── tsconfig.json  
│   └── vite.config.js   
└── init.sh
```
6. You have two choices based on your desires. You can choose to run the dev or the production version. The dev version connect to the microservices but doesn't run the frontend on the docker, so it's easily editable. The production version will run the whole application in a dockerised manner.
	1. If you wan to run the docker in dev mode use the `docker compose -f docker-compose-dev.yml up` command.
	2. If you want to run the docker in production mode use the `docker compose -f docker-compose-prod.yml up` command.

I
f you are done with these steps, you can work as you would normally.
