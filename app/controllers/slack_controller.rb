require 'json'

class SlackController < ApplicationController
  skip_before_action :verify_authenticity_token

  BANNER_TEXT = 'Vote on your favorite snacks'.freeze
  ATTACHMENT_TEXT = 'Temporary text'
  ATTACHMENT_TYPE = 'default'.freeze
  ATTACHMENT_COLOR = '#3AA3E3'.freeze
  ATTACHMENT_VOTE_CALLBACK_ID = 'vote'.freeze
  ATTACHMENT_FALLBACK = 'You are unable to choose a snack'.freeze

  def vote
    add_vote_using_payload

    render json: {
      text: BANNER_TEXT,
      message_ts: params[:message_ts],
      "attachments": get_attachment_info
    }
  end

  def receive
    case command
      when 'snacklist'
        respond_to do |format|
          format.json {
            render json: {
              response_type: 'in_channel',
              text: BANNER_TEXT,
              "attachments": get_attachment_info
            }
          }
        end
      when 'suggest'
        respond_to do |format|
          if add_vote_using_command
            format.json {
              render json: {
                response_type: 'in_channel',
                text: BANNER_TEXT,
                "attachments": get_attachment_info
              }
            }
          else
            format.json {
              render json: {
                text: 'This snack cannot be added'
              }
            }
          end
        end
    end
  end

  private

  def get_attachment_info
    [
      {
        "text": ATTACHMENT_TEXT,
        "fallback": ATTACHMENT_FALLBACK,
        "callback_id": ATTACHMENT_VOTE_CALLBACK_ID,
        "color": ATTACHMENT_COLOR,
        "attachment_type": ATTACHMENT_TYPE,
        "actions": snack_list
      }
    ]
  end

  def add_vote_using_payload
    payload = JSON.parse(params[:payload])
    username = payload['user']['name']
    snackname = payload['actions'].first['value']
    add_vote(username, snackname)
  end

  def add_vote_using_command
    username = params[:user_name]
    snackname = params[:text]
    add_vote(username, snackname)
  end

  def add_vote(username, snackname)
    user = find_or_create_user(username)
    snack_id = find_or_create_snack(snackname).id
    Vote.new(user_id: user.id, snack_id: snack_id).save
  end

  def find_or_create_user(username)
    user = User.find_by(username: username)
    unless user
      user = User.new(username: username)
      user.save
    end
    user
  end

  def find_or_create_snack(snackname)
    snack = Snack.find_by(name: snackname)
    unless snack
      snack = Snack.new(name: snackname)
      snack.save
    end
    snack
  end

  def snack_list
    snacks = Snack.all
    snacks.map do |snack|
      {
        name: 'snack',
        votes: snack.votes.count,
        text: snack.name.upcase + ' - ' + snack.votes.count.to_s,
        type: 'button',
        value: snack.name
      }
    end
    .select { |entry| entry[:votes] > 0 }
  end

  def command
    params[:command].sub('/', '')
  end
end
