# frozen_string_literal: true

class Api::ApplicationController < ApplicationController
  before_action :authenticate_user

  rescue_from ActionController::ParameterMissing, with: :handle_missing_parameters
  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

  private

  attr_reader :current_user

  def authenticate_user
    @payload = JsonWebToken.decode(token)[0]

    user_id = @payload['user_id']
    @current_user = User.find(user_id)
  rescue JWT::DecodeError, ActiveRecord::RecordNotFound
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end

  def missing_parameters(exception)
    render json: { error: "Missing parameter: #{exception.param}" }, status: :bad_request
  end

  def record_not_found
    render json: { error: 'Record not found' }, status: :not_found
  end

  # @return [String]
  def token
    @token ||= request.headers['Authorization'].to_s.split(' ').last
  end
end
