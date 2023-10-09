# Dockerized Django, MySQL as Database, and Nginx Setup as reverse proxy

In this guide I'm going to build a Django web app but I'll use Mysql as database instead of the default database mysql lite 3 , as well as I'm going to setup Nginx as reverse proxy.
<hr>

### Table of Contents
* Prerequisites
* How to build
* Configuration
<hr>

### Prerequisites
Make sure you have downloaded these prerequisites before we start 
* [Docker](https://docs.docker.com/get-docker/)
* [Docker compose](https://docs.docker.com/compose/install/)
<hr>

### How to build
  1. First of all we will make a new directory where all the files would live.

     ```
     mkdir my-project
     cd my-project
     ```
  2. Now we will clone the repository to your local machine

     ```
     git clone https://github.com/jodeh/Dockerized-Django-Nginx-MYSQL.git
     ```
  3. Before we start to run the containers, we need to make a network to let the containers to connect with each other

     ```
     docker network create --subnet 10.0.0.0/24 custom-network
     ```
  4. Now lets run our mysql container :

     ```
     docker run -d --network custom-network --ip 10.0.0.15 -v ./mysql/vol:/etc/mysql/conf.d --hostname mysql-database -e MYSQL_ROOT_PASSWORD=password -e MYSQL_USER=jodeh -e MYSQL_PASSWORD=password -e     
     MYSQL_DATABASE=djangodb mysql
     ```
     As you can see, we ran mysql container and connected it to custom network and made a user called jodeh , you can change it to whatever you want , the same thing to the database name and passwords .
      and we made a volume in case we accedintly deleted our container , the data will stay saved in our path
     ```
  5. Build the Django image and run the container
     ```
     cd django
     docker build -t django-app .
     docker run -d --network custom-network --ip 10.0.0.10 -p 8000:8000 --hostname django django-app
     ```
  6. Run the Nginx container
