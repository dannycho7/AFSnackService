# Preview all emails at http://localhost:3000/rails/mailers/snack_vote_mailer
class SnackVoteMailerPreview < ActionMailer::Preview

  def snack_vote_email
    test_snacks = [
      {
        name: 'chips',
        vote_count_yes: 2,
        vote_count_no: 1
      },
      {
        name: 'cookies',
        vote_count_yes: 1,
        vote_count_no: 0
      }
    ]
    SnackVoteMailer.snack_vote_email(email: 'yue.zheng@appfolio.com', snacks: test_snacks)
  end
end
