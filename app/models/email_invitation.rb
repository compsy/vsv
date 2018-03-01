class EmailInvitation < Invitation
  def send(plain_text_token)
    return unless invitation_set.person.email.present?
    begin
      # TODO: check if generate_message should have the url included
      mailer = InvitationMailer.invitation_mail(invitation_set.person.email,
                                                generate_message(plain_text_token),
                                                invitation_url(plain_text_token))
      mailer.deliver_now
    rescue StandardError => e
      Rails.logger.warn "[Attention] Mailgun failed again: #{e.message}"
      Rails.logger.warn e.backtrace.inspect
    end
    sent!
  end
end
