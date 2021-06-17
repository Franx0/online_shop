## Online Shop
It is a simple api endpoint where we can check merchant disbursements per date.  

#### Prerequisites  
#### Installation (non Dockerized)
You must have [rmv](https://rvm.io/rvm/install) installed in your OS.
1. ```> rvm install 3.0.1```   
2. ```> cd online_shop``` 
3. ```> bundle install```  
4. ```> bundle exec rails db:create db:migrate```  
5. ```> rails s```  

#### Installation (Dockerized)
##### Install Docker
[Ubuntu](https://www.digitalocean.com/community/tutorials/como-instalar-y-usar-docker-en-ubuntu-16-04-es)
[Mac](https://download.docker.com/mac/stable/Docker.dmg)
[Windows](https://download.docker.com/win/stable/InstallDocker.msi)  
> Install Docker compose 
[here!](https://docs.docker.com/compose/install/)  
   
 
##### ENV variables
* POSTGRES_USER=postgres  
* POSTGRES_PASSWORD=postgres  
* POSTGRES_HOST=postgres
* RAILS_ENV=development   
##### Run project NON debug mode
1. ```> docker-compose -f docker/development/docker-compose.yml up -d```   
##### Run project IN debug mode
1. ```> docker-compose -f docker/development/docker-compose.yml up -d && docker attach development_shop_1``` 
> Wail until Compiled successfully message appears in your terminal to run http://localhost:3000

#### Run test suite (non Dockerized)
```> rspec .```
#### Run test suite (Dockerized)
```> docker-compose -f docker/development/docker-compose.yml run shop rspec .```

#### Seeds ####
I did not create a seed file but a task rake instead. Task loads merchants, shopper and orders in order to populate DB.
In order to run rake task:  
* You can pass the following argument 'merchants shoppers orders' to control which records have to been loaded.

(non Dockerized)  
> rake data_example:load  
> rake data_example:load['merchants shoppers']
(Dockerized)  
> docker-compose -f docker/development/docker-compose.yml run shop rake data_example:load
> docker-compose -f docker/development/docker-compose.yml run shop rake data_example:load['merchants shoppers']
##### Swagger #####
Also, I created a proper documentation for the API using Swagger but not in the common way. I like this integration because at the same time you create the doc you can test the response format objects. Please, I'm not very agile yet with that approach and I would like to refactor it more in order to make it more readable in a future.

To check the docs you can visit the following [url](http://localhost:3000/api-docs) with your server running locally.

In order to recreate documentation you can type the following command in your terminal:  

(non Dockerized)  
> rake rswag:specs:swaggerize

(Dockerized)  
> docker-compose -f docker/development/docker-compose.yml run shop rake rswag:specs:swaggerize
##### Front #####
I created the current project thinking about integrate a tiny react application with API but I finally didn't, just a time issue. I can provide a detail explanation of how to do it configuring webpack and using yarn as package manager. 
##### Functionality #####
Every request check merchant_id if provided and date if provided in order to return calculated disbursements grouped per weeks.
Every week begins on Monday so any date required to API will be procesed to find the corresponding begin of the week and return disbursement values associated to this week.

> Example: request /merchants/disbursements?date=Mon%2C%2002%20Apr%202018.  
> Should return "2018-04-02" date which is the beggining of the week of date requested.
