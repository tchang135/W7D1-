# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
    validates :username, :session_token, presence: true, uniqueness: true
    validates :password_digest, presence: true
    before_validation :ensure_session_token

    def password=(new_pass)
        self.password_digest = BCrypt::Password.create(new_pass)
        @password = new_pass
    end

    def is_password?(password)
        password_obj = BCrypt::Password.new(password_digest)
        password_obj.is_password(password)
    end

    def self.find_by_credential(username, password)
        user = User.find_by(username: username)
        if user && is_password?(password)
            user
        else 
            nil
        end
    end

    def reset_session_token!
        self.session_token = generate_unique_session_token
        self.save!
        self.session_token
    end

    private
    
    def generate_unique_session_token
        SecureRandom::urlsafe_base64
    end

    def ensure_session_token
        self.session_token ||= generate_unique_session_token
    end
end
