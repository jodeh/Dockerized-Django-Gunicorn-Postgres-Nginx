# Demo Django Application with MYSQL and Nginx Reverse Proxy.

![Dockerize-01](https://github.com/jodeh/Dockerized-Django-Nginx-MYSQL/assets/80529706/028acd0c-95be-4a68-8b1a-9550db43c9ef)

<hr>

## Table of Contents
* ### Prerequisites
* ### How to build
* ### Configuration
<hr>

### Prerequisites
Make sure you have downloaded these prerequisites before we start 
* [Docker](https://docs.docker.com/get-docker/)
* [Docker compose](https://docs.docker.com/compose/install/)
<hr>

### How to build
 
  1. Clone the repository to your local machine

     ```
     git clone https://github.com/jodeh/Dockerized-Django-Nginx-MYSQL.git
     cd Dockerized-Django-Nginx-MYSQL
     ```
  2. Before we start to run the containers, we need to make a network to let the containers to connect with each other

     ```
     docker network create --subnet 10.0.0.0/24 custom-network
     ```
  3. Now lets run our mysql container :

     ```
     docker run -d --network custom-network --ip 10.0.0.15 -v ./mysql/vol:/etc/mysql/conf.d --hostname mysql-database -e MYSQL_ROOT_PASSWORD=password -e             MYSQL_USER=jodeh -e MYSQL_PASSWORD=password -e MYSQL_DATABASE=djangodb mysql
     ```
     As you can see, we ran mysql container and connected it to custom network and made a user called jodeh , you can change it to whatever you want , the same       thing to the database name and passwords .
      and we made a volume in case we accedintly deleted our container , the data will stay saved in our path

  4. Build the Django image and run the container
     ```
     cd ~/Dockerized-Django-Nginx-MYSQL/Django
     docker build -t django-app .
     docker run -d --network custom-network --ip 10.0.0.10 --hostname django django-app
     ```
  5. Build the nginx image and run it
       ```
       cd ~/Dockerized-Django-Nginx-MYSQL/nginx
       docker build -t nginx-reverse-proxy .
       docker run -d --network custom-network --ip 10.0.0.5 -p 80:80 --hostname nginx nginx-reverse-proxy  
        ```
     
  6. Migrate tables to the new database
       ```
       docker exec -it <django container id> bash
       cd ~/mysite
       python3 manage.py migrate
       ```
     After you finish exit the container
      ```
      exit
      ```
  7. Now go to mysql container to check tables
     ```
     docker exec -it <mysql container id> bash
     
     $ mysql -p
     > SHOW DATABASES;
     > USE djangodb;
     > SHOW TABLES;
     ```
   Tables must be shown.
 
  9. Finally you can check the connectivity by going to the ip which we gave to the nginx which is 10.0.0.5 or the server name.

<hr>

### Configuration
  * We can configure django settings by editting ./django/mysite/settings.py file
  * The proxy pass and the server name can be configured by editting ./etc/nginx/conf.d/default.conf file

