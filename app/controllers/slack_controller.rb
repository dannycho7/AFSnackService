require 'json'
require 'httparty'


class SlackController < ApplicationController
  skip_before_action :verify_authenticity_token

  BANNER_TEXT = 'Vote on your favorite snacks'.freeze
  ATTACHMENT_TYPE = 'default'.freeze
  ATTACHMENT_COLOR = '#3AA3E3'.freeze
  ATTACHMENT_VOTE_CALLBACK_ID = 'vote'.freeze
  ATTACHMENT_FALLBACK = 'You are unable to choose a snack'.freeze

  def vote
    add_vote_using_payload

    render json: {
      text: BANNER_TEXT,
      message_ts: params[:message_ts],
      attachments: get_attachment_info
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
                text: 'Successfully added snack',
              }
            }
=begin
            url = URI.parse('https://hooks.slack.com/actions/T02AA5M0U/218938289316/IfJkisS0GaaQMU3cTAKLU6wL')
            res = HTTParty.post(url.to_s, body: {
              text: BANNER_TEXT,
              attachments: get_attachment_info
            })
            puts res
=end
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
    snack_list.push(
      {
        text: 'Add your own snack item',
        fallback: ATTACHMENT_FALLBACK,
        callback_id: ATTACHMENT_VOTE_CALLBACK_ID,
        color: ATTACHMENT_COLOR,
        attachment_type: ATTACHMENT_TYPE,
        actions: [
          {
            name: 'test',
            text: 'Add your own snack item',
            type: 'input'
          }
        ]
      }
    )
  end

  def snack_list
    snacks = Snack.all
    snacks.map do |snack|
      votes = snack.votes
      vote_count_yes = votes.count { |vote| vote.value == 1 }
      vote_count_no = votes.count { |vote| vote.value == -1 }

      display_name = snack.name.capitalize + ' - ' + vote_count_yes.to_s + ' yes ' + vote_count_no.to_s + ' no'
      {
        text: display_name,
        fallback: ATTACHMENT_FALLBACK,
        callback_id: ATTACHMENT_VOTE_CALLBACK_ID,
        color: ATTACHMENT_COLOR,
        attachment_type: ATTACHMENT_TYPE,
        vote_count_yes: vote_count_yes,
        actions: [
          {
            name: snack.name,
            text: 'Yes',
            type: 'button',
            style: 'primary',
            value: 1
          },
          {
            name: snack.name,
            text: 'No',
            type: 'button',
            style: 'danger',
            value: -1
          },
          {
            name: snack.name,
            text: 'Neutral',
            type: 'button',
            value: 0
          }
        ]
      }
    end
      .select { |entry| entry[:vote_count_yes] > -2 }
  end

  def add_vote_using_payload
    payload = JSON.parse(params[:payload])
    payload_action = payload['actions'].first
    username = payload['user']['name']
    snackname = payload_action['name']
    add_vote(username: username, snackname: snackname, value: payload_action['value'])
  end

  def add_vote_using_command
    username = params[:user_name]
    snackname = params[:text]
    add_vote(username: username, snackname: snackname, value: 1)
  end

  def add_vote(username:, snackname:, value:)
    user = find_or_create_user(username)
    snack = find_or_create_snack(snackname)
    vote = Vote.find_by(user_id: user.id, snack_id: snack.id)
    if vote
      vote.value = value
    else
      vote = Vote.new(user_id: user.id, snack_id: snack.id, value: value)
    end
    vote.save
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

  def command
    params[:command].sub('/', '')
  end
end
