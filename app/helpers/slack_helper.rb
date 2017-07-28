module SlackHelper
  def verify_slack_token
    unless check_command || check_payload
      render json: {
        success: false
      }
    end
  end

  private

  def check_payload
    payload = JSON.parse(params[:payload]) if params[:payload]
    payload['token'] == ENV['SLACK_VERIFICATION_TOKEN'] if payload
  end

  def check_command
    p "Token: #{params[:token] == ENV['SLACK_VERIFICATION_TOKEN']}"
    params[:token] == ENV['SLACK_VERIFICATION_TOKEN']
  end
end
