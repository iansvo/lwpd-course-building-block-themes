# Building Block Themes Course

This repo is the starting point for the [Building Block Themes course](https://www.learnwptheme.dev/course/building-block-themes). Students will start by checking out the `main` branch and then following along with the build from there. 

## Requirements

- Node JS v24
- Docker Desktop (or Orbstack) installed and running
- Coffee (always helps)


## Setup

1. After checking out the repo on your computer, open a terminal in the repo's root folder (the one this file is in). 
2. Run `npm i` to install all dependencies
3. Ensure Docker Desktop is running
4. Run `npm run wp-env start` to create your WordPress install
5. Once the install completes, navigate to http://localhost:1337 and you should see a blank homepage

## Accessing the Admin Dashboard

You can access the dashboard just like any other WordPress install (http://localhost:1337/wp-admin) and use the below credentials:

- User: `admin`
- Password: `password`