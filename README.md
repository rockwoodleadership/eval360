[![Build Status](https://travis-ci.org/rockwoodleadership/eval360.svg?branch=master)](https://travis-ci.org/rockwoodleadership/eval360)
## Rockwood 360 Eval Software

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

#### Adding Assessments and Questions
1. Adding a new Assessment:
  - Logged in as an admin, click the 'Assessments' link in the menu
  - Click 'New Assessment' in the upper right-hand corner
  - Give your assessment a name, click 'Create Questionnaire' 

2. Adding a new Section:
  - Open an existing assessment
  - Scroll to the 'Adding Sections' panel, and click 'New Section'
  - Give your section a title
  - Click 'Add New Questionnaire Template'
  - Choose which Assessment you would like the section to be a part of
  - If you would like to add it to multiple assessments, simply click 'Add New Questionnaire Template' and choose a different assessment. 
  - If you change your mind, click remove to remove the assessment from being linked. 
  - Click 'Create Section' to create the section and be redirected to the Sections homepage (recommended)
  - Check the 'Create another Section' box to create the section AND REFRESH THE PAGE to make another section.  


3. Adding an Existing Section
  - Open an existing assessment
  - Scroll to the 'Adding Sections' panel, and click 'Add an Existing Section'
  - You'll be taken to the Sections index page. 
  - From here, click 'Edit' on the section you'd like to add 
  - Click 'Add New Questionnaire Template'
  - Choose the Assessment you would like the section to be a part of
  - Click 'Update Section' to create the section and be redirected to the Sections homepage
  - If you would like to add it to multiple assessments, simply click 'Add New Questionnaire Template' and choose a different assessment. 
  - If you would like to delete it from an assessment, check the 'delete' box and click 'Update Section'
    
4. Adding Questions to Sections
  - Navigate to an existing assessment
  - Click 'View'
  - Add a new section or an existing section to the assessment, if you haven't already.  
  - Within the section you'd like to add the question, click 'New Question'
  - Give your question an answer type, a description, and a self-description. 
  - Click 'Create Question'
  - Click 'Back'

#### To create/view/edit/delete questions, you must do so within a section inside of an assessment. 
