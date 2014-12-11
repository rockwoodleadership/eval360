class SalesforceConnectorController < ApplicationController
  protect_from_forgery with: :null_session
  
  def new_participant

    puts "****new_participant"
    puts params

    render json: 'success', status: 200
    
    #todo Add check for api_key
    # hash = JSON.parse(params[:participant])
    # sf_training_id = hash['sf_training_id']
    # training = Training.find_by(sf_training_id: sf_training_id) 

    # attributes = hash.extract!('first_name', 'last_name', 'email',
    #                            'sf_registration_id', 'sf_contact_id')
    # participant = training.participants.create!(attributes)

    # if participant && participant.errors.empty?
    #   EvaluationEmailer.send_invite_for_self_eval(participant)
    #   render json: 'success', status: 200 and return
    # else
    #   render json: 'something went wrong', status: 422
    # end

  end

  def new_training
    puts "***new_training"
    puts params

    render json: 'success', status: 200

    # hash = JSON.parse(params[:training])
    # attributes = hash.extract!('sf_training_id', 'name', 'start_date',
    #                            'end_date', 'status', 'location')
    # if Training.create!(attributes)
    #   render json: 'success', status: 200
    # else
    #   render json: 'something went wrong', status: 422
    # end
  end


  def update_participant
    puts "***update_participant"
    puts params
    
    render json: 'success', status: 200 
    # hash = JSON.parse(params[:participant])
    # attributes = hash.extract!('first_name', 'last_name', 'email',
    #                           'sf_registration_id', 'sf_contact_id')
    # participant = Participant.find_by(sf_registration_id: hash['sf_registration_id'])
    # if hash['changedFields'].include? 'sf_training_id'
    #   attributes['training_id'] = Training.find_by(sf_training_id: hash['sf_training_id').id
    # end

    # if participant.update!(attributes)
    #   render json: 'success', status: 200 and return
    # else
    #   render json: 'something went wrong', status: 422
    # end
  end

  def update_training
    puts "****update_training"
    puts params

    render json: 'success', status: 200
    # hash = JSON.parse(params[:training])
    # attributes = hash.extract!('name', 'start_date',
    #                            'end_date', 'status', 'location')
    # training.find_by(sf_training_id: hash['sf_training_id'])

    # if training.update!(attributes)
    #   render json: 'success', status: 200
    # else
    #   render json: 'something went wrong', status: 422
    # end
  end

end
