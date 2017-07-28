require "#{Rails.root}/app/helpers/slack_helper"
require "#{Rails.root}/app/helpers/snack_helper"

include SlackHelper
include SnackHelper

def reset_list
  snacks = sorted_snacks
  SnackVoteMailer.snack_vote_email(email: 'dannycho7@gmail.com', snacks: snacks).deliver_now
  snacks.delete_all unless snacks.empty?
end

task :reset_list => :environment do
  reset_list
  send_updated_list("*The snack list has been reset.*")
end

task :email => :environment do
  SnackVoteMailer.snack_vote_email(email: 'dannycho7@gmail.com', snacks: sorted_snacks).deliver_now
end
