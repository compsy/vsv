# frozen_string_literal: true

title = 'Alfa'

name = 'KCT Alfa'
questionnaire = Questionnaire.find_by(name: name)
questionnaire ||= Questionnaire.new(name: name)
questionnaire.key = File.basename(__FILE__)[0...-3]

content = [
  {
    type: :raw,
    content: '
  <p class="flow-text"><em>Geïnformeerde toestemming</em></p>
  <p class="flow-text">
Ik stem toe mee te doen aan een onderzoek, dat uitgevoerd wordt door Lkol M. Baatenburg de Jong, MSc en ir. T.H. Huijzer, onder begeleiding van dr. R. J. R. den Hartigh, dr. F.J. Blaauw en Prof. dr. de Jonge.
De procedure is getoetst en goed bevonden door de ethische commissie van de Afdeling Psychologie, Rijksuniversiteit Groningen.
  </p>

  <ol class="flow-text">
<li>
Ik ben me ervan bewust dat deelname aan dit onderzoek geheel vrijwillig is.
Ik kan mijn medewerking op elk tijdstip stopzetten, zonder een reden te geven.
Daarnaast kan ik de gegevens die verkregen zijn uit dit onderzoek terugkrijgen, laten verwijderen uit de database of laten vernietigen.
</li>

<li>
De antwoorden op de vragen kunnen geen invloed hebben op mijn functie en worden niet gebruikt in een andere context dan dit onderzoek.
</li>

<li>
Er wordt mij gevraagd om vragenlijsten online in te vullen en om safe houses te herkennen in bepaalde steden.
</li>

<li>
Mijn gegevens zullen vertrouwelijk worden behandeld.
Mijn persoonsgegevens worden fysiek gescheiden van mijn antwoordgegevens.
</li>

<li>
Mijn geanonimiseerde antwoordgegevens kunnen worden gebruikt voor wetenschappelijk onderzoek.
</li>

<li>
De onderzoeker zal verdere vragen over het onderzoek nu of gedurende het onderzoek beantwoorden.
Vragen over het onderzoek kunnen ook achteraf gesteld worden, via
<a href="mailto:t.h.huijzer@rug.nl">t.h.huijzer@rug.nl</a>
.
</li>
  </ol>'
  },
  {
    id: :v1,
    type: :radio,
    title: '',
    options: [
      'Ik heb bovenstaande informatie gelezen en heb besloten om <b>wel</b> deel te nemen aan het onderzoek',
      'Ik heb bovenstaande informatie gelezen en heb besloten om <b>niet</b> deel te nemen aan het onderzoek'
    ],
    show_otherwise: false
  }
]

questionnaire.content = { questionnaire: content, scores: [] }
questionnaire.title = title
questionnaire.save!
