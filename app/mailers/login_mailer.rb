class LoginMailer < ApplicationMailer
  default from: 'from@example.com'
  layout 'mailer'

  def send_magic_link(authorization, token, redirect)
    @token = token
    @uid = Digest::SHA2.new(512).hexdigest(authorization.uid)
    @redirect = redirect
    mail(to: authorization.email,
         subject: 'Login to Queer Tango Collective')
  end
end
