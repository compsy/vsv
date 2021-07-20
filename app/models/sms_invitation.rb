# frozen_string_literal: true

class SmsInvitation < Invitation
  def send_invite(plain_text_token)
    return if invitation_set.person.mobile_phone.blank?

    SendSms.run!(send_sms_attributes(plain_text_token))
  end

  private

  def send_sms_attributes(plain_text_token)
    {
      number: invitation_set.person.mobile_phone,
      text: generate_message(plain_text_token),
      reference: generate_reference
    }
  end

  def generate_message(plain_text_token)
    "#{invitation_set.invitation_text} #{invitation_set.invitation_url(plain_text_token)}"
  end

  def generate_reference
    "vsv-#{invitation_set.id}"
  end
end
