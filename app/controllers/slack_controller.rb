require 'json'
require 'httparty'


class SlackController < ApplicationController
  include SnackHelper
  include SlackHelper

  skip_before_action :verify_authenticity_token
  before_action :verify_slack_token

  BANNER_TEXT = "*Vote on your favorite snacks (Resets Bi-Weekly)*\n You can also view the results <http://snack-request-service.herokuapp.com|here>".freeze
  INFO_TEXT = "*Snack Service Command List:*\n[To view the current snack list] /snacklist. \n[To suggest/add a new snack] /suggest [snackname]".freeze

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
      when 'info'
        respond_to do |format|
          format.json {
            render json: {
              response_type: 'default',
              text: INFO_TEXT
            }
          }
        end
      when 'snacklist'
        respond_to do |format|
          format.json {
            render json: {
              response_type: 'default',
              text: BANNER_TEXT,
              "attachments": get_attachment_info
            }
          }
        end
      when 'suggest'
        respond_to do |format|
          add_vote_using_command do |status|
            if status[:success]
              snacklist_text = "The item '#{status[:snackname].capitalize}' was added to the snack list.\nHere are the current voting results:"
              send_updated_list(snacklist_text)

              format.json {
                render json: {
                  text: "Successfully added snack *#{status[:snackname]}*"
                }
              }
            else
              format.json {
                render json: {
                  text: "This snack cannot be added *#{status[:snackname]}*"
                }
              }
            end
          end
        end
    end
  end
end
