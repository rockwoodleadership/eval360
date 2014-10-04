[![Code Climate](https://codeclimate.com/github/rockwoodleadership/eval360/badges/gpa.svg)](https://codeclimate.com/github/rockwoodleadership/eval360)
[![Test Coverage](https://codeclimate.com/github/rockwoodleadership/eval360/badges/coverage.svg)](https://codeclimate.com/github/rockwoodleadership/eval360)
##Rockwood 360 Eval Software

###Requirements
- Ruby 2.1.2
- Rails 4.1.4
- Postgresql 9.3

####Setup
1 Run the below script
```
./script/newb
```
2 Generate a random encryption key
```
ruby -ropenssl -rbase64 -e "puts Base64.strict_encode64(OpenSSL::Random.random_bytes(16).to_str)"
```
3 Create a .env file with the following using the Saleforce Consumer Key and Consumer Secret, and the token generated in previos step:
```
CONSUMER_KEY= "CONSUMER_KEY"
CONSUMER_SECRET= "CONSUMER_SECRET"
TOKEN_ENCRYPTION_KEY= "TOKEN_ENCRYPTION_KEY"
``` 
####Start
```
thin start --ssl
```
####Test
```
rake
```
