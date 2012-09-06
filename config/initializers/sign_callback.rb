Warden::Manager.after_authentication do |user,auth,opts|
	user.update_attribute(:sign_in_status, 1)
end

Warden::Manager.before_logout do |user,auth,opts|
	user.update_attribute(:sign_in_status, 0)
end