class SnackVoteController < ApplicationController
  include SnackHelper

  def index
    @sorted_snacks = sorted_snacks
  end

  def send_results_email
    if ENV['SNACK_VOTE_EMAIL']
      puts "Email provided: #{ENV['SNACK_VOTE_EMAIL']}"
      SnackVoteMailer.snack_vote_email(ENV['SNACK_VOTE_EMAIL']).deliver
    else
      puts 'No email provided'
    end
  end
end
