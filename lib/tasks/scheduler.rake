require "#{Rails.root}/app/helpers/slack_helper"
require "#{Rails.root}/app/helpers/snack_helper"

include SlackHelper
include SnackHelper

def reset_list
  Vote.all.delete_all
end

task :reset_list => :environment do
  reset_list
  send_updated_list("*The snack list has been reset.*")
end
