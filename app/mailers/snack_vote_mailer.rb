class SnackVoteMailer < ApplicationMailer
  include SnackHelper

  def snack_vote_email(email:, snacks:)
    puts 'inside Mailer'
    @snack_votes = snacks.sort_by { |k| k[:vote_count_yes] }
    puts sorted_snacks
    mail(to: email, subject: 'Biweekly Snack Votes')
  end
end
