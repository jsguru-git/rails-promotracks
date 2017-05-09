
class Api::V1::ApiApplicationController < ApplicationController
  respond_to :json
  include ApplicationHelper

  protect_from_forgery with: :null_session

  acts_as_token_authentication_handler_for User
  before_filter :authenticate_user_from_token!

  rescue_from Exception do |e|
    Rails.logger.error e.to_s
    Rails.logger.error e.backtrace.join("\n")
    render json: {success: :false, error: {code: 500, message: 'Something Went Wrong!'}}, status: 200
  end


end
