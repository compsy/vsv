# frozen_string_literal: true

class QuestionnaireTranslator
  class << self
    def translate_content(content, locale)
      @locale = locale
      translate_content_aux(content)
    end

    private

    def translate_content_aux(content)
      return content if content.blank?

      if content.is_a?(Hash)
        # replace with translation
        return translate_content_aux(content[@locale]) if content.key?(@locale)

        return translate_content_aux(content[@locale.to_sym]) if content.key?(@locale.to_sym)

        content.keys.each do |key|
          content[key] = translate_content_aux(content[key])
        end
        return content
      end
      return content.map { |value| translate_content_aux(value) } if content.is_a?(Array)

      content
    end
  end
end
