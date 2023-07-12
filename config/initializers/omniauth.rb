github_key = ENV['ONC_GITHUB_KEY'] || Rails.application.credentials.github_key
github_secret = ENV['ONC_GITHUB_SECRET'] || Rails.application.credentials.github_secret

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, github_key, github_secret, scope: 'read:org'
end
