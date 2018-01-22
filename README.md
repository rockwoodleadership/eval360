[![Build Status](https://travis-ci.org/rockwoodleadership/eval360.svg?branch=master)](https://travis-ci.org/rockwoodleadership/eval360)
## Rockwood 360 Eval Software

### Requirements
- Ruby 2.3.0
- Rails 4.2.6
- Postgresql 9.4

#### Setup
1 Fork the repo [https://help.github.com/articles/fork-a-repo/](https://help.github.com/articles/fork-a-repo/)  
2 Run the below script
```
./script/newb
```
3 Create a .env file with the following using the associated keys:
```
MANDRILL_APIKEY="MANDRILL_APIKEY"
DATABASEDOTCOM_CLIENT_ID="1234"
DATABASEDOTCOM_CLIENT_SECRET="secret"
DATABASEDOTCOM_HOST="test.salesforce.com"
INBOUND_SALESFORCE_KEY="example"
SALESFORCE_PASSWORD="passwordsecuritytoken"
SALESFORCE_USERNAME="example@email.com"
``` 
#### Start
```
thin start --ssl
```
#### Test
```
rake
```

#### Development Setup
1. Create test questionnaire in rails console
```
Questionnaire.generate_from_yaml('config/questionnaires/Standalone.yml')
```
2. Create test training in rails console
```
t = Training.create(name: 'rockwood test', start_date: DateTime.parse('Jan 23 2018'), end_date: DateTime.parse('Jan 24 2018'), status: 'Planned', questionnaire_id: 1, city: 'San Francisco', state: 'Ca')
```
3. Create participant from rails console
```
t.participants.create(first_name: 'Joe', last_name: 'Smith', email: 'joe@example.com')
```
4. Continue setup in admin panel


