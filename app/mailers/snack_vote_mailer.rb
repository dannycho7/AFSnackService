class SnackVoteMailer < ApplicationMailer
  include SnackHelper
  default from: 'example@example.com'

  def snack_vote_email(email)
    puts 'inside Mailer'
    @snack_votes = sorted_snacks.sort_by { |k| k[:votes] }
    puts sorted
    mail(to: email, subject: 'Welcome to My Awesome Site')
  end
end
