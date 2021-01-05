# frozen_string_literal: true

title = 'Echo VCO'
name = 'KCT Echo VCO'
questionnaire = Questionnaire.find_by(name: name)
questionnaire ||= Questionnaire.new(name: name)
questionnaire.key = File.basename(__FILE__)[0...-3]

def create_question(id, title, section_end: false)
  res = {
    id: id,
    type: :range,
    title: title,
    step: 10,
    min: 0,
    max: 100,
    labels: [
     'helemaal niet zeker',
     'neutraal',
     'heel erg zeker',
    ],
  }
  res[:section_end] = true if section_end
  res
end

content = [
  {
    type: :raw,
    content: '
    <p class="flow-text section-explanation">
      Vul onderstaande vragen eerlijk in.
    </p>
    <p class="flow-text section-explanation">
      Hoe zeker ben je ervan dat je in staat bent om:
    </p>'
  },
  create_question(:v1, 'Tot de top 3 van de beste kandidaten te behoren die de VCO gaat halen'),
  create_question(:v2, 'Nog goed te functioneren nadat je een nacht niet hebt geslapen?'),
  create_question(:v3, 'Nog goed te functioneren nadat je twee nachten niet hebt geslapen?'),
  create_question(:v4, 'Pijn te lijden in de komende periode?'),
  create_question(:v5, 'Goed te presteren na twee dagen zonder eten?'),
  create_question(:v6, 'Het beste in jezelf naar boven te halen in de komende periode?'),
  create_question(:v7, 'Boven verwachting te presteren in de VCO op de momenten die er toe doen?'),
  create_question(:v8, 'Kalm te blijven in moeilijke situaties?'),
  create_question(:v9, 'Te vertrouwen op je vermogen om problemen op te lossen?'),
  create_question(:v10, 'Je doelen te behalen als je een blessure of andere fysieke ongemakken hebt?'),
  create_question(:v11, 'Te weten wat je moet doen als het de komende weken tegen zit?'),
  create_question(:v12, 'Meerdere oplossingen te bedenken als je in de VCO met een probleem wordt geconfronteerd?'),
  create_question(:v13, 'Vast te houden aan je plannen om je doel te bereiken?'),
  create_question(:v14, 'De VCO met succes af te ronden?')
]
questionnaire.content = { questions: content, scores: [] }
questionnaire.title = title
questionnaire.save!
