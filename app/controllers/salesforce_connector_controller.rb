class SalesforceConnectorController < ApplicationController
  protect_from_forgery with: :null_session
  before_filter :check_api_key
  
  def new_participant

    puts "****new_participant"
    puts params

    hash = JSON.parse(params[:participant])

    required_keys = ['first_name', 'last_name', 'email',
                     'sf_training_id', 'sf_registration_id', 'sf_contact_id']

    required_keys.each do |key|
      unless hash.has_key? key
        render json: "missing required key #{key}", status: 422 and return
      end
    end

    sf_training_id = hash['sf_training_id']
    training = Training.find_by(sf_training_id: sf_training_id) 

    if training
      attributes = hash.extract!('first_name', 'last_name', 'email',
                                 'sf_registration_id', 'sf_contact_id')
      participant = training.participants.create!(attributes)

      if participant && participant.errors.empty?
        participant.invite
        render json: 'success', status: 200 and return
      else
        render json: 'could not create new participant', status: 422
      end
    else
      render json: 'invalid training record', status: 422
    end

  end

  def new_training
    puts "***new_training"
    puts params


    hash = JSON.parse(params[:training])
    required_keys = ['name', 'start_date', 'end_date',
                     'sf_training_id', 'deadline',
                     'questionnaire_name', 'status']

    required_keys.each do |key|
      unless hash.has_key? key
        render json: "missing required key #{key}", status: 422 and return
      end
    end
    questionnaire = Questionnaire.find_by(name: hash['questionnaire_name'])
    
    if questionnaire
      attributes = hash.extract!('sf_training_id', 'name', 'start_date',
                                 'end_date', 'status', 'city', 'state',
                                 'deadline', 'site_name', 'curriculum')
      attributes['questionnaire_id'] = questionnaire.id
      if Training.create!(attributes)
        render json: 'success', status: 200
      else
        render json: 'could not create new training', status: 422
      end
    else
      render json: 'invalid questionnaire name', status: 422
    end
  end

  def update_participant
    puts "***update_participant"
    puts params
    
    hash = JSON.parse(params[:participant])
    required_keys = ['sf_contact_id', 'changed_fields']

    required_keys.each do |key|
      unless hash.has_key? key
        render json: "missing required key #{key}", status: 422 and return
      end
    end

    attributes = {}

    participant = Participant.find_by(sf_contact_id: hash['sf_contact_id'])
    attributes = {}
    hash['changed_fields'].each do |cf|
      if cf == 'sf_training_id'
        attributes['training_id'] = Training.find_by(sf_training_id: hash['sf_training_id']).id
      else
        attributes[cf] = hash[cf]
      end
    end

    if participant.update!(attributes)
      render json: 'success', status: 200 and return
    else
      render json: 'something went wrong', status: 422
    end
  end

  def update_training
    puts "****update_training"
    puts params

    hash = JSON.parse(params[:training])
    required_keys = ['sf_training_id', 'changed_fields']

    required_keys.each do |key|
      unless hash.has_key? key
        render json: "missing required key #{key}", status: 422 and return
      end
    end
    training = Training.find_by(sf_training_id: hash['sf_training_id'])

    if training
      attributes = {}
      hash['changed_fields'].each do |cf|
        if cf == 'questionnaire_name'
          attributes['questionnaire_id'] = Questionnaire.find_by(name: hash['questionnaire_name']).id
        else
          attributes[cf] = hash[cf]
        end
      end

      if training.update!(attributes)
        render json: 'success', status: 200
      else
        render json: 'something went wrong', status: 422
      end
    else
      render json: 'could not find training', status: 422
    end
  end

  private

  def check_api_key
    if params[:participant]
      puts params[:participant]['api_key']
      if params[:partipant]['api_key'] != ENV['INBOUND_SALESFORCE_KEY']
        render json: 'unauthorized access', status: 422
      end
    elsif params[:training]
      puts params[:training]['api_key']
      if params[:training]['api_key'] != ENV['INBOUND_SALESFORCE_KEY']
        render json: 'unauthorized access', status: 422
      end
    end

  end

end
