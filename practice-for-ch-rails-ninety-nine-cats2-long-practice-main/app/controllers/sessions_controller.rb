class SessionsController < ApplicationController 
    before_action :require_logged_in, only: [:new, :create]
    before_action :require_logged_out, only: [:destroy]
    def new 
        @user = User.new 
        render :new 
    end

    def create 
        @user = User.find_by_credential(params[:user][:username], params[:user][:password])
        if @user 
            login(@user)
        else 
            redirect_to new_session_url
        end
    end

    def destroy 
        if logged_in? 
            logout!
        end
        redirect_to new_session_url

    end
end 
