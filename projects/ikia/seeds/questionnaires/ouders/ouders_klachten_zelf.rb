# frozen_string_literal: true

db_title = 'Klachten (zelf)'
db_name1 = 'Klachten_Ouders_Zelfrapportage'
dagboek1 = Questionnaire.find_by_key(File.basename(__FILE__)[0...-3])
dagboek1 ||= Questionnaire.new(key: File.basename(__FILE__)[0...-3])
dagboek1.name = db_name1
dagboek_content = [
  {
    type: :raw,
    content: '<p class="flow-text">Welkom! Deze vragenlijst gaat over moeilijkheden die mensen kunnen ervaren in hun gevoelens, gedachten en gedrag. Verplaats het bolletje naar het antwoord dat het beste bij u past. Er zijn in totaal 49 vragen. Hier bent u ongeveer X minuten mee bezig. </p>'
  }, {
    section_start: 'Geef voor ieder van de onderstaande uitspraken aan in hoeverre de uitspraak <b> de afgelopen week </b> voor u van toepassing was.',
    id: :v1,
    type: :range,
    title: 'Ik merkte dat ik overstuur raakte van onbelangrijke zaken.',
    labels: ['Nooit', 'Soms', 'Meestal'],
    required: true,
    section_end: false
  }, {
    id: :v2,
    type: :range,
    title: 'Ik merkte dat mijn mond droog aanvoelde.',
    labels: ['Nooit', 'Soms', 'Meestal'],
    required: true
  }, {
    id: :v3,
    type: :range,
    title: 'Ik was niet in staat om ook maar enig positief gevoel te ervaren.',
    labels: ['Nooit', 'Soms', 'Meestal'],
    required: true
  }, {
    id: :v4,
    type: :range,
    title: 'Ik had moeite met ademhalen (bijv. overmatig snel ademen, buiten adem zijn zonder me in te spannen).',
    labels: ['Nooit', 'Soms', 'Meestal'],
    required: true
  }, {
    id: :v5,
    type: :range,
    title: 'Ik kon maar niet op gang komen.',
    labels: ['Nooit', 'Soms', 'Meestal'],
    required: true
  }, {
    id: :v6,
    type: :range,
    title: 'Ik had de neiging om overdreven te reageren op situaties.',
    labels: ['Nooit', 'Soms', 'Meestal'],
    required: true
  }, {
    id: :v7,
    type: :range,
    title: 'Ik voelde me beverig (bijv. onvast ter been zijn).',
    labels: ['Nooit', 'Soms', 'Meestal'],
    required: true
  }, {
    id: :v8,
    type: :range,
    title: 'Ik vond het moeilijk me te ontspannen.',
    labels: ['Nooit', 'Soms', 'Meestal'],
    required: true
  }, {
    id: :v9,
    type: :range,
    title: 'Er waren situaties die me zo angstig maakten dat ik erg opgelucht was wanneer het ophield.',
    labels: ['Nooit', 'Soms', 'Meestal'],
    required: true
  }, {
    id: :v10,
    type: :range,
    title: 'Ik had het gevoel dat ik niets had om naar uit te kijken..',
    labels: ['Nooit', 'Soms', 'Meestal'],
    required: true
  }, {
    id: :v11,
    type: :range,
    title: 'Ik merkte dat ik gemakkelijk overstuur raakte.',
    labels: ['Nooit', 'Soms', 'Meestal'],
    required: true
  }, {
    id: :v12,
    type: :range,
    title: 'Ik was erg opgefokt.',
    labels: ['Nooit', 'Soms', 'Meestal'],
    required: true
  }, {
    id: :v13,
    type: :range,
    title: 'Ik voelde me verdrietig en depressief.',
    labels: ['Nooit', 'Soms', 'Meestal'],
    required: true
  }, {
    id: :v14,
    type: :range,
    title: 'Ik merkte dat ik erg ongeduldig werd van oponthoud (bijv. wachten op een lift, stoplichten, file).',
    labels: ['Nooit', 'Soms', 'Meestal'],
    required: true
  }, {
    id: :v15,
    type: :range,
    title: 'Ik had het gevoel flauw te gaan vallen.',
    labels: ['Nooit', 'Soms', 'Vaak', 'Meestal']
  }, {
    id: :v16,
    type: :range,
    title: 'Ik had mijn interesse in zo\'n beetje alles verloren.',
    labels: ['Nooit', 'Soms', 'Meestal'],
    required: true
  }, {
    id: :v17,
    type: :range,
    title: 'Ik had het gevoel dat ik als persoon niet veel voorstel.',
    labels: ['Nooit', 'Soms', 'Meestal'],
    required: true
  }, {
    id: :v18,
    type: :range,
    title: 'Ik merkte dat ik nogal licht geraakt was.',
    labels: ['Nooit', 'Soms', 'Meestal'],
    required: true
  }, {
    id: :v19,
    type: :range,
    title: 'Ik transpireerde merkbaar (bijv. zweethanden) terwijl het niet warm was en ik me niet inspande.',
    labels: ['Nooit', 'Soms', 'Meestal'],
    required: true
  }, {
    id: :v20,
    type: :range,
    title: 'Ik was angstig zonder enige reden.',
    labels: ['Nooit', 'Soms', 'Meestal'],
    required: true
  }, {
    id: :v21,
    type: :range,
    title: 'Ik had het gevoel dat mijn leven niet de moeite waard is.',
    labels: ['Nooit', 'Soms', 'Meestal'],
    required: true
  }, {
    id: :v22,
    type: :range,
    title: 'Ik vond het moeilijk op verhaal te komen.',
    labels: ['Nooit', 'Soms', 'Meestal'],
    required: true
  }, {
    id: :v23,
    type: :range,
    title: 'Ik had moeite met slikken.',
    labels: ['Nooit', 'Soms', 'Meestal'],
    required: true
  }, {
    id: :v24,
    type: :range,
    title: 'Ik was niet in staat om enig plezier te hebben bij wat ik deed.',
    labels: ['Nooit', 'Soms', 'Meestal'],
    required: true
  }, {
    id: :v25,
    type: :range,
    title: 'Ik was me bewust van mijn hartslag terwijl ik me niet fysiek inspande (bijv. het gevoel van een versnelde hartslag of het overslaan van het hart).',
    labels: ['Nooit', 'Soms', 'Meestal'],
    required: true
  }, {
    id: :v26,
    type: :range,
    title: 'Ik voelde me somber en zwaarmoedig.',
    labels: ['Nooit', 'Soms', 'Meestal'],
    required: true
  }, {
    id: :v27,
    type: :range,
    title: 'Ik merkte dat ik erg snel prikkelbaar was.',
    labels: ['Nooit', 'Soms', 'Meestal'],
    required: true
  }, {
    id: :v28,
    type: :range,
    title: 'Ik had het gevoel dat ik bijna in paniek raakte.',
    labels: ['Nooit', 'Soms', 'Meestal'],
    required: true
  }, {
    id: :v29,
    type: :range,
    title: 'Ik vond het moeilijk tot rust te komen nadat iets me overstuur had gemaakt.',
    labels: ['Nooit', 'Soms', 'Meestal'],
    required: true
  }, {
    id: :v30,
    type: :range,
    title: 'Ik was bang dat ik van mijn stuk zou raken bij een eenvoudige nieuwe bezigheid of taak.',
    labels: ['Nooit', 'Soms', 'Meestal'],
    required: true
  }, {
    id: :v31,
    type: :range,
    title: 'Ik was niet in staat om over ook maar iets enthousiast te worden.',
    labels: ['Nooit', 'Soms', 'Meestal'],
    required: true
  }, {
    id: :v32,
    type: :range,
    title: 'Ik vond het moeilijk om te dulden dat ik gestoord werd bij wat ik aan het doen was.',
    labels: ['Nooit', 'Soms', 'Meestal'],
    required: true
  }, {
    id: :v33,
    type: :range,
    title: 'Ik was erg nerveus.',
    labels: ['Nooit', 'Soms', 'Meestal'],
    required: true
  }, {
    id: :v34,
    type: :range,
    title: 'Ik had het gevoel niets waard te zijn.',
    labels: ['Nooit', 'Soms', 'Meestal'],
    required: true
  }, {
    id: :v35,
    type: :range,
    title: 'Ik had volstrekt geen geduld met dingen die me hinderden bij iets dat ik wilde doen.',
    labels: ['Nooit', 'Soms', 'Meestal'],
    required: true
  }, {
    id: :v36,
    type: :range,
    title: 'Ik voelde me ontzettend angstig.',
    labels: ['Nooit', 'Soms', 'Meestal'],
    required: true
  }, {
    id: :v37,
    type: :range,
    title: 'Ik kon niets in de toekomst zien om me op te verheugen.',
    labels: ['Nooit', 'Soms', 'Meestal'],
    required: true
  }, {
    id: :v38,
    type: :range,
    title: 'Ik had het gevoel dat mijn leven geen zin had.',
    labels: ['Nooit', 'Soms', 'Meestal'],
    required: true
  }, {
    id: :v39,
    type: :range,
    title: 'Ik merkte dat ik erg onrustig was.',
    labels: ['Nooit', 'Soms', 'Meestal'],
    required: true
  }, {
    id: :v40,
    type: :range,
    title: 'Ik maakte me zorgen over situaties waarin ik in paniek zou raken en mezelf belachelijk zou maken.',
    labels: ['Nooit', 'Soms', 'Meestal'],
    required: true
  }, {
    id: :v41,
    type: :range,
    title: 'Ik merkte dat ik beefde (bijv. met de handen).',
    labels: ['Nooit', 'Soms', 'Meestal'],
    required: true
  }, {
    id: :v42,
    type: :range,
    title: 'Ik vond het moeilijk om het initiatief te nemen om iets te gaan doen.',
    labels: ['Nooit', 'Soms', 'Meestal'],
    required: true,
    section_end: true
  }, {
    section_start: 'Geef bij de onderstaande zinnen aan in hoeverre deze voor u waar zijn. Verplaats het bolletje naar het antwoord dat het beste bij u past.',
    id: :v43,
    type: :range,
    title: 'Mijn pijnlijke ervaringen en herinneringen maken het me moeilijk om een waardevol leven te leiden.',
    labels: ['Nooit waar', 'Soms waar', 'Altijd waar'],
    required: true,
    section_end: false
  }, {
    id: :v44,
    type: :range,
    title: 'Ik ben bang voor mijn gevoelens.',
    labels: ['Nooit waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v45,
    type: :range,
    title: 'Ik maak me zorgen dat ik niet in staat ben mijn zorgen en gevoelens onder controle te houden.',
    labels: ['Nooit waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v46,
    type: :range,
    title: 'Mijn pijnlijke herinneringen verhinderen mij een bevredigend leven te leiden.',
    labels: ['Nooit waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v47,
    type: :range,
    title: 'Emoties veroorzaken problemen in mijn leven.',
    labels: ['Nooit waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v48,
    type: :range,
    title: 'Het lijkt erop dat de meeste mensen meer controle over hun leven hebben dan ik.',
    labels: ['Nooit waar', 'Soms waar', 'Altijd waar'],
    required: true
  }, {
    id: :v49,
    type: :range,
    title: 'Zorgen staan mijn succes in de weg.',
    labels: ['Nooit waar', 'Soms waar', 'Altijd waar'],
    required: true,
    section_end: true
  }
]
dagboek1.content = { questions: dagboek_content, scores: [] }
dagboek1.title = db_title
dagboek1.save!