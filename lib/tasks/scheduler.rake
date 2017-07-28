require "#{Rails.root}/app/helpers/slack_helper"
require "#{Rails.root}/app/helpers/snack_helper"

include SlackHelper
include SnackHelper

def reset_list(snacks:, top_3:)
  SnackVoteMailer.snack_vote_email(email: ENV['ADMIN_TO_EMAIL'], snacks: snacks).deliver_now
  Vote.all.delete_all
  Snack.where.not(id: top_3).delete_all
end

task :reset_list => :environment do
  return unless [14, 28].include? Date.today.day
  snacks = sorted_snacks
  top_3_ids = []
  snacks.each do |snack|
    top_3_ids.push(snack[:id])
    break if top_3_ids.length >= 3
  end
  reset_list(snacks: snacks, top_3: top_3_ids)
  send_updated_list("*The snack list has been reset.*\nOnly the top 3 items from the last period has been added back.")
end

task :email => :environment do
  SnackVoteMailer.snack_vote_email(email: ENV['ADMIN_TO_EMAIL'], snacks: sorted_snacks).deliver_now
end
