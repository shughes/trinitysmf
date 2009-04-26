class UserMailer < ActionMailer::Base
   def confirm(user, data)
      @subject    = 'Trinity SMF Network'
      @body["user"] = user
      @body["data"] = data
      @recipients = user.email
      @from       = 'Hughes, Samuel <samuel.hughes@trinitysmf.net>'
   end

   def email_all(data)
      @subject = data[:subject]
      @body["message"] = data[:message]
      @recipients = data[:from]
      @from = data[:from]
      @bcc = data[:bcc]
   end


   def email_user(user, message)
      @subject    = message.subject
      @body["user"] = user
      @body["message"] = message.message
      @recipients = user.email
      @from       = message.from
   end

   def site_update(user, data)
      @subject    = 'Trinity SMF Network Updates'
      @body["user"] = user
      @body["data"] = data
      @recipients = user.email
      @from       = 'Hughes, Samuel <samuel.hughes@trinitysmf.net>'
   end

   def sent(user)
      @subject    = 'test'
      @body["user"] = user
      @recipients = user.email
      @from       = 'Hughes, Samuel <samuel.hughes@trinitysmf.net>'
   end
end
