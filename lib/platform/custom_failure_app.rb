class CustomFailureApp < Devise::FailureApp
  def respond
    if request.format == :json
      json_error_response
    else
      super
    end
  end

  def json_error_response
    self.status = 200
    self.content_type = 'application/json'
    self.response_body = {success: :false, error: {code: 401, message: i18n_message}}.to_json
  end
end