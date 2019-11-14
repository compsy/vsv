# frozen_string_literal: true
db_title = 'Leefplezier'
db_name1 = 'Welbevinden_Jongeren_2_Huizen'
dagboek1 = Questionnaire.find_by_name(db_name1)
dagboek1 ||= Questionnaire.new(name: db_name1)
dagboek1.key = File.basename(__FILE__)[0...-3]
dagboek_content = [
  {
    type: :raw,
    content: '<p class= "flow-text">Welkom! Deze vragenlijst gaat over je leefplezier. Het invullen van de vragen kost ongeveer X minuten. Daarna kun je je resultaten bekijken en krijg je uitleg over wat alles betekent.</p>'
  }, {
    section_start: 'Type je antwoord op de volgende vraag in het tekstveld. Je mag zoveel typen als je wilt.',
    id: :v1,
    type: :textarea,
    title: 'Wat is gelukkig zijn?',
    required: true,
    section_end: true
  }, {
    section_start: 'De volgende vragen gaan over je leven in het algemeen. Verplaats het bolletje naar het antwoord dat het beste bij jou past.',
    id: :v2,
    type: :range,
    title: 'Ik heb een goed leven.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Helemaal waar'],
    required: true,
    section_end: false
  }, {
    id: :v3,
    type: :range,
    title: 'Ik wou liever een ander leven als dat kon.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Helemaal waar'],
    required: true
  }, {
    id: :v4,
    type: :range,
    title: 'Ik heb wat ik wil in het leven.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Helemaal waar'],
    required: true
  }, {
    id: :v5,
    type: :range,
    title: 'Ik ben positief over de toekomst.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Helemaal waar'],
    required: true
  }, {
    id: :v6,
    type: :range,
    title: 'Ik geniet van elke dag.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Helemaal waar'],
    required: true
  }, {
    id: :v7,
    type: :range,
    title: 'Er zijn mensen met wie ik over problemen kan praten.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Helemaal waar'],
    required: true
  }, {
    id: :v8,
    type: :range,
    title: 'Ik denk dat mensen om mij geven.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Helemaal waar'],
    required: true,
    section_end: true
  }, {
    section_start: 'De volgende vragen gaan over het huis waar je het grootste gedeelte van de tijd woont:',
    id: :v9_a_1,
    type: :range,
    title: 'Ik geniet ervan om thuis te zijn.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Helemaal waar'],
    required: true,
    section_end: false
  }, {
    id: :v9_a_2,
    type: :range,
    title: 'We kunnen in dit huis goed met elkaar opschieten.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Helemaal waar'],
    required: true
  }, {
    id: :v9_a_3,
    type: :range,
    title: 'We doen thuis leuke dingen samen.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Helemaal waar'],
    required: true
  }, {
    id: :v9_a_4,
    type: :range,
    title: 'Ik kan kiezen wat ik in mijn vrije tijd doe.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Helemaal waar'],
    required: true
  }, {
    id: :v9_a_5,
    type: :range,
    title: 'Ik word thuis eerlijk behandeld.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Helemaal waar'],
    required: true
  }, {
    id: :v9_a_6,
    type: :range,
    title: 'Ik vind de wijk waar ik woon leuk.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Helemaal waar'],
  }, {
    id: :v9_a_7,
    type: :range,
    title: 'Ik vind mijn buren leuk.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Helemaal waar'],
    required: true
  }, {
    id: :v9_a_8,
    type: :range,
    title: 'Ik voel me veilig in de wijk waar ik woon.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Helemaal waar'],
    required: true
  }, {
    id: :v9_a_9,
    type: :range,
    title: 'Er zijn leuke dingen te doen waar ik woon.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Helemaal waar'],
    required: true,
    section_end: true
  }, {
    section_start: 'De volgende vragen gaan over het tweede huis waar je woont:',
    id: :v9_b_1,
    title: 'Ik geniet ervan om thuis te zijn.',
    type: :range,
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Helemaal waar'],
    required: true,
    section_end: false
  }, {
    id: :v9_b_2,
    type: :range,
    title: 'We kunnen in dit huis goed met elkaar opschieten.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Helemaal waar'],
    required: true
  }, {
    id: :v9_b_3,
    type: :range,
    title: 'We doen thuis leuke dingen samen.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Helemaal waar'],
    required: true
  }, {
    id: :v9_b_4,
    type: :range,
    title: 'Ik kan kiezen wat ik in mijn vrije tijd doe.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Helemaal waar'],
    required: true
  }, {
    id: :v9_b_5,
    type: :range,
    title: 'Ik word thuis eerlijk behandeld.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Helemaal waar'],
    required: true
  }, {
    id: :v9_b_6,
    type: :range,
    title: 'Ik vind de wijk waar ik woon leuk.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Helemaal waar'],
    required: true
  }, {
    id: :v9_b_7,
    type: :range,
    title: 'Ik vind mijn buren leuk.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Helemaal waar'],
    required: true
  }, {
    id: :v9_b_8,
    type: :range,
    title: 'Ik voel me veilig in de wijk waar ik woon.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Helemaal waar'],
    required: true
  }, {
    id: :v9_b_9,
    type: :range,
    title: 'Er zijn leuke dingen te doen waar ik woon.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Helemaal waar'],
    required: true,
    section_end: true
  }, {
    section_start: 'De volgende vragen gaan over je vrienden en vriendinnen:',
    id: :v10,
    type: :range,
    title: 'Mijn vrienden zijn aardig tegen mij.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Helemaal waar'],
    required: true,
    section_end: false
  }, {
    id: :v11,
    type: :range,
    title: 'Ik kan met mijn vrienden over alles praten.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Helemaal waar'],
    required: true
  }, {
    id: :v12,
    type: :range,
    title: 'Ik heb plezier met mijn vrienden.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Helemaal waar'],
    required: true
  }, {
    id: :v13,
    type: :range,
    title: 'Ik heb genoeg vrienden.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Helemaal waar'],
    required: true
  }, {
    id: :v14,
    type: :range,
    title: 'Mijn vrienden helpen mij als ik dat nodig heb.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Helemaal waar'],
    required: true
  }, {
    id: :v15,
    type: :range,
    title: 'Ik kan mezelf zijn als ik bij mijn vrienden ben.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Helemaal waar'],
    required: true,
    section_end: true
  }, {
    section_start: 'De volgende vragen gaan over school:',
    id: :v16,
    type: :range,
    title: 'Ik heb vaak zin om naar school te gaan.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Helemaal waar'],
    required: true,
    section_end: false
  }, {
    id: :v17,
    type: :range,
    title: 'Ik vind het leuk op school.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Helemaal waar'],
    required: true
  }, {
    id: :v18,
    type: :range,
    title: 'Ik heb een leuke klas.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Helemaal waar'],
    required: true
  }, {
    id: :v19,
    type: :range,
    title: 'Ik maak me zorgen over wat klasgenoten van mij vinden.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Helemaal waar'],
    required: true
  }, {
    id: :v20,
    type: :range,
    title: 'Ik vind wat we op school doen interessant.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Helemaal waar'],
    required: true
  }, {
    id: :v21,
    type: :range,
    title: 'Ik wil graag nieuwe dingen leren.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Helemaal waar'],
    required: true,
    section_end: true
  }, {
    section_start: 'De volgende vragen gaan over jezelf:',
    id: :v22,
    type: :range,
    title: 'Ik voel me goed over mezelf.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Helemaal waar'],
    required: true,
    section_end: false
  }, {
    id: :v23,
    type: :range,
    title: 'Ik ben tevreden met hoe ik eruit zie.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Helemaal waar'],
    required: true
  }, {
    id: :v24,
    type: :range,
    title: 'Er zijn dingen die ik goed kan.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Helemaal waar'],
    required: true
  }, {
    id: :v25,
    type: :range,
    title: 'Ik kan gemakkelijk keuzes maken.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Helemaal waar'],
    required: true
  }, {
    id: :v26,
    type: :range,
    title: 'Ik kan goed met problemen omgaan.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Helemaal waar'],
    required: true
  }, {
    id: :v27,
    type: :range,
    title: 'Ik vind het leuk om nieuwe dingen te proberen.',
    labels: ['Helemaal niet waar', 'Een beetje waar', 'Helemaal waar'],
    required: true,
    section_end: true
  }
]
dagboek1.content = dagboek_content
dagboek1.title = db_title
dagboek1.save!