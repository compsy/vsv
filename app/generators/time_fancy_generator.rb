# frozen_string_literal: true

class TimeFancyGenerator < QuestionTypeGenerator
  TIME_FANCY_PLACEHOLDER = 'Vul een tijd in'

  def generate(question)
    title = safe_join([question[:title].html_safe, generate_tooltip(question[:tooltip])])
    safe_join([tag.p(title, class: 'flow-text'), mytime_fancy_field(question)])
  end

  private

  def mytime_fancy_field(question)
    body = safe_join([
                       mytime_fancy_tag(question),
                       mytime_fancy_label(question)
                     ])
    body = tag.div(body, class: 'input-field col s12 m6')
    tag.div(body, class: 'row')
  end

  def mytime_fancy_tag(question)
    tag(
      :input,
      type: 'text',
      id: idify(question[:id]),
      name: answer_name(question[:id]),
      required: question[:required].present?,
      class: 'timepicker'
    )
  end

  def mytime_fancy_label(question)
    tag.label(placeholder(question, TIME_FANCY_PLACEHOLDER),
              for: idify(question[:id]),
              class: 'flow-text')
  end
end
