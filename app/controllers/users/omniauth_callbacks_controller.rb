class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
   
  # すでにアカウントがあったらログイン、なかったら登録ページへ
  def facebook
    #dryなコードにリファクタリングすること 
    # 
    # facebook認証で取得した情報オブジェクトを生成
    @user = User.from_omniauth(request.env["omniauth.auth"].except("extra"))
  #DBにあればログイン、なければ 
        if @user.persisted?
            sign_in_and_redirect @user
            # ここにnoticeを入れておきたい
            # 
            # 
            # 
        else
            session["devise.user_attributes"] = @user.attributes
            redirect_to new_user_registration_url
        end
    end

    def twitter
        @user = User.from_omniauth(request.env["omniauth.auth"].except("extra"))

        if @user.persisted?
            sign_in_and_redirect @user
        else
            session["devise.user_attributes"] = @user.attributes
            redirect_to new_user_registration_url
        end
    end

     def google_oauth2
        @user = User.from_omniauth(request.env["omniauth.auth"].except("extra"))

        if @user.persisted?
            sign_in_and_redirect @user
        else
            session["devise.user_attributes"] = @user.attributes
            redirect_to new_user_registration_url
        end
    end
   
end