Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :twitter, 'CONSUMER_KEY', 'CONSUMER_SECRET'
  #provider :github,'4d2a1defa8700f396d2a','ecb44c6cfba6d082f8f6cd021a04f86fdbe65bba'
  provider :github,'377864c65a1b299a2940','b8b93896bf9ac6e1a797244d18c6a5cf59e4bd26', scope: "user"
    #skip_info:true
    #scope:"user"
  #provider :google_oauth2,'1037229623179-o9i3la6u7k56flbmfvv8rcphb4ci394t.apps.googleusercontent.com','Z7fOGjzcG3qByu1z2gjjyrpl'
  provider :google_oauth2,'401847620127.apps.googleusercontent.com','OgN3V2cq_dB1IWYGSBotV-X_'

end
