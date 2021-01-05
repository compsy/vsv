# frozen_string_literal: true

title = 'Delta VCO'
name = 'KCT Delta VCO'
questionnaire = Questionnaire.find_by(name: name)
questionnaire ||= Questionnaire.new(name: name)
questionnaire.key = File.basename(__FILE__)[0...-3]

def create_question(id, title)
  res = {
    id: id,
    type: :likert,
    title: title,
    show_otherwise: false,
    options: %w[1 2 3 4 5 6 7]
  }
  res
end

content = [
  {
    type: :raw,
    content: '
<ul class="flow-text section-explanation">
Voor de volgende vragen kan gekozen worden uit de volgende mogelijkheden:<br/>
<li>
1 = sterk mee oneens
</li>

<li>
2 = mee oneens
</li>

<li>
3 = gedeeltelijk mee oneens
</li>

<li>
4 = niet oneens, niet eens
</li>

<li>
5 = gedeeltelijk mee eens
</li>

<li>
6 = mee eens
</li>

<li>
7 = sterk mee eens
</li>
<br/>
<br/>
Je doel is het succesvol afronden van de VCO.
De volgende vragen gaan over dit doel.
</ul>
'
  },
  create_question(:v2, 'Het is moeilijk voor mij om het behalen van de dit doel serieus te nemen.'),
  create_question(:v3, 'Eerlijk gezegd, kan het me niet schelen of ik dit doel wel of niet haal.'),
  create_question(:v4, 'Voor mij is het heel belangrijk om het behalen van dit doel na te streven.'),
  create_question(:v5, 'Er hoeft niet veel te gebeuren om het behalen van dit doel te laten vallen.'),
  create_question(:v6, 'Ik vind het behalen van dit doel een goed doel om voor te gaan.'),
  {
    id: :v7,
    type: :likert,
    title: 'Hoe haalbaar vind je dit doel?',
    options: ['Praktisch onhaalbaar', 'Onhaalbaar', 'Nauwelijks haalbaar', 'Haalbaar', 'Gemakkelijk haalbaar']
  }
]
questionnaire.content = { questions: content, scores: [] }
questionnaire.title = title
questionnaire.save!
