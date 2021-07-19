# frozen_string_literal: true

class QuestionTypeGenerator < Generator
  TOOLTIP_MIN_DURATION = 3000
  MILLISEC_PER_CHARACTER = 70
  OTHERWISE_TEXT = 'Anders, namelijk:'
  OTHERWISE_PLACEHOLDER = 'Vul iets in'

  def generate(_question)
    raise 'Generate not implemented!'
  end

  private

  def generate_tooltip(tooltip_content)
    return nil if tooltip_content.blank?

    tooltip_body = tag.i('info', class: 'tooltip flow-text material-icons info-outline')
    tag.a(tooltip_body,
          onclick: "M.toast({html: '#{tooltip_content.gsub("'", %q(\\\'))}'," \
                   " displayLength: #{tooltip_duration(tooltip_content)}});autoResizeImages();")
  end

  def tooltip_duration(tooltip_content)
    TOOLTIP_MIN_DURATION + tooltip_content.length * MILLISEC_PER_CHARACTER
  end

  def placeholder(question, default_placeholder)
    question[:placeholder].presence || default_placeholder
  end

  def answer_name(name)
    "content[#{name}]"
  end

  def add_shows_hides_questions(tag_options, shows_questions, hides_questions)
    tag_options = add_show_hide_question(tag_options, shows_questions, :shows_questions)
    add_show_hide_question(tag_options, hides_questions, :hides_questions)
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

  def decorate_with_otherwise(question, option_body)
    option_body = wrap_toggle_in_label(
      option_body,
      question[:otherwise_label].html_safe,
      idify(question[:id], question[:raw][:otherwise_label])
    )

    wrap_toggle_with_textfield(
      question,
      option_body
    )
  end

  def decorate_with_label(question, option_body, option)
    option_body = wrap_toggle_in_label(
      option_body,
      option[:title].html_safe,
      idify(question[:id], option[:raw][:value].presence || option[:raw][:title])
    )

    option_body = safe_join(
      [
        option_body,
        generate_tooltip(option[:tooltip])
      ]
    )

    wrap_option_body(option_body, question[:type])
  end

  def wrap_option_body(option_body, question_type)
    if %i[radio checkbox days].include? question_type.to_sym
      tag.p(option_body, class: 'option-label')
    else
      tag.p(option_body)
    end
  end

  # Move next functions to specific super for radio and check?
  def wrap_toggle_with_textfield(question, option_body)
    option_body = safe_join(
      [
        option_body,
        otherwise_textfield(question),
        generate_tooltip(question[:otherwise_tooltip])
      ]
    )

    tag.div(option_body, class: 'otherwise-textfield')
  end

  def wrap_toggle_in_label(option_body, label, for_question)
    option_body = safe_join([
                              option_body,
                              tag.span(
                                label
                              )
                            ])

    tag.label(option_body,
              for: for_question)
  end

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
    tag.div(option_field, class: 'input-field inline')
  end

  def otherwise_textfield_label(question)
    tag.label(question[:otherwise_placeholder].presence || OTHERWISE_PLACEHOLDER,
              for: idify(question[:id], question[:raw][:otherwise_label], 'text'))
  end
end
