module SlackHelper
  EMPTY_SNACK_LIST_TEXT = 'There are no snacks in the snack list. Type /suggest [snackname] to add a new snack!'.freeze

  ATTACHMENT_TYPE = 'default'.freeze
  ATTACHMENT_COLOR = '#3AA3E3'.freeze
  ATTACHMENT_VOTE_CALLBACK_ID = 'vote'.freeze
  ATTACHMENT_FALLBACK = 'You are unable to choose a snack'.freeze

  def verify_slack_token
    unless check_command || check_payload
      render json: {
        success: false
      }
    end
  end

  def send_updated_list(text)
    url = URI.parse(ENV['SLACK_WEBHOOK_URL'])
    HTTParty.post(url.to_s, body: {
      text: text,
      attachments: get_attachment_info
    }.to_json, headers: {'Content-Type': 'application/json'})
  end

  def create_atachment_entry(display_name:, vote_count_yes:, vote_count_no:, name:)
    {
      text: display_name,
      fallback: ATTACHMENT_FALLBACK,
      callback_id: ATTACHMENT_VOTE_CALLBACK_ID,
      color: ATTACHMENT_COLOR,
      attachment_type: ATTACHMENT_TYPE,
      vote_count_yes: vote_count_yes,
      actions: [
        {
          name: name,
          text: vote_count_yes.to_s,
          type: 'button',
          style: 'primary',
          value: 1
        },
        {
          name: name,
          text: vote_count_no.to_s,
          type: 'button',
          style: 'danger',
          value: -1
        },
        {
          name: name,
          text: 'Indifferent',
          type: 'button',
          value: 0
        }
      ]
    }
  end

  private

  def get_attachment_info(default_attachment = { text: EMPTY_SNACK_LIST_TEXT })
    snack_attachments = snack_list
    snack_attachments.push(default_attachment) if snack_attachments.empty?
    snack_attachments
  end

  def snack_list
    sorted_snacks.map do |snack|
      name = snack[:name]
      vote_count_yes = snack[:vote_count_yes]
      vote_count_no = snack[:vote_count_no]
      display_name = name.capitalize
      create_atachment_entry(display_name: display_name, vote_count_yes: vote_count_yes, vote_count_no: vote_count_no, name: name)
    end
  end

  def check_payload
    payload = JSON.parse(params[:payload]) if params[:payload]
    payload['token'] == ENV['SLACK_VERIFICATION_TOKEN'] if payload
  end

  def check_command
    params[:token] == ENV['SLACK_VERIFICATION_TOKEN']
  end

  def command
    params[:command].sub('/', '')
  end
end
