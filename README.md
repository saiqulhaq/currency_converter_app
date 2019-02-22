# Currency Converter Rails Vue

Currency Converter app built with Rails and VueJS framework. Uses currency layer for source data. 
Data is cached with Memcached.

Demo: [http://workable.saiqulhaq.com/](http://workable.saiqulhaq.com/)

## Installation

Tested with:

* Ruby 2.4.5
* PostgreSQL 10.6
* Memcached 1.5.6
* NodeJS v10.13.0
* Yarn 1.12.3

* Configuration

* edit `config/database.yml` file
* add currency layer api key `rails credentials:edit`, add new key `currency_layer_api_key`

* Database creation

`rails db:create db:migrate`

## Usage

1. run `sidekiq`
2. exec rails server
3. exec webpack dev server (optional) 

## Screenshot

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License
[MIT](https://choosealicense.com/licenses/mit/)