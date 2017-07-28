class SnackVoteMailer < ApplicationMailer
  include SnackHelper

  def snack_vote_email(email:, snacks:)
    puts 'Attemping to mail Kelly'
    @snack_votes = snacks.sort_by { |k| k[:vote_count_yes] }
    mail(to: email, subject: 'Bi-Weekly Snack Request Report')
  end
end
