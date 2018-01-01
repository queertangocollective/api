class Authorization < ApplicationRecord
  belongs_to :group
  belongs_to :person
  has_many :authorization_sessions, dependent: :destroy

  def update_tracked_fields(request)
    old_current, new_current = self.current_sign_in_at, Time.now.utc
    self.last_sign_in_at     = old_current || new_current
    self.current_sign_in_at  = new_current

    old_current, new_current = self.current_sign_in_ip, request.remote_ip
    self.last_sign_in_ip     = old_current || new_current
    self.current_sign_in_ip  = new_current
  end

  def self.from_oauth(auth)
    authorization = where(provider: auth[:provider], uid: auth[:uid]).first
    if authorization.nil?
      authorization = find_by_email(auth[:email])
      # Instantiate the user for the first time
      if authorization
        authorization.provider = auth[:provider]
        authorization.uid = auth[:uid]
        authorization.email = auth[:email]
        authorization.avatar = auth[:image]
        authorization.save
      end
    end
    authorization
  end
end
