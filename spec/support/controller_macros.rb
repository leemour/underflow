module ControllerMacros
  def login_user(email=nil, password=nil)
    args = {email: email, password: password}
    args.delete_if {|k, v| v.nil?}
    @request.env["devise.mapping"] = Devise.mappings[:user]
    @user = FactoryBot.create(:user, args)
    # user.confirm! # or set a confirmed_at inside the factory. Only necessary if you are using the "confirmable" module
    sign_in @user
  end
  def login_existing_user(user)
    sign_in user
  end
end