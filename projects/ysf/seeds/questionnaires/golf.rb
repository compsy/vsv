# frozen_string_literal: true

title = 'Golf'
name = 'KCT Golf'
questionnaire = Questionnaire.find_by(name: name)
questionnaire ||= Questionnaire.new(name: name)
questionnaire.key = File.basename(__FILE__)[0...-3]

def create_question(id, title, image,options, section_end)
  res = {
    id: id,
    type: :likert,
    title: "<p class=\"flow-text\">#{title}</p><img src=\"/images/questionnaires/kct/#{image}\" style=\"width: 80%; margin-left: 3rem;\" />",
    options: options,
    show_otherwise: false
  }
  res[:section_end] = true if section_end
  res
end

def rotate_question(id, title, image, section_end: false)
  create_question(id, title, image, [
      "A",
      "B",
      "C",
      "D",
      "E",
      "F",
      "G",
      "H"
    ], section_end)
end

content = [
  {
    type: :raw,
    title: 'Figuren draaien',
    content: '
    <p class="flow-text section-explanation">
      Op deze pagina staan 24 kubussen. Dit is het tweede onderdeel van de IQ test; het kost
      je nog ongeveer 30 minuten. De onderstaande kubussen hebben op iedere zijkant
      een andere afbeelding.<br><br>Kun je bij de onderstaande opdrachten aangeven
      welke kubus een gekantelde versie zou kunnen zijn van de
      linker kubus (de kubus waar een X onder staat).
    </p>'
  },
  rotate_question(:v1,  "1.", 'HGIN_3D_001.png'),
  rotate_question(:v2,  "2.", 'HGIN_3D_002.png'),
  rotate_question(:v3,  "3.", 'HGIN_3D_003.png'),
  rotate_question(:v4,  "4.", 'HGIN_3D_004.png'),
  rotate_question(:v5,  "5.", 'HGIN_3D_005.png'),
  rotate_question(:v6,  "6.", 'HGIN_3D_006.png'),
  rotate_question(:v7,  "7.", 'HGIN_3D_007.png'),
  rotate_question(:v8,  "8.", 'HGIN_3D_008.png'),
  rotate_question(:v9,  "9.", 'HGIN_3D_009.png'),
  rotate_question(:v10, "10.", 'HGIN_3D_010.png'),
  rotate_question(:v11, "11.", 'HGIN_3D_011.png'),
  rotate_question(:v12, "12.", 'HGIN_3D_012.png'),
  rotate_question(:v13, "13.", 'HGIN_3D_013.png'),
  rotate_question(:v14, "14.", 'HGIN_3D_014.png'),
  rotate_question(:v15, "15.", 'HGIN_3D_015.png'),
  rotate_question(:v16, "16.", 'HGIN_3D_016.png'),
  rotate_question(:v17, "17.", 'HGIN_3D_017.png'),
  rotate_question(:v18, "18.", 'HGIN_3D_018.png'),
  rotate_question(:v19, "19.", 'HGIN_3D_019.png'),
  rotate_question(:v20, "20.", 'HGIN_3D_020.png'),
  rotate_question(:v21, "21.", 'HGIN_3D_021.png'),
  rotate_question(:v22, "22.", 'HGIN_3D_022.png'),
  rotate_question(:v23, "23.", 'HGIN_3D_023.png'),
  rotate_question(:v24, "24.", 'HGIN_3D_024.png')
]
questionnaire.content = { questions: content, scores: [] }
questionnaire.title = title
questionnaire.save!
