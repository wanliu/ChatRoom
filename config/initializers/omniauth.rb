Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, 'CONSUMER_KEY', 'CONSUMER_SECRET'
  #provider  :github,'4d2a1defa8700f396d2a','ecb44c6cfba6d082f8f6cd021a04f86fdbe65bba'
   provider  :github,'06d38ffc85873a3eb7f2','b58b8cf7a3d5653e285879832003c33c7e992d6a', scope: "user"
    #skip_info:true
    #scope:"user"
  provider  :google_oauth2,'1037229623179-o9i3la6u7k56flbmfvv8rcphb4ci394t.apps.googleusercontent.com','Z7fOGjzcG3qByu1z2gjjyrpl'

 #4d2a1defa8700f396d2a
 #ecb44c6cfba6d082f8f6cd021a04f86fdbe65bba
end
