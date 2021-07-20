# frozen_string_literal: true

# db_title = 'Demo vragenlijst' # Dagboekvragenlijst moet geen titel hebben alleen een logo
#
# db_name1 = 'demo'
# dagboek1 = Questionnaire.find_by(name: db_name1)
# dagboek1 ||= Questionnaire.new(name: db_name1)
# dagboek1.key = File.basename(__FILE__)[0...-3]
# dagboek_content = [
#   {
#     type: :raw,
#     content: '<p class="flow-text">Hier staat een demo vragenlijst voor u klaar. Dit staat in een RAW tag</p>'
#   }, {
#     id: :v1, # 1
#     type: :radio,
#     show_otherwise: false,
#     title: 'Voorbeeld van een radio',
#     options: [
#       { title: 'Ja', shows_questions: %i[v2] },
#       { title: 'Nee', shows_questions: %i[v2] }
#     ]
#   }, {
#     id: :v2,
#     hidden: true,
#     type: :range,
#     title: 'Voorbeeld met een range',
#     labels: ['heel weinig', 'heel veel']
#   }, {
#     id: :v3,
#     type: :time,
#     hours_from: 0,
#     hours_to: 11,
#     hours_step: 1,
#     title: 'Voorbeeld van een time vraag',
#     section_start: 'Overige vragen'
#   }, {
#     id: :v4,
#     type: :date,
#     title: 'Voorbeeld van een date vraag',
#     labels: ['helemaal intuïtief ', 'helemaal gepland']
#   }, {
#     id: :v5,
#     type: :textarea,
#     placeholder: 'Hier staat standaard tekst',
#     title: 'Voorbeeld van een textarea'
#   }, {
#     id: :v6,
#     type: :textfield,
#     placeholder: 'Hier staat standaard tekst',
#     title: 'Voorbeeld van een textfield'
#   }, {
#     id: :v7,
#     type: :checkbox,
#     required: true,
#     title: 'Voorbeeld van een checkbox vraag',
#     options: [
#       { title: 'Antwoord 1', tooltip: 'Tooltip 1' },
#       { title: 'Antwoord 2', tooltip: 'Tooltip 2' },
#       { title: 'Antwoord 3', tooltip: 'Tooltip 3' }
#     ]
#   }, {
#     id: :v8,
#     type: :likert,
#     title: 'Voorbeeld van een likertschaal',
#     tooltip: 'some tooltip',
#     options: ['helemaal oneens', 'oneens', 'neutraal', 'eens', 'helemaal eens']
#   }, {
#     id: :v9,
#     type: :number,
#     title: 'Voorbeeld van een numeriek veld',
#     tooltip: 'some tooltip',
#     maxlength: 4,
#     placeholder: '1234',
#     min: 0,
#     max: 9999,
#     required: true
#   }, {
#     id: :v10,
#     type: :textfield,
#     placeholder: 'Hier staat standaard tekst',
#     title: 'Voorbeeld van een klein vrij textveld'
#   }, {
#     id: :v11,
#     title: 'Voorbeeld van een expandable',
#     remove_button_label: 'Verwijder',
#     add_button_label: 'Voeg toe',
#     type: :expandable,
#     default_expansions: 1,
#     max_expansions: 10,
#     content: [
#       {
#         id: :v11_1,
#         type: :checkbox,
#         title: 'Met een checkbox vraag',
#         options: [
#           'Antwoord A',
#           'Antwoord B',
#           'Antwoord C',
#           'Antwoord D',
#           'Antwoord E',
#           'Antwoord F'
#         ]
#       }
#     ]
#   }, {
#     id: :v12,
#     type: :dropdown,
#     title: 'Waar hadden de belangrijkste gebeurtenissen mee te maken?',
#     options: ['hobby/sport', 'werk', 'vriendschap', 'romantische relatie', 'thuis']
#   }
# ]
# dagboek1.content = { questions: dagboek_content, scores: [] }
# dagboek1.title = db_title
# dagboek1.save!
