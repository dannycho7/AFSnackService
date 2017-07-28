desc 'This task is called by the Heroku scheduler add-on'
task :email_results => :environment do
  helper = SnackVoteController.new
  puts 'Emailing results...'
  helper.send_results_email
  puts 'done.'
end
