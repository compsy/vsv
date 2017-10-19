# frozen_string_literal: true

FactoryGirl.define do
  sequence(:questionnaire_name) { |n| "vragenlijst-dagboekstudie-studenten-#{n}" }
  factory :questionnaire do
    name { generate(:questionnaire_name) }
    title 'vragenlijst-dagboekstudie-studenten'
    content [{
      section_start: 'Algemeen',
      id: :v1,
      type: :radio,
      title: 'Hoe voelt u zich vandaag?',
      options: %w[slecht goed]
    }, {
      id: :v2,
      type: :checkbox,
      title: 'Wat heeft u vandaag gegeten?',
      options: ['brood', 'kaas en ham', 'pizza']
    }, {
      id: :v3,
      type: :range,
      title: 'Hoe gaat het met u?',
      labels: ['niet mee eens', 'beetje mee eens', 'helemaal mee eens'],
      section_end: true
    }, {
      id: :v4,
      title: 'Doelen voor deze student',
      labels: ['Voeg doel toe', 'Verwijder doel'],
      type: :expandable,
      default_expansions: 0,
      max_expansions: 10,
      content: [{
        id: :v4_1,
        type: :textarea,
        title: 'Beschrijf in een aantal steekwoorden wat voor doel je gedaan hebt.'
      }, {
        id: :v4_2,
        type: :checkbox,
        title: 'Wat voor acties hoorden hierbij?',
        options: ['Laagdrempelig contact gelegd',
                  'Praktische oefeningen uitgevoerd',
                  'Gespreks- interventies/technieken gebruikt',
                  'Het netwerk betrokken',
                  'Motiverende handelingen uitgevoerd',
                  'Observaties gedaan']
      }, {
        id: :v4_3,
        type: :checkbox,
        title: 'Welke hoofddoelen hoorden er bij deze acties?',
        options: [
          'De relatie verbeteren en/of onderhouden',
          'Inzicht krijgen in de belevingswereld',
          'Inzicht krijgen in de omgeving',
          'Zelfinzicht geven',
          'Vaardigheden ontwikkelen',
          'De omgeving vreanderen/afstemmen met de omgeving'
        ]
      }, {
        id: :v4_4,
        type: :range,
        title: 'Slider 1 (lorem!)',
        labels: ['zelf geen invloed', 'zelf veel invloed']
      }, {
        id: :v4_5,
        type: :range,
        title: 'Slider 2 (lorem!)',
        labels: ['zelf geen invloed', 'zelf veel invloed']
      }]
    }]

    trait :one_expansion do
      content [{
        section_start: 'Algemeen',
        id: :v1,
        type: :radio,
        title: 'Hoe voelt u zich vandaag?',
        options: %w[slecht goed]
      }, {
        id: :v2,
        type: :checkbox,
        title: 'Wat heeft u vandaag gegeten?',
        options: ['brood', 'kaas en ham', 'pizza']
      }, {
        id: :v3,
        type: :range,
        title: 'Hoe gaat het met u?',
        labels: ['niet mee eens', 'beetje mee eens', 'helemaal mee eens'],
        section_end: true
      }, {
        id: :v4,
        title: 'Doelen voor deze student',
        labels: ['Voeg doel toe', 'Verwijder doel'],
        type: :expandable,
        default_expansions: 1,
        max_expansions: 10,
        content: [{
          id: :v4_1,
          type: :textarea,
          title: 'Beschrijf in een aantal steekwoorden wat voor doel je gedaan hebt.'
        }, {
          id: :v4_2,
          type: :checkbox,
          title: 'Wat voor acties hoorden hierbij?',
          options: ['Laagdrempelig contact gelegd',
                    'Praktische oefeningen uitgevoerd',
                    'Gespreks- interventies/technieken gebruikt',
                    'Het netwerk betrokken',
                    'Motiverende handelingen uitgevoerd',
                    'Observaties gedaan']
        }, {
          id: :v4_3,
          type: :checkbox,
          title: 'Welke hoofddoelen hoorden er bij deze acties?',
          options: [
            'De relatie verbeteren en/of onderhouden',
            'Inzicht krijgen in de belevingswereld',
            'Inzicht krijgen in de omgeving',
            'Zelfinzicht geven',
            'Vaardigheden ontwikkelen',
            'De omgeving vreanderen/afstemmen met de omgeving'
          ]
        }, {
          id: :v4_4,
          type: :range,
          title: 'Slider 1 (lorem!)',
          labels: ['zelf geen invloed', 'zelf veel invloed']
        }, {
          id: :v4_5,
          type: :range,
          title: 'Slider 2 (lorem!)',
          labels: ['zelf geen invloed', 'zelf veel invloed']
        }]
      }]
    end
  end
end
