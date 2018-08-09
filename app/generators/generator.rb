# frozen_string_literal: true

class Generator
  include ActionView::Helpers

  TOOLTIP_DURATION = 6000
  OTHERWISE_TEXT = 'Anders, namelijk:'
  OTHERWISE_PLACEHOLDER = 'Vul iets in'
  TEXTAREA_PLACEHOLDER = 'Vul iets in'
  TEXTFIELD_PLACEHOLDER = 'Vul iets in'
  DATEFIELD_PLACEHOLDER = 'Vul een datum in'

  def generate(_question)
    throw 'Generate not implemented!'
  end

  def self.idify(*strs)
    strs.map { |x| x.to_s.parameterize.underscore }.join('_')
  end

  def idify(*strs)
    strs.map { |x| x.to_s.parameterize.underscore }.join('_')
  end

  private

  def generate_tooltip(tooltip_content)
    return nil if tooltip_content.blank?
    tooltip_body = content_tag(:i, 'info', class: 'tooltip flow-text material-icons info-outline')
    content_tag(:a,
                tooltip_body,
                onclick: "M.toast({html: '#{tooltip_content.gsub("'", %q(\\\'))}'}, #{TOOLTIP_DURATION})")
  end

  def placeholder(question, default_placeholder)
    question[:placeholder].present? ? question[:placeholder] : default_placeholder
  end

  def answer_name(name)
    "content[#{name}]"
  end

  def add_shows_hides_questions(tag_options, shows_questions, hides_questions)
    tag_options = add_show_hide_question(tag_options, shows_questions, :shows_questions)
    tag_options = add_show_hide_question(tag_options, hides_questions, :hides_questions)
    tag_options
  end

  def add_show_hide_question(tag_options, questions_to_toggle, key)
    if questions_to_toggle.present?
      questions_to_toggle_str = questions_to_toggle.map { |qid| idify(qid) }.inspect
      append_tag(tag_options, :data, key => questions_to_toggle_str)
    end
    tag_options
  end

  def append_tag(tag_options, field, data)
    # The append_tag function allows us to specify both shows and hides attributes
    # in one question
    tag_options[field] ||= {}
    tag_options[field] = tag_options[field].merge data
  end

  def stop_subscription_token(option, answer_key, answer_value, response_id)
    return nil unless option[:stop_subscription]
    tag(:input, name: stop_subscription_name(answer_key),
                type: 'hidden',
                value: Response.stop_subscription_token(answer_key, answer_value, response_id))
  end

  def stop_subscription_name(name)
    "stop_subscription[#{name}]"
  end

  # Move next functions to specific super for radio and check?
  def add_otherwise_label(question)
    question[:raw][:otherwise_label] = OTHERWISE_TEXT if question[:raw][:otherwise_label].blank?
    question[:otherwise_label] = OTHERWISE_TEXT if question[:otherwise_label].blank?
    question
  end

  def add_raw_to_option(option, question, idx)
    raw_option = question[:raw][:options][idx]
    raw_option = { title: raw_option } unless raw_option.is_a?(Hash)
    option = option.deep_dup
    option = { title: option } unless option.is_a?(Hash)
    option[:raw] = raw_option
    option
  end


  def option_body_wrap(question_id, option, wrapped_tag, answer_key, answer_value, response_id)
    option_body = safe_join(
      [
        wrapped_tag,
        content_tag(:span,
                    option[:title].html_safe,
                    class: 'flow-text')
      ]
    )

    option_body = safe_join(
      [
        content_tag(:label,
                    option_body,
                    for: idify(question_id, option[:raw][:title]),
                    class: 'flow-text'),
        generate_tooltip(option[:tooltip])
      ]
    )

    option_body = safe_join(
      [
        content_tag(:p, option_body),
        stop_subscription_token(option, answer_key, answer_value, response_id)
      ]
    )
    option_body
  end

  def otherwise_option_label(question)
    content_tag(:label,
                question[:otherwise_label].html_safe,
                for: idify(question[:id], question[:raw][:otherwise_label]),
                class: 'flow-text')
  end

  def otherwise_textfield(question)
    # Used for both radios and checkboxes
    option_field = safe_join([
                               tag(:input,
                                   id: idify(question[:id], question[:raw][:otherwise_label], 'text'),
                                   name: answer_name(idify(question[:id], question[:raw][:otherwise_label], 'text')),
                                   type: 'text',
                                   disabled: true,
                                   required: true,
                                   class: 'validate otherwise'),
                               otherwise_textfield_label(question)
                             ])
    option_field = content_tag(:div, option_field, class: 'input-field inline')
    option_field
  end

  def otherwise_textfield_label(question)
    content_tag(:label,
                OTHERWISE_PLACEHOLDER,
                for: idify(question[:id], question[:raw][:otherwise_label], 'text'))
  end

end
