[![Build Status](https://travis-ci.org/rockwoodleadership/eval360.svg?branch=master)](https://travis-ci.org/rockwoodleadership/eval360)
## Rockwood 360 Eval Software

## As of 10/16 we are deploying from the ‘upgrade-ruby’ branch

### Requirements
- Ruby 2.5.0
- Rails 5.2.0
- Postgresql 9.4
- Heroku stack: Heroku-18

#### Setup
0 To set up this environment locally, please get the necessary login info to Github, Heroku, Salesforce, and Mailchimp (you will access Mandrill through here) from Joi or Amie.

1 Fork the repo 
```
[https://help.github.com/articles/fork-a-repo/](https://help.github.com/articles/fork-a-repo/)  
```
2 Run the below script
```
./script/newb
```
3 Create a .env file with the following using the associated keys found in Heroku:
```
MANDRILL_APIKEY="MANDRILL_APIKEY"
DATABASEDOTCOM_CLIENT_ID="1234"
DATABASEDOTCOM_CLIENT_SECRET="secret"
DATABASEDOTCOM_HOST="test.salesforce.com"
INBOUND_SALESFORCE_KEY="example"
SALESFORCE_PASSWORD="passwordsecuritytoken"
SALESFORCE_USERNAME="example@email.com"
``` 
To find these, when logged into Heroku, please find the config vars in dashboard -> rockwood -> settings -> config vars, click “reveal config vars”. 
```
#### Start
```
thin start --ssl
```
#### Test
```
rake, rspec
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
```
**We have the ability to create new questionnaires/sections/questions in the software too. 
```
**Please find the documentation for ActiveAdmin, Formtastic, and Slim for reference. 

5. We have the ability to create new questionnaires/sections/questions in the software too.

Please find the documentation for ActiveAdmin, Formtastic, and Slim for reference. 


