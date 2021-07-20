# frozen_string_literal: true

# ic_name1 = 'demo-ic'
# informed_consent1 = Questionnaire.find_by(name: ic_name1)
# informed_consent1 ||= Questionnaire.new(name: ic_name1)
# informed_consent1.key = File.basename(__FILE__)[0...-3]
# ic_content = <<~'END'
#   <p class="flow-text"><em>Beste onderzoeksdeelnemer,</em></p>
#   <p class="flow-text">Dit is een voorbeeld van een informed consent.</p>
# END
# informed_consent1.content = { questions: [{
#   type: :raw,
#   content: ic_content
# }, {
#   id: :v1,
#   type: :checkbox,
#   required: true,
#   title: '',
#   options: [
#     'Ik verklaar dat bovenstaande informatie mij duidelijk is en ga hiermee akkoord.'
#   ],
#   show_otherwise: false
# }], scores: [] }
# informed_consent1.title = ''
# informed_consent1.save!
