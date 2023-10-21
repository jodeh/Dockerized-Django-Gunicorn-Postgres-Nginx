# Demo Django Application using Gunicorn with Postgresql and Nginx Reverse Proxy.



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
     git clone https://github.com/jodeh/Dockerized-Django-Gunicorn-Postgres-Nginx.git
     cd Dockerized-Django-Gunicorn-Postgres-Nginx
     ```
  2. Before we start to run the containers, we need to make a network to let the containers to connect with each other

     ```
     docker network create --subnet 10.0.0.0/24 custom-network
     ```
  3. Now lets run our postgresql container :

     ```
     docker run -d --network custom-network --ip 10.0.0.15 --hostname postgres-database -e POSTGRES_PASSWORD=password postgres
     ```

  4. Build the Django image and run the container
     ```
     cd /Django
     docker build -t django-app .
     docker run -d --network custom-network --ip 10.0.0.10 --hostname django django-app
     ```
  5. Build the nginx image and run it
       ```
       cd /nginx
       docker build -t nginx-reverse-proxy .
       docker run -d --network custom-network --ip 10.0.0.5 -p 80:80 --hostname nginx nginx-reverse-proxy  
        ```
     
  6. Create user in psql .
       ```
       docker exec -it <postgres container id> bash
       
       $ psql -U postgres --pasword
       > CREATE DATABASE djangodb;
       > CREATE USER jodeh WITH ENCRYPTED PASSWORD 'password';
       > GRANT ALL PRIVILEGES ON DATABASE djangodb TO jodeh;
       ```
 7. Migrate tables to the new database
       ```
       docker exec -it <django container id> bash
       python3 manage.py migrate
       ```
  7. Now go back to psql container to check tables
     ```
     docker exec -it <mysql container id> bash
     
     $ psql -U postgres --password
     > \dt;
     ```
     Tables must be shown like this.
   
     ![postgres tables](https://github.com/jodeh/Dockerized-Django-Nginx-MYSQL/assets/80529706/82e97787-435c-40dd-95d8-8718cc1f57dc)


  9. Finally you can check the connectivity by going to the ip which we gave to the nginx which is 10.0.0.5 or the server name.

<hr>

### Compose file
I've attache docker compose file (docker-compose.yml) in the root directory, all you need is to run theis command:
```
docker-compose up -d --build
```
When you to stop them
```
docker-compose down
```
<hr>

### Configuration
  * We can configure django settings by editting ./Django/djangodockertest/settings.py file
  * The proxy pass and the server name can be configured by editting ./etc/nginx/conf.d/default.conf file

