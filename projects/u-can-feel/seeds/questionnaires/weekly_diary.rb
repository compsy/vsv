# frozen_string_literal: true

db_title = 'De afgelopen week'
db_name1 = 'weekly_diary'
dagboek1 = Questionnaire.find_by(key: File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1
dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text">De volgende vragen gaan over wat je de afgelopen week allemaal hebt meegemaakt. Er zijn geen "goede" of "foute" antwoorden, het gaat erom hoe je je echt voelt.
    </p>'
  }, {
    id: :v1,
    type: :range,
    title: 'Hoe ging het afgelopen week met je?',
    labels: ['Heel slecht', 'Heel goed']
  }, {
    type: :raw,
    content: '<p class="flow-text">Ongeveer hoe vaak voelde je je in de afgelopen week ...
    </p>'
  }, {
    id: :v2,
    type: :range,
    title: 'Zenuwachtig?',
    labels: ['Nooit', 'Hele tijd']
  }, {
    id: :v3,
    type: :range,
    title: 'Hopeloos?',
    labels: ['Nooit', 'Hele tijd']
  }, {
    id: :v4,
    type: :range,
    title: 'Rusteloos of ongedurig?',
    labels: ['Nooit', 'Hele tijd']
  }, {
    id: :v5,
    type: :range,
    title: 'Zo somber dat niets je kon opvrolijken?',
    labels: ['Nooit', 'Hele tijd']
  }, {
    id: :v6,
    type: :range,
    title: 'Dat alles veel moeite kostte?',
    labels: ['Nooit', 'Hele tijd']
  }, {
    id: :v7,
    type: :range,
    title: 'Waardeloos?',
    labels: ['Nooit', 'Hele tijd']
  }, {
    type: :raw,
    content: '<p class="flow-text"><br><br>
    </p>'
  }, {
    id: :v8,
    type: :range,
    title: 'Hoe goed heb je in de afgelopen week geslapen?',
    labels: ['Heel slecht', 'Heel goed']
  }, {
    id: :v9,
    type: :radio,
    show_otherwise: false,
    title: 'Ben je afgelopen week naar school geweest?',
    options: [
      { title: 'Ja', shows_questions: %i[v10_a v11 v12 v13] },
      { title: 'Nee, helemaal niet', shows_questions: %i[v9_b] }
    ]
  }, {
    id: :v9_b,
    type: :checkbox,
    show_otherwise: false,
    required: true,
    hidden: true,
    title: 'Waarom ben je niet naar school geweest?',
    options: [
      { title: 'Het was vakantie' },
      { title: 'Ik was ziek' },
      { title: 'Ik vond het te moeilijk om naar school te gaan' },
      { title: 'Ik had een andere reden' }
    ]
  }, {
    id: :v10_a,
    type: :days,
    hidden: true,
    title: 'Je gaf aan dat je de afgelopen week naar school bent geweest. Heb je in de afgelopen week wel lessen gemist? Vink de dagdelen aan waarop je <strong>niet</strong> naar school bent geweest.',
    tooltip: 'Het maakt niet uit wat de reden was. Als je alleen een paar minuten te laat was, hoef je het niet mee te tellen.',
    shows_questions: %i[v10_b],
    required: false,
    from_days_ago: 7,
    exclude_weekends: true,
    include_today: false,
    morning_and_afternoon: true,
  }, {
    id: :v10_b,
    type: :checkbox,
    show_otherwise: false,
    hidden: true,
    required: true,
    title: 'Waarom heb je lessen gemist?',
    options: [
    { title: 'Ik had een afspraak (bijvoorbeeld met de huisarts of een specialist)' },
    { title: 'Ik was ziek (bijvoorbeeld grieperig) of lag in het ziekenhuis' },
    { title: 'Ik vond het moeilijk om naar school te gaan of daar te blijven (bijvoorbeeld omdat je bang was)' },
    { title: 'Ik was aan het spijbelen' },
    { title: 'Ik had vrij gekregen van mijn ouders (bijvoorbeeld om rust te krijgen)' },
    { title: 'Ik mocht om andere redenen thuisblijven van mijn ouders (bijvoorbeeld om thuis te helpen)' },
    { title: 'Mijn ouders hadden vakantie geregeld onder schooltijd' },
    { title: 'Ons gezin had iets dringends (bijvoorbeeld een begrafenis of iemand moest naar het ziekenhuis)' },
    { title: 'Ons gezin had andere problemen (bijvoorbeeld een kapotte auto of fiets, of iemand in het gezin moest naar een afspraak)' },
    { title: 'Ons gezin had een religieuze feestdag' },
    { title: 'De school was gesloten (bijvoorbeeld vanwege een staking of een studiedag voor leraren)' },
    { title: 'Ik was naar huis gestuurd vanwege mijn gedrag (bijvoorbeeld een schorsing)' },
    { title: 'De school had mijn ouders gevraagd om mij thuis te houden' },
    { title: 'Er was zwaar weer (bijvoorbeeld een storm)' },
    { title: 'Ik had een andere reden' }
  ]
  }, {
    id: :v11,
    type: :range,
    hidden: true,
    title: 'Hoe ging het afgelopen week in het algemeen op school?',
    labels: ['Heel slecht', 'Heel goed']
  }, {
    id: :v12,
    type: :range,
    hidden: true,
    title: 'Hoeveel moeite had je afgelopen week met je schoolwerk of met toetsen?',
    labels: ['Geen moeite', 'Heel veel moeite']
  }, {
    id: :v13,
    type: :radio,
    show_otherwise: false,
    hidden: true,
    title: 'Had je afgelopen week toetsen?',
    options: ['Nee', "Ja, tijdens een gewone schoolweek", "Ja, tijdens een toetsweek"]
  }, {
    id: :v14,
    type: :range,
    title: 'Heb je afgelopen week druk gevoeld om goed te presteren vanuit je leraren of je ouders?',
    labels: ['Helemaal niet', 'Heel veel']
  }, {
    id: :v15,
    type: :range,
    title: 'Heb je afgelopen week druk gevoeld om goed te presteren vanuit jezelf?',
    labels: ['Helemaal niet', 'Heel veel']
  }, {
    id: :v16,
    type: :range,
    title: 'Hoe zeker ben je dat je dit jaar over zal gaan?',
    labels: ['Helemaal niet zeker', 'Heel zeker']
  }, {
    type: :raw,
    content: '<p class="flow-text">De volgende vragen gaan over de mensen om je heen.
    </p>'
  }, {
    id: :v17,
    type: :radio,
    show_otherwise: false,
    title: ' Had je afgelopen week verkering met iemand?',
    options: [
      { title: 'Ja', shows_questions: %i[v22] },
      { title: 'Nee' }
    ]
  }, {
    type: :raw,
    content: '<p class="flow-text">Hoe goed kon je de afgelopen week opschieten met ...
    </p>'
  }, {
    id: :v18,
    type: :range,
    title: 'Je leraren?',
    labels: ['Heel slecht', 'Heel goed']
  }, {
    id: :v19,
    type: :range,
    title: 'Je klasgenoten?',
    labels: ['Heel slecht', 'Heel goed']
  }, {
    id: :v20,
    type: :range,
    title: 'Je vrienden?',
    labels: ['Heel slecht', 'Heel goed']
  }, {
    id: :v21,
    type: :range,
    title: 'Je ouders?',
    labels: ['Heel slecht', 'Heel goed']
  }, {
    id: :v22,
    type: :range,
    hidden: true,
    title: 'Degene met wie je verkering hebt?',
    labels: ['Heel slecht', 'Heel goed']
  }, {
    type: :raw,
    content: '<p class="flow-text"><br><br>
    </p>'
  }, {
    id: :v23,
    type: :checkbox,
    show_otherwise: false,
    required: true,
    title: 'Is er de afgelopen week iets bijzonders gebeurd op school? Je kunt meerdere opties aankruisen.',
    options: [
      { title: 'Nee, niets' },
      { title: 'Ja, iets leuks' },
      { title: 'Ja, iets neutraals' },
      { title: 'Ja, iets vervelends' }
    ]
  }, {
    id: :v24,
    type: :checkbox,
    show_otherwise: false,
    required: true,
    title: 'Is er de afgelopen week iets bijzonders gebeurd buiten school, bijvoorbeeld thuis? Je kunt meerdere opties aankruisen.',
    options: [
      { title: 'Nee, niets' },
      { title: 'Ja, iets leuks' },
      { title: 'Ja, iets neutraals' },
      { title: 'Ja, iets vervelends' }
    ]
  }
]

dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!
