namespace :doorkeeper do
  desc "Copy fresh access token to clipboard"
  task token: :environment do
    t = Doorkeeper::AccessToken.first
    t.created_at = Time.now
    t.save!
    puts t.token
    system "echo #{t.token} | xclip -selection clipboard"
    puts 'Token copied to clipboard'
  end
end