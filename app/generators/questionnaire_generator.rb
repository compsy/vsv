# frozen_string_literal: true

class QuestionnaireGenerator
  extend ActionView::Helpers

  OTHERWISE_TEXT = 'Anders, namelijk:'
  OTHERWISE_PLACEHOLDER = 'Vul iets in'
  TEXTAREA_PLACEHOLDER = 'Vul iets in'

  class << self
    def generate_questionnaire(response_id, content, title, submit_text, action, authenticity_token)
      title, content = substitute_variables(response_id, title, content)
      body = safe_join([
                         questionnaire_header(title),
                         questionnaire_hidden_fields(response_id, authenticity_token),
                         questionnaire_questions(content),
                         submit_button(submit_text)
                       ])
      body = content_tag(:form, body, action: action, class: 'col s12', 'accept-charset': 'UTF-8', method: 'post')
      body
    end

    private

    def substitute_variables(response_id, title, content)
      response = Response.find(response_id)
      return [title, content] if response.blank?
      student, mentor = response.determine_student_mentor
      [title, content].map do |obj|
        VariableEvaluator.evaluate_obj(obj,
                                       mentor&.organization&.mentor_title,
                                       mentor&.gender,
                                       student.first_name,
                                       student.gender)
      end
    end

    def questionnaire_header(title)
      return ''.html_safe if title.blank?
      header_body = content_tag(:h4, title, class: 'header')
      header_body = content_tag(:div, header_body, class: 'col s12')
      header_body = content_tag(:div, header_body, class: 'row')
      header_body
    end

    def questionnaire_hidden_fields(response_id, authenticity_token)
      hidden_body = []
      hidden_body << tag(:input, name: 'utf8', type: 'hidden', value: '&#x2713;'.html_safe)
      hidden_body << tag(:input, name: 'authenticity_token', type: 'hidden', value: authenticity_token)
      hidden_body << tag(:input, name: 'response_id', type: 'hidden', value: response_id)
      safe_join(hidden_body)
    end

    def questionnaire_questions(content)
      body = []
      content.each do |question|
        question_body = case question[:type]
                        when :radio
                          generate_radio(question)
                        when :checkbox
                          generate_checkbox(question)
                        when :range
                          generate_range(question)
                        when :textarea
                          generate_textarea(question)
                        when :raw
                          generate_raw(question)
                        else
                          raise 'Unknown question type'
                        end
        question_body = content_tag(:div, question_body, class: 'col s12')
        body = questionnaire_questions_add_question_section(body, question_body, question)
      end
      safe_join(body)
    end

    def questionnaire_questions_add_question_section(body, question_body, question)
      body << section_start(question[:section_start], question) unless question[:section_start].blank?
      body << content_tag(:div, question_body, class: question_klasses(question))
      body << section_end(question[:section_end], question) unless question[:section_end].blank?
      body
    end

    def question_klasses(question)
      klasses = 'row section'
      klasses += " hidden #{idify(question[:id], 'toggle')}" if question[:hidden].present?
      klasses
    end

    def section_start(section_title, question)
      body = content_tag(:h5, section_title)
      body = content_tag(:div, body, class: 'col s12')
      klasses = 'extra-spacing row'
      klasses += " hidden #{idify(question[:id], 'toggle')}" if question[:hidden].present?
      body = content_tag(:div, body, class: klasses)
      body
    end

    def section_end(_unused_arg, question)
      body = content_tag(:div, nil, class: 'divider')
      body = content_tag(:div, body, class: 'col s12')
      klasses = 'row'
      klasses += " hidden #{idify(question[:id], 'toggle')}" if question[:hidden].present?
      body = content_tag(:div, body, class: klasses)
      body
    end

    def submit_button(submit_text)
      submit_body = content_tag(:button,
                                submit_text,
                                type: 'submit',
                                class: 'btn waves-effect waves-light')
      submit_body = content_tag(:div, submit_body, class: 'col s12')
      submit_body = content_tag(:div, submit_body, class: 'row section')
      submit_body
    end

    def answer_name(name)
      "content[#{name}]"
    end

    def generate_radio(question)
      # TODO: Add radio button validation error message
      question[:otherwise_label] = OTHERWISE_TEXT if question[:otherwise_label].blank?
      safe_join([
                  content_tag(:p, question[:title].html_safe, class: 'flow-text'),
                  radio_options(question),
                  radio_otherwise(question)
                ])
    end

    def radio_options(question)
      body = []
      question[:options].each do |option|
        body << radio_option_body(question[:id], option)
      end
      safe_join(body)
    end

    def radio_option_body(question_id, option)
      option = { title: option } unless option.is_a?(Hash)
      elem_id = idify(question_id, option[:title])
      tag_options = {
        name: answer_name(idify(question_id)),
        type: 'radio',
        id: elem_id,
        value: option[:title],
        required: true,
        class: 'validate'
      }
      tag_options = add_shows_questions(tag_options, option[:shows_questions])
      wrapped_tag = tag(:input, tag_options)
      option_body_wrap(question_id, option[:title], wrapped_tag)
    end

    def add_shows_questions(tag_options, shows_questions)
      if shows_questions.present?
        shows_questions_str = shows_questions.map { |qid| idify(qid) }.inspect
        tag_options[:data] = { shows_questions: shows_questions_str }
      end
      tag_options
    end

    def radio_otherwise(question)
      option_body = safe_join([
                                radio_otherwise_option(question),
                                otherwise_textfield(question)
                              ])
      option_body = content_tag(:div, option_body, class: 'otherwise-textfield')
      option_body
    end

    def radio_otherwise_option(question)
      safe_join([
                  tag(:input,
                      name: answer_name(idify(question[:id])),
                      type: 'radio',
                      id: idify(question[:id], question[:otherwise_label]),
                      value: question[:otherwise_label],
                      required: true,
                      class: 'otherwise-option'),
                  content_tag(:label,
                              question[:otherwise_label],
                              for: idify(question[:id], question[:otherwise_label]),
                              class: 'flow-text')
                ])
    end

    def otherwise_textfield(question)
      # Used for both radios and checkboxes
      option_field = safe_join([
                                 tag(:input,
                                     id: idify(question[:id], question[:otherwise_label], 'text'),
                                     name: answer_name(idify(question[:id], question[:otherwise_label], 'text')),
                                     type: 'text',
                                     disabled: true,
                                     required: true,
                                     class: 'validate otherwise'),
                                 content_tag(:label,
                                             OTHERWISE_PLACEHOLDER,
                                             for: idify(question[:id], question[:otherwise_label], 'text'))
                               ])
      option_field = content_tag(:div, option_field, class: 'input-field inline')
      option_field
    end

    def generate_checkbox(question)
      question[:otherwise_label] = OTHERWISE_TEXT if question[:otherwise_label].blank?
      safe_join([
                  content_tag(:p, question[:title].html_safe, class: 'flow-text'),
                  checkbox_options(question),
                  checkbox_otherwise(question)
                ])
    end

    def checkbox_options(question)
      body = []
      question[:options].each do |option|
        body << checkbox_option_body(question[:id], option)
      end
      safe_join(body)
    end

    def checkbox_option_body(question_id, option)
      option = { title: option } unless option.is_a?(Hash)
      elem_id = idify(question_id, option[:title])
      tag_options = {
        type: 'checkbox',
        id: elem_id,
        name: answer_name(elem_id),
        value: true
      }
      tag_options = add_shows_questions(tag_options, option[:shows_questions])
      wrapped_tag = tag(:input, tag_options)
      option_body_wrap(question_id, option[:title], wrapped_tag)
    end

    def option_body_wrap(question_id, title, wrapped_tag)
      option_body = safe_join([
                                wrapped_tag,
                                content_tag(:label,
                                            title,
                                            for: idify(question_id, title),
                                            class: 'flow-text')
                              ])
      option_body = content_tag(:p, option_body)
      option_body
    end

    def checkbox_otherwise(question)
      option_body = safe_join([
                                checkbox_otherwise_option(question),
                                otherwise_textfield(question)
                              ])
      option_body = content_tag(:div, option_body, class: 'otherwise-textfield')
      option_body
    end

    def checkbox_otherwise_option(question)
      safe_join([
                  tag(:input,
                      type: 'checkbox',
                      id: idify(question[:id], question[:otherwise_label]),
                      name: answer_name(idify(question[:id], question[:otherwise_label])),
                      value: true,
                      class: 'otherwise-option'),
                  content_tag(:label,
                              question[:otherwise_label],
                              for: idify(question[:id], question[:otherwise_label]),
                              class: 'flow-text')
                ])
    end

    def generate_range(question)
      safe_join([
                  content_tag(:p, question[:title].html_safe, class: 'flow-text'),
                  range_slider(question),
                  range_labels(question)
                ])
    end

    def range_slider(question)
      minmax = range_slider_minmax(question)
      range_body = tag(:input,
                       type: 'range',
                       id: idify(question[:id]),
                       name: answer_name(idify(question[:id])),
                       min: minmax[:min].to_s,
                       max: minmax[:max].to_s,
                       required: true)
      range_body = content_tag(:p, range_body, class: 'range-field')
      range_body
    end

    def range_slider_minmax(question)
      range_min = 0
      range_max = 100
      range_min = [range_min, question[:min]].max if question[:min].present? && question[:min].is_a?(Integer)
      range_max = [range_min + 1, question[:max]].max if question[:max].present? && question[:max].is_a?(Integer)
      { min: range_min, max: range_max }
    end

    def range_labels(question)
      # Works best with 2, 3, or 4 labels
      labels_body = []
      col_class = 12 / [question[:labels].size, 1].max
      question[:labels].each_with_index do |label, idx|
        align_class = case idx
                      when 0
                        'left-align'
                      when (question[:labels].size - 1)
                        'right-align'
                      else
                        'center-align'
                      end
        labels_body << content_tag(:div, label, class: "col #{align_class} s#{col_class}")
      end
      labels_body = safe_join(labels_body)
      labels_body = content_tag(:div, labels_body, class: 'row')
      labels_body
    end

    def generate_textarea(question)
      safe_join([
                  content_tag(:p, question[:title].html_safe, class: 'flow-text'),
                  textarea_field(question)
                ])
    end

    def textarea_field(question)
      body = []
      body << content_tag(:textarea,
                          nil,
                          id: idify(question[:id]),
                          name: answer_name(question[:id]),
                          class: 'materialize-textarea')
      body << content_tag(:label,
                          TEXTAREA_PLACEHOLDER,
                          for: idify(question[:id]),
                          class: 'flow-text')
      body = safe_join(body)
      body = content_tag(:div, body, class: 'input-field col s12')
      body = content_tag(:div, body, class: 'row')
      body
    end

    def generate_raw(question)
      question[:content].html_safe
    end

    def idify(*strs)
      strs.map { |x| x.to_s.parameterize.underscore }.join('_')
    end
  end
end
