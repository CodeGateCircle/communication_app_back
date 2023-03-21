Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV['GOOGLE_CLIENT_ID'], ENV['GOOGLE_CLIENT_SECRET'],
    {
      scope: 'email, profile',
      prompt: 'select_account',
      image_aspect_ratio: 'square',
      image_size: 50,
      :provider_ignores_state => true
    }

  # config/initializers/omniauth.rb
  OmniAuth.config.full_host = Rails.env.production? ? 'https://domain.com' : 'http://localhost:3000'
end