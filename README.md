<h1 align="center">
  u-can-act
</h1>

<p align="center">
  Ruby Application for the Vroegtijdig School Verlaten Dagboekonderzoek.
  Ook in gebruik als <i>back end</i> voor <a href="https://iederkindisanders.nl">Ieder Kind is Anders</a> en <a href="https://yourspecialforces.nl">Your Special Forces</a>.
</p>

<p align="center">
  <a href="https://zenodo.org/badge/latestdoi/84442919"><img src="https://zenodo.org/badge/84442919.svg"></a>
  <a href="https://circleci.com/gh/compsy/u-can-act"><img src="https://circleci.com/gh/compsy/u-can-act.svg?style=svg&circle-token=482ba30c54a4a181d02f22c3342112d11d6e0e8a"></a>
  <a href="https://coveralls.io/github/compsy/u-can-act?branch=master"><img src="https://coveralls.io/repos/github/compsy/u-can-act/badge.svg?branch=master"></a>
  <a href="https://dependabot.com"><img src="https://api.dependabot.com/badges/status?host=github&repo=compsy/u-can-act"></a>
</p>

## Reference
Emerencia, A.C., Blaauw, F.J., Snell, N.R., Blijlevens, T., Kunnen, E.S., De Jonge, P. & Van der Gaag, M.A.E. (2017). 
U-can-act Web-app (Version 1.0) [Web application software]. 
Retrieved from [www.u-can-act.nl](www.u-can-act.nl)

Frank J. Blaauw, Mandy A. E. van der Gaag, Nick R. Snell, Ando C. Emerencia, E. Saskia Kunnen and Peter de Jonge (2018).
The u-can-act Platform: A Tool to Study Intra-individual Processes of Early School Leaving and Its Prevention Using Multiple Informants. [Frontiers in Psychology](https://www.frontiersin.org/articles/10.3389/fpsyg.2019.01808/full)

## Funding
This application has been made possible by funding from The Netherlands Initiative for Education Research (NRO) under projectnumber 405-16-401.

![NRO](https://u-can-act.nl/wp-content/uploads/2018/01/NRO-2.png)

## Installation
Make sure that Docker Compose is installed, it will allow you to run the application with Postgress, Redis and MongoDB.

Clone the codebase and step into the directory.
```bash
  git clone git@github.com:compsy/vsv.git
  cd vsv
```
Then fill in the `.env` or `.env.local` files (see [Configuration](#configuration)) and run the back end with
```
  docker-compose up
```

## Configuration
The `.env` file is used for storing all ENV variables. 
Below is a list of all required ENV variables for production servers.

### General settings
```
  PROJECT_NAME:      <name of the project (e.g., vsv)>
  POSTGRES_DATABASE: <prefix for the database used in development (e.g., vsv)>
  MONGO_DATABASE:    <prefix for the database used in development (e.g., vsv)>

  SECRET_KEY_BASE: <base used for the tokens>
  HOST_URL: <the url where the application is hosted (e.g. http://myapp.io)>
  HOST_DOMAIN: <just the domain part of HOST_URL (e.g. myapp.io)>
  INFO_EMAIL: <email address to use as sender for user account emails>
  FEEDBACK_EMAIL: <email address used by the feedback button>

  MESSAGEBIRD_ACCESS_KEY: <access key for messagebird>
  MESSAGEBIRD_SEND_FROM: <sender name shown for SMS>

  PERSON_SALT: <salt used to hash person ids in the exporter>
  STOP_SUBSCRIPTION_SALT: <salt used for hashing the stop_subscription keys>

  ADMIN_USERNAME: <user name for the admin panel>
  ADMIN_PASSWORD: <password for the admin panel>

  MAILGUN_API_KEY: <the API key retrieved from mailgun, starts with key->
  MAILGUN_DOMAIN: <the domain configured with mailgun to send mail from, e.g., sandbox43bf51fb258844f0bc393e806ebd25bb.mailgun.org or mg.u-can-act.nl>
  FROM_EMAIL_ADDRESS: <the email address to send the email from, e.g., info@u-can-act.nl>

  AUTH0_CLIENT_ID: <the client id of the client used at auth0>
  AUTH0_DOMAIN: <the auth0 domain, e.g., ucanact.eu.auth0.com>
  AUTH0_CLIENT_SECRET: <the client secret from auth0
  AUTH0_REDIRECT_URL: <the url to do the callback to. Should be something like: http://vsv.io/admin/callback>
  AUTH0_AUDIENCE: <The auth0 audience>
  AUTH0_SIGNING_CERTIFICATE: <the BASE64 encoded certificate>

  REDIS_HOST: <the url of the redis host>
  REDIS_PORT: <the port of the redis host>
  REDIS_PASSWORD: <the password of the redis host>

  TEST_PHONE_NUMBERS: <the list of phonenumbers that are actually test phone numbers. The list needs to be comma separated, eg 0612341234,0676565641>
  SNITCH_KEY: <the key which the snitcher should call>

  API_KEY: <the secret username that can be used to access the api>
  API_SECRET: <the secret password that can be used to access the api>

  IP_HASH_SALT: <for certain users we store the hashed ip address. The hash is generated with this salt>

  INFO_SITE_URL: <site for more information about the u-can-act project, typically https://u-can-act.nl>

  PUSH_SUBSCRIPTION_URL: <for pushing results back to the base platform, e.g., 'http://web:3000/api/v1/data/create_raw'> 
  BASE_PLATFORM_URL: <the external url of the base platform for redirecting the user, e.g., 'http://localhost:3000'>

  SHARED_SECRET: <shared secret for generating hmac for generating invite params for invite token link>
  REGISTRATION_URL: <url for sending invites to for person email registration>

  WORKLESS_ENABLED: <set to 'true' if you want to enable workless>
```

### (Local) development settings
For developers, many of the above settings have default values specified in the `.env` file which is included in the repository and should work for development. 
However, a `.env.local` file is **not** included in the repository, and should be created by the developer. 
Since this file determines which project will run, it should at minimum have the following settings:

`.env.local` minimum settings:

```
  PROJECT_NAME:      myproject

  HOST_URL:          http://myproject.io
  HOST_DOMAIN:       myproject.io
  INFO_EMAIL:        info@myproject.io

  SITE_LOCATION:     http://myproject.io
```

After cloning the repo, be sure to create an `.env.local` file with at least the variables above.

When using the rake task to generate a new project (`bundle exec rake "deployment:create_project[myproject]"`), a `.env.local` file is automatically generated for you. But when switching to one of the existing projects in the repo, you need to set the above variables in `.env.local`.

### Organization-specific settings
Organization specific settings can be found in the `projects/<project-name>` folder. `config/settings.yml`. 
One of the variables that should be defined is the `PROJECT_NAME` environment variable, which will translate to `application_name` in `config/settings.yml`. 
This variable is used in determining the directory for organization specific configuration files such as locales (e.g., files in the directory `projects/my_organization/*` are used if `application_name` is `my_organization`).

The file structure of the `my_organization` directory in the `projects` directory should be as follows:

```
|
|- config/
   |- settings.yml
   |- locales/
|- seeds/
|- asssets/
```

In the project specific `settings.yml`, the following settings are required:
```yaml
default_team_name:  <Name of the default team>
project_start_date: <Date that the project started in the format yyyy-mm-dd, e.g., '2017-10-01'>
project_end_date:   <Date that the project ended in the format yyyy-mm-dd, e.g., '2018-08-06'>
logo:
  mentor_logo: <Filename of the mentor logo, e.g., 'mentor_logo.png'>
  student_logo: <Filename of the student logo, e.g., 'student_logo.png'>
  fallback_logo: <Default logo when there is no student or mentor, e.g., 'logo.png'>
  company_logo: <OPTIONAL. Filename of a company logo. If missing, the header uses only one logo>
```
The settings in `settings.yml` should be sectioned under `development`, `production`, `test`, and `staging`. See the relevant files in this repository for examples.

### Feature toggles

The `settings.yml` file has a `feature_toggles` section with the following entries:

- `allow_identifier_export` (defaults to `false`): By default, the Person export available from the admin dashboard only exports the properties `gender` and `first_name` (along with role, title, team name and organization name) for a Person. Enabling this feature allows for exporting an additional Identifiers file with email and mobile phone numbers, tied to a person id.
- `allow_distribution_export` (defaults to `false`): Enabling this feature allows for exporting the distributions (i.e., how often people gave a certain answer, for all possible answers, for all questionnaires) for any valid JWT token (belonging to a person) through the JWT API. This is used e.g., for the IKIA project to display distributions in graphs alongside the scores of the user.
- `realtime_distributions` (defaults to `true`): Whether or not the distributions (see above) should be kept up-to-date in real time (i.e., updated after every filled out response). This should typically be set to true, because it introduces very little overhead. There is also a nightly job that calculates distributions (doing the same thing, but then with a day delay), so if rather have that distributions update once per day, you can set this to `false`.
- `google_analytics` (defaults to `true`): Whether or not Google Analytics should be enabled for the site. Currently, analytics for all deploys of this repo are reported under the `UA-100060757-1` Compsy property. This should really be separate per deploy, but right now it isn't.
- `allow_response_uuid_login` (defaults to `false`): Setting this feature toggle to true allows users to use a questionnaire uuid link to log in. This may or may not help with filling out questionnaires under Edge/Outlook where for some reason redirects are followed but cookies are not being set correctly. Since there are many UUIDs, the risk of a person randomly guessing one is low. This risk is further lowered because only UUIDs for responses that have been opened and are not yet completed are valid. And even when someone does guess a UUID, there is no information leaked: they can fill out a questionnaire but that's it.

### Development configuration
In order to run the Capybara specs of the VSV project, you need to install the chrome headless browser. In MacOS you can do this using Homebrew:
```
  brew install chromedriver
```

## Background jobs
The workings of the app rely on the following background jobs:

Daily (e.g., at 2:30am), the following rake task should run:
```
rake scheduler:complete_protocol_subscriptions
```

Daily (e.g., at 3am), the following rake task should run:
```
rake scheduler:cleanup_invitation_tokens
```

Every 10 minutes, the following rake task should run:
```
rake scheduler:send_invitations
```

Every hour, the following rake task should run:
```
rake scheduler:cache_overview
```

Daily (e.g., at 3pm), the following rake task should run:
```
rake scheduler:monitoring
```

Daily (e.g., at 3:30am), the following rake task should run:
```
rake scheduler:rescheduling
```

Daily (e.g., at 4am), the following rake task should run:
```
rake scheduler:generate_questionnaire_headers
```

When using Heroku these can be scheduled via the *Heroku Scheduler*.


In addition, a `delayed_job` worker should be available at all times. These can be started with `bin/delayed_job start`.
To do this on Heroku, start an extra worker process and, optionally, add the [workless](https://github.com/lostboy/workless) gem to enable autoscaling.

## Protocols and Measurements
In the system a _Questionnaire_ denotes the definition of a questionnaire.
A _Protocol_ is the overarching type which contains questionnaires.
To obtain data from people filling in the questionnaires, each questionnaire should contain _Measurements_. 
The measurements define when the user should (be nudged to) fill in the questionnaire. 
The filled in questionnaires are stored as _Responses_.

There are two types of measurements. 
Periodical and one-time measurements. 
Periodical measurements are measurements that have a `period` that is not nil. 
Periodical measurements are repeated each `period` from `protocol_subscription.start_date + measurement.open_from_offset` until `protocol_subscription.end_date - measurement.offset_until_end`. The `protocol_subscription.end_date` can be specified when creating a protocol subscription, or if it is not specified, it is initialized with a default value of `protocol_subscription.start_date + protocol.duration`.
**See the measurement model for the most up to date documentation**.

For non-periodical measurements, the `offset_until_end` is ignored.

The protocol specification contains multiple variables for some protocol `p` and questionnaire `q`.

Variable | Description
--- | ---
`p.duration` | Duration of protocol. After _protocol start date_ + _protocol duration_ the protocol will be closed.
`q.open_duration` | Time before a measurement is closed. If the user does not fill in the questionnaire before this time, an empty response remains in the database.
`q.period` | Time between measurements.
`q.open_from_offset` | What offset to apply before opening the protocol. 
`q.open_from_day` | By default `open_from_offset` offsets from the moment when the users logs in for the first time. This option can override that start moment. See the measurement model for more information.
`q.stop_measurement` | If `true` this will end the protocol after user completes `q`. This overrides `p.duration`. This can be useful in diary studies where users receive reminders when new measurements are available.

## Importing new students and mentors
New mentors and students can be imported using the `echo_people` use case. 

```ruby
  be rake "maintenance:echo_people[CSV_NAME]"
```

in which `CSV_NAME` should be replaced with the file name of the CSV containing the mentor / student data. 
It is important that the format of the CSV is ordered as follows. 

### The Mentor CSV
For the Mentor data this should be:

| type | team_name | role_title | first_name | last_name | gender | mobile_phone | email | protocol_name | start_date | filling_out_for | filling_out_for_protocol | end_date |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |

In this case: 
 - `type` should equal `Mentor`
 - `team_name`: the name of the team the mentor belongs to
 - `role_title`: the role the mentor has in the team ('mentor', 'maatje', or 'S-teamer')
 - `first_name`: the first name of the person
 - `last_name`: the last name of the person
 - `gender`: the gender of the person
 - `mobile_phone`: the mobile phone number of the person
 - `email`: the email address of the mentor
 - `protocol_name`: the name of the protocol the person will participate in (for mentors this is `mentoren voormeting/nameting`
 - `start_date`: the date at which the person should start
 - `filling_out_for`: the phone number for which the mentor is filling out the questionnaire
 - `filling_out_for_protocol`: the protocol the person is filling out for (this is `mentoren dagboek` for mentors)
 - `end_date`: the end date of the protocol subscription

### The Student CSV
For the Student data this should be:

| Type | team_name | role_title | first_name | last_name | gender | mobile_phone | e-mail | protocol_name | start_date | end_date |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |

In this case: 
 - `type` should equal `Student`
 - `team_name`: the name of the team the student belongs to
 - `first_name`: the first name of the person
 - `last_name`: the last name of the person
 - `gender`: the gender of the person
 - `mobile_phone`: the mobile phone number of the person
 - `protocol_name`: the name of the protocol the person will participate in (for students this is `studenten`)
 - `start_date`: the date at which the person should start
 - `end_date`: the end date of the protocol subscription

## Variables that can be used in texts (case-sensitive!):

```
        VARIABLE                    DEFAULT VALUE               EXAMPLE
        ========================================================================
        begeleider                  begeleider                  s-team captain
        Begeleider                  Begeleider                  S-team captain
        zijn_haar_begeleider        zijn/haar                   haar
        Zijn_haar_begeleider        Zijn/haar                   Haar
        hij_zij_begeleider          hij/zij                     zij
        Hij_zij_begeleider          Hij/zij                     Zij
        hem_haar_begeleider         hem/haar                    haar
        Hem_haar_begeleider         Hem/haar                    Haar
        naam_begeleider             je begeleider               Elsa
        Naam_begeleider             Je begeleider               Elsa
        achternaam_begeleider                                   Groen
        Achternaam_begeleider                                   Groen

        je_begeleidingsinitiatief   je begeleidingsinitiatief   De Hondsrug
        Je_begeleidingsinitiatief   Je begeleidingsinitiatief   De Hondsrug

        deze_student                deze student                Rik
        Deze_student                Deze student                Rik
        achternaam_student                                      De Vries
        Achternaam_student                                      De Vries
        zijn_haar_student           zijn/haar                   zijn
        Zijn_haar_student           Zijn/haar                   Zijn
        hij_zij_student             hij/zij                     hij
        Hij_zij_student             Hij/zij                     Hij
        hem_haar_student            hem/haar                    hem
        Hem_haar_student            Hem/haar                    Hem

        datum                       <vandaag>                   01-11-2018
        datum_lang                  <vandaag>                    1 november 2018
```
So you can write a sentence as follows:

```
Heeft je {{begeleider}} al {{zijn_haar_begeleider}} vragenlijsten ingevuld voor {{deze_student}} en
{{zijn_haar_student}} vrienden? Of heeft {{hij_zij_begeleider}} daar nog geen tijd voor gehad.
{{Hij_zij_student}} al wel.
```
and expect output like so:
```
Heeft je S-team captain al haar vragenlijsten ingevuld voor Rik en zijn vrienden?
Of heeft zij daar nog geen tijd voor gehad. Hij al wel.
```

Please never use `de {{begeleider}}` or `het {{begeleider}}`, but always `je {{begeleider}}` or `jouw {{begeleider}}`.

## Questionnaire Syntax
The `content` attribute of a `Questionnaire` is a Hash with two keys, `:questions` and `:scores`. `content[:questions]` is a serialized array that stores the questionnaire definition. The following types of questions are supported: `:checkbox`, `:radio`, `:range`, `:raw`, `:textarea`, `:textfield`, `:expandable`, `:time`, `:date`, `:dropdown`, `:unsubscribe`, `:drawing`, `:date_and_time`, `:days`.

For all questions, it is allowed to use HTML tags in the texts. 
Also, you may use any of the special variables defined in the previous section.

All questions except checkboxes now support a `combines_with` attribute. The value of this attribute should be an array of (other) questionnaire IDs. This is used to indicate to the distributions engine that an additional conditional distribution histogram, combining the values of the question and the ones that it combines with, should also be calculated.

### Type: Checkbox
Required and allowed options (minimal example and maximal example):

```ruby
[{
  id: :v1,
  type: :checkbox,
  title: 'Waar hadden de belangrijkste gebeurtenissen mee te maken?',
  options: ['hobby/sport', 'werk', 'vriendschap', 'romantische relatie', 'thuis']
}, {
  section_start: 'De hoofddoelen',
  hidden: true,
  id: :v2,
  type: :checkbox,
  required: true,
  title: 'Aan welke doelen heb je deze week gewerkt tijdens de begeleiding van deze student?',
  tooltip: 'some tooltip',
  options: [
   { title: 'De relatie verbeteren en/of onderhouden', shows_questions: %i[v2 v3], value: 'relatie' },
   { title: 'Inzicht krijgen in de belevingswereld', tooltip: 'de belevingswereld van de student', hides_questions: %i[v4 v5] },
   'Inzicht krijgen in de omgeving',
   { title: 'Zelfinzicht geven', shows_questions: %i[v8 v9], stop_subscription: true },
   { title: 'Vaardigheden ontwikkelen', shows_questions: %i[v10 v11] },
   { title: 'De omgeving veranderen/afstemmen met de omgeving', shows_questions: %i[v12] }
  ],
  show_otherwise: true,
  otherwise_label: 'Nee, omdat:',
  otherwise_tooltip: 'some tooltip',
  otherwise_placeholder: 'Vul iets in',
  show_after: Time.new(2018, 5, 6).in_time_zone,
  section_end: true
}]
```

The options array can contain either hashes or strings. 
If it is just a string, it is used as the `title` element. 
The `show_otherwise` field is optional, and determines whether or not the question should have an 'otherwise' field. 
The `tooltip` field is also optional. 
When present, it will introduce a small i on which the user can click to get extra information (the information in the tooltip variable).

Setting `required: true` for a checkbox question has the effect that the user has to check at least one of the options, or the form cannot be submitted.

In the options array, the `stop_subscription: true` property indicates that the protocol subscription should be canceled when this option is selected.

Options for Radios, Likerts, Dropdowns, and Checkboxes can have a `value` attribute. When specified, this value is used
instead of the title for encoding the option in the CSV export. It is of use e.g., when the selected option(s) are long
sentences, and you just want something shorter in your CSV export.

Note that this (and all other question types) may have a `show_after` property. This may have the following values:

```ruby
# To indicate that a question should appear 4 weeks after the start
# of the protocol subscription, use:
{ show_after: 4.weeks }

# or alternatively, you may specify an absoute date:
{ show_after: Time.new(2018, 6, 5, 9, 0, 0).in_time_zone }

# or you can specify that a question is only visible on the last questionnaire:
{ show_after: :only_on_final_questionnaire }
```

Note that the `shows_questions` and `hides_questions` option properties require the corresponding questions to have the `hidden: true` and `hidden: false` properties, respectively. For example:

```ruby
[{
  id: :v1,
  type: :checkbox,
  title: 'Vraag?',
  options: [{title: 'antwoord', hides_questions: %i[v2], shows_questions: %i[v3]}]
},{
  id: :v2,
  hidden: false,
  type: '...'
},{
  id: :v3,
  hidden: true,
  type: '...'
}]
```

### Type: Radio
Required and allowed options (minimal example and maximal example):

```ruby
[{
  id: :v1,
  type: :radio,
  title: 'Waar hadden de belangrijkste gebeurtenissen mee te maken?',
  options: ['hobby/sport', 'werk', 'vriendschap', 'romantische relatie', 'thuis']
}, {
  section_start: 'De hoofddoelen',
  hidden: true,
  id: :v2,
  type: :radio,
  title: 'Aan welke doelen heb je deze week gewerkt tijdens de begeleiding van deze student?',
  tooltip: 'some tooltip',
  options: [
   { title: 'De relatie verbeteren en/of onderhouden', shows_questions: %i[v2 v3], numeric_value: 20, value: 'relatie' },
   { title: 'Inzicht krijgen in de belevingswereld', hides_questions: %i[v4 v5], numeric_value: 40 },
   'Inzicht krijgen in de omgeving',
   { title: 'Zelfinzicht geven', shows_questions: %i[v8 v9], stop_subscription: true, numeric_value: 60 },
   { title: 'Vaardigheden ontwikkelen', tooltip: 'Zoals wiskunde', shows_questions: %i[v10 v11], numeric_value: 80 },
   { title: 'De omgeving veranderen/afstemmen met de omgeving', shows_questions: %i[v12], numeric_value: 100 }
  ],
  show_otherwise: true,
  otherwise_label: 'Nee, omdat:',
  otherwise_placeholder: 'Vul iets in',
  otherwise_tooltip: 'some tooltip',
  section_end: true
}]
```

The options array can contain either hashes or strings. 
If it is just a string, it is used as the `title` element.
The `show_otherwise` field is optional, and determines whether or not the question should have an 'otherwise' field. 
The `tooltip` field is also optional.
When present, it will introduce a small i on which the user can click to get extra information (the information in the tooltip variable).

Note that the `shows_questions`, `hides_questions`, and `stop_subscription` option properties here work identically to those described above in the Type: Checkbox section.

Radios are always required.

Radios, Likerts, and Dropdowns can have a `numeric_value` property attribute for entries in their `option` array.
This value can be a float or integer, but the convention is integer, and that the options span a range from 0 to 100.
In particular, one would want the `numeric_value`s of different questions in the same questionnaire to be in the same scale, so that their average can be calculated in scores.
The `numeric_value` is the numerical representation of each option, used when combining multiple of this of questions to calculate an average score.
If the options array spans a consecutive interval whose high values should affect the average negatively (and vice versa),  simply assign numeric_value the options from 100 down to 0 instead of the other way around.
This attribute is optional, and there is no default value. If the chosen answer option does not have a `numeric_value`, it will be treated as missing for purposes of score calculation.
Note that this attribute is only a requirement for score calculation, not for distribution calculations. For distribution calculations, we only keep frequency counts per option per question, and we don't combine anything so it doesn't matter that the options themselves aren't numbers.

Options for Radios, Likerts, Dropdowns, and Checkboxes can have a `value` attribute. When specified, this value is used instead of the title for encoding the option in the CSV export. It is of use e.g., when the selected option(s) are long sentences, and you just want something shorter in your CSV export.

### Type: Likert
Required and allowed options (minimal example and maximal example):

```ruby
[{
  id: :v1,
  type: :likert,
  title: 'Wat vind u van deze stelling?',
  options: ['helemaal oneens', 'oneens', 'neutraal', 'eens', 'helemaal eens']
}, {
  section_start: 'De hoofddoelen',
  hidden: true,
  id: :v2,
  type: :likert,
  title: 'Wat vind u van deze stelling?',
  tooltip: 'some tooltip',
  options: [
    { title: 'helemaal oneens', numeric_value: 1, value: 'ho' },
    { title: 'oneens', numeric_value: 2 },
    { title: 'neutraal', numeric_value: 3 },
    { title: 'eens', numeric_value: 4 },
    { title: 'helemaal eens', numeric_value: 5 }
  ],
  section_end: true
}]
```

The options array can currently only contain strings. 
The strings in the array are used as answer options. 
Likert questions are always required.

Radios, Likerts, and Dropdowns can have a `numeric_value` property attribute for entries in their `option` array.
This value can be a float or integer, but the convention is integer, and that the options span a range from 0 to 100.
In particular, one would want the `numeric_value`s of different questions in the same questionnaire to be in the same scale, so that their average can be calculated in scores.
The `numeric_value` is the numerical representation of each option, used when combining multiple of this of questions to calculate an average score.
If the options array spans a consecutive interval whose high values should affect the average negatively (and vice versa),  simply assign numeric_value the options from 100 down to 0 instead of the other way around.
This attribute is optional, and there is no default value. If the chosen answer option does not have a `numeric_value`, it will be treated as missing for purposes of score calculation.
Note that this attribute is only a requirement for score calculation, not for distribution calculations. For distribution calculations, we only keep frequency counts per option per question, and we don't combine anything so it doesn't matter that the options themselves aren't numbers.

Options for Radios, Likerts, Dropdowns, and Checkboxes can have a `value` attribute. When specified, this value is used
instead of the title for encoding the option in the CSV export. It is of use e.g., when the selected option(s) are long
sentences, and you just want something shorter in your CSV export.


### Type: Range
Required and allowed options (minimal example and maximal example):

```ruby
[{
  id: :v1,
  type: :range,
  title: 'Was het voor jou duidelijk over wie je een vragenlijst invulde?',
  labels: ['helemaal niet duidelijk', 'heel duidelijk'],
}, {
  section_start: 'De hoofddoelen',
  hidden: true,
  id: :v2,
  type: :range,
  min: 0,
  max: 100,
  step: 1,
  value: 50,
  required: true,
  ticks: true,
  vertical: true,
  gradient: true,
  no_initial_thumb: true,
  title: 'Was het voor jou duidelijk over wie je een vragenlijst invulde?',
  tooltip: 'some tooltip',
  labels: ['helemaal niet duidelijk', 'heel duidelijk'],
  section_end: true
}]
```
The range type supports the optional properties `min` and `max`, which are set to 0 and 100 by default, respectively. 
It also supports `step`, which sets the step size of the slider (set to 1 by default, can also be a fraction).
The `value` denotes the default location for the slider, that is, the location of the slider when it is not yet changed by the user.
If the `ticks` attribute is `true`, the slider will show ticks and values at each `step` (the default value for `ticks` is `false`).
If the `no_initial_thumb` attribute is `true`, then the slider does not show an initial scrollthumb for unmodified range inputs. Only when the user changes the slider to set a value will the scrollthumb appear. (the default value for `no_initial_thumb` is `false`)
If the `vertical` attribute is `true`, then the slider is a vertical slider, with labels on the right. This option defaults to `false`. Note that when this option is `true`, the array of `labels` must correspond to the same number of steps as provided by the `min`, `max`, and `step` arguments.
If the `gradient` attribute is `true`, then the background of the slider is set to a gradient. Currently this only works for vertical sliders.
If `required: true` is set for a question with type `range`, it means that the slider has to be clicked before the response can be submitted. 

### Type: Raw
**Raw questionnaire types should not have an id!**
Required and allowed options (minimal example and maximal example):

```ruby
[{
  type: :raw,
  content: '<p class="flow-text">Zie het voorbeeld hieronder:</p><img src="/images/begeleiders/omgeving.png" class="questionnaire-image" /><p class="flow-text">Geef voor de volgende antwoordopties aan of ze moeilijk of makkelijk te begrijpen waren.</p>'
}, {
  section_start: 'De hoofddoelen',
  type: :raw,
  content: '<p class="flow-text">Zie het voorbeeld hieronder:</p><img src="/images/begeleiders/omgeving.png" class="questionnaire-image" /><p class="flow-text">Geef voor de volgende antwoordopties aan of ze moeilijk of makkelijk te begrijpen waren.</p>',
  section_end: true
}]
```

### Type: Textarea
Required and allowed options (minimal example and maximal example):

```ruby
[{
  id: :v1,
  type: :textarea,
  title: 'Wat zou jij willen verbeteren aan de webapp die je de afgelopen drie weken hebt gebruikt?',
}, {
  section_start: 'Tot slot',
  hidden: true,
  id: :v2,
  type: :textarea,
  title: 'Wat zou jij willen verbeteren aan de webapp die je de afgelopen drie weken hebt gebruikt?',
  tooltip: 'some tooltip',
  placeholder: 'Place holder',
  section_end: true
}]
```

The `tooltip' field is optional. 
When present, it will introduce a small i on which the user can click to get extra information (the information in the tooltip variable).

### Type: Textfield
Required and allowed options (minimal example and maximal example):

```ruby
[{
  id: :v1,
  type: :textfield,
  title: 'Wat zou jij willen verbeteren aan de webapp die je de afgelopen drie weken hebt gebruikt?',
}, {
  section_start: 'Tot slot',
  hidden: true,
  id: :v2,
  type: :textfield,
  title: 'Wat zou jij willen verbeteren aan de webapp die je de afgelopen drie weken hebt gebruikt?',
  tooltip: 'some tooltip',
  default_value: 'Niks',
  pattern: '[a-z]{1,10}',
  hint: 'Must be a lowercase word between 1 and 10 characters in length',
  placeholder: 'Place holder',
  section_end: true
}]
```

The `tooltip' field is optional. 
When present, it will introduce a small i on which the user can click to get extra information (the information in the tooltip variable).

The property `pattern` is a regex that limits what the user can enter. 
The `hint` property is the error message shown to the user when the input does not satisfy the pattern.

Textfields also support a `default_value` property, which is a default value used to fill out the text field. 
This can contain a variable, e.g., `default_value: '{{deze_student}}'`.

### Type: Number
Type for integer(?) numbers. 
Required and allowed options (minimal example and maximal example):

```ruby
[{
  id: :v1,
  type: :number,
  title: 'Wat is je postcode?'
}, {
  section_start: 'Tot slot',
  hidden: true,
  id: :v2,
  type: :number,
  title: 'Wat is je postcode?',
  tooltip: 'some tooltip',
  maxlength: 4,
  placeholder: '1234',
  links_to_expandable: :v3,
  min: 0,
  max: 9999,
  required: true,
  section_end: true
}]
```

Properties specific to `number` are `min` and `max`, for numerical limits, and `maxlength`, which can be used to restrict long numerical inputs (should probably be used in conjunction with pattern if the exact format of the number is known).

The `required` property is also supported. 
The default is that numbers are not required.

The `number` type does not support `pattern` or `hint` because these properties are not supported by the html 5 `number` input type.

A new unique property for the `number` type is the `links_to_expandable` property. Set this to the id of an expandable section to let the answer to this question set the number of expansions for the expandable question.
If the user manually adds or removes expandable iterations with the + or - buttons, those changes are not reflected back to this number (i.e., it is used as a "default number of expansions").

Also, the `placeholder` property is supported for numbers.

### Type: Expandable
Expandable questionnaire questions are essentially mini questionnaires within each questionnaire. 
They can introduce `max_expansions` new sub-questionnaires within the question (if not specified, this is 10). Furthermore, one can specify a number of `default_expansions`, which is the number of times the sub-questionnaire should be injected in the main questionnaire (if not specified this is 0).

```ruby
[{
  id: :v17,
  title: 'Doelen voor deze student',
  remove_button_label: 'Verwijder doel',
  add_button_label: 'Voeg doel toe',
  type: :expandable,
  default_expansions: 1,
  max_expansions: 10,
  content: [{
    id: :v17_1,
    type: :textarea,
    title: 'Beschrijf in een aantal steekwoorden wat voor doel je gedaan hebt.'
  }, {
    id: :v17_2,
    type: :checkbox,
    title: 'Wat voor acties hoorden hierbij?',
    options: ['Laagdrempelig contact gelegd',
              'Praktische oefeningen uitgevoerd',
              'Gespreks- interventies/technieken gebruikt',
              'Het netwerk betrokken',
              'Motiverende handelingen uitgevoerd',
              'Observaties gedaan']
  }, {
    id: :v17_3,
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
  },{
    id: :v17_4,
    type: :range,
    title: 'Slider 1 (lorem!)',
    labels: ['zelf geen invloed', 'zelf veel invloed']
  },{
    id: :v17_5,
    type: :range,
    title: 'Slider 2 (lorem!)',
    labels: ['zelf geen invloed', 'zelf veel invloed']
  }]
}]
```
If the `content` of an expandable question contains questions with options that have the `shows_questions` or `hides_questions` attribute, the IDs will be dynamically adjusted so that it works for both static and dynamic IDs. 
(E.g., if you say `shows_questions: %i[v3_5]`, it will toggle the questions `v3_5` and `v3_<id>_5`, where `<id>` is the index of the current iteration in the expansion). 
Note that questions can only toggle ids in the same iteration, or normal static questions (outside of the expandable area).

### Type: Time
Required and allowed options (minimal example):

```ruby
[{
  id: :v1,
  type: :time,
  hours_from: 0,
  hours_to: 6,
  hours_step: 1,
  title: 'Hoeveel tijd heb je deze week besteed aan de begeleiding van deze student?'
}]
```
The dropdown will start from `hours_from` and will offer options until `hours_to`, with a stepsize of `hour_step`.

Optional properties are `hours_label` and `minutes_label`, to override the default label texts.

### Type: Date
Required and allowed options (minimal example and maximal example):

```ruby
[{
  id: :v1,
  type: :date,
  title: 'Wanneer ben je gestopt?',
}, {
  section_start: 'Tot slot',
  hidden: true,
  id: :v2,
  type: :date,
  today: true,
  title: 'Wanneer ben je gestopt?',
  required: true,
  tooltip: 'some tooltip',
  placeholder: 'Place holder',
  min: '2018/06/14',
  max: '2018/07/20',
  default_date: '2018/07/20',
  section_end: true
}]
```

The `min` and `max` properties can be either strings as in the above example, or they can be of the following form: `min: -15, max: true` meaning that the max is today, and the minimum date is 15 days ago (max can also be set to false, which removes any limits).

If the `today` property is present, then the default value for the date is set to today. (e.g., `today: true`)

The `default_date` property can be used to set a default date. The `default_date` and `today` properties should never both be used.

### Type: Date and Time

Required and allowed options (minimal example and maximal example):

```ruby
[{
  id: :v1,
  hours_id: :v2_uur,
  minutes_id: :v2_minuten,
  type: :date_and_time,
  title: 'Wanneer ben je gestopt?',
}, {
  section_start: 'Tot slot',
  hidden: true,
  id: :v1,
  hours_id: :v2_uur,
  minutes_id: :v2_minuten,
  type: :date_and_time,
  today: true,
  title: 'Wanneer ben je gestopt?',
  required: true,
  tooltip: 'some tooltip',
  placeholder: 'Place holder',
  min: '2018/06/14',
  max: '2018/07/20',
  section_end: true
}]
```

The `min` and `max` properties can be either strings as in the above example, or they can be of the following
form: `min: -15, max: true` meaning that the max is today, and the minimum date is 15 days ago (max can also be set to `false`, which removes any limits).

If the `today` property is present, then the default value for the date is set to today. (e.g., `today: true`)

The `default_date` property can be used to set a default date. The `default_date` and `today` properties should never
both be used.

### Type: Unsubscribe
Including an unsubscribe question type will display a card that allows the user to unsubscribe from the protocol. 
Typically, you want only one `unsubscribe` question in your questionnaire, as the first item in the questionnaire. 
You may want to control its visibility by specifying a `show_after` property.

Including an unsubscribe type "question" in a questionnaire will show a card with a button. 
Clicking this button will redirect the user to the unsubscribe route for the protocol subscription to which the current questionnaire belongs. 
If the protocol has a stop measurement, the user is first redirected to fill out this questionnaire, after which they will be unsubscribed from the protocol.

Required and allowed options (minimal example):

```ruby
[{
  type: :unsubscribe,
  title: 'Klaar met dit schooljaar?',
  content: 'Ben je klaar met dit schooljaar? Klik dan op de knop \'Onderzoek afronden\' om het onderzoek te voltooien.',
  button_text: 'Onderzoek afronden',
  show_after: Time.new(2018, 6, 15).in_time_zone
}]
```

Unsubscribe questions do not need an `id`.

Usable properties for an unsubscribe `question` type are `title`, `content`, `button_text`, and `data_method` (all are optional).

The default `data_method` is `delete`. 
The `data_method` should typically not be specified as it should correspond with the `unsubscribe_url` that is supplied by the system when calling the questionnaire generator. 
Only when we call this private function with `send` to show a card on the mentor dashboard is when we override both the `unsubscribe_url` and the `data_method` but it's a bit of a hack.

### Type: Dropdown
Required and allowed options (minimal example and maximal example):

```ruby
[{
  id: :v1,
  type: :dropdown,
  title: 'Waar hadden de belangrijkste gebeurtenissen mee te maken?',
  options: ['hobby/sport', 'werk', 'vriendschap', 'romantische relatie', 'thuis']
}, {
  section_start: 'De hoofddoelen',
  hidden: true,
  id: :v2,
  type: :dropdown,
  title: 'Aan welke doelen heb je deze week gewerkt tijdens de begeleiding van deze student?',
  label: 'RMC regio',
  placeholder: 'Selecteer uw antwoord...',
  tooltip: 'some tooltip',
  options: [
    { title: 'hobby/sport', numeric_value: 0 },
    { title: 'werk', numeric_value: 25 },
    { title: 'vriendschap', numeric_value: 50 },
    { title: 'romantische relatie', numeric_value: 75 },
    { title: 'thuis', numeric_value: 100 }
  ],
  section_end: true
}]
```

The options array must contain of strings. 
Currently, there is no support for `shows_questions` or `hides_questions` triggers based on selected options in a dropdown.

The dropdown does not support a `show_otherwise` option.

Dropdowns are always required.

A dropdown can have a `placeholder` property which is the text used when no option is selected. 
If no `placeholder` is specified, a default text is used.

A dropdown can have a `label` property which is a small text that is always visible and is printed directly above the dropdown.

The `tooltip' field is optional. 
When present, it will introduce a small i on which the user can click to get extra information (the information in the tooltip variable).

Note that the `shows_questions`, `hides_questions`, and `stop_subscription` option properties here work identically to those described above in the Type: Checkbox section.

Radios, Likerts, and Dropdowns can have a `numeric_value` property attribute for entries in their `option` array.
This value can be a float or integer, but the convention is integer, and that the options span a range from 0 to 100.
In particular, one would want the `numeric_value`s of different questions in the same questionnaire to be in the same scale, so that their average can be calculated in scores.
The `numeric_value` is the numerical representation of each option, used when combining multiple of this of questions to calculate an average score.
If the options array spans a consecutive interval whose high values should affect the average negatively (and vice versa),  simply assign numeric_value the options from 100 down to 0 instead of the other way around.
This attribute is optional, and there is no default value. If the chosen answer option does not have a `numeric_value`, it will be treated as missing for purposes of score calculation.
Note that this attribute is only a requirement for score calculation, not for distribution calculations. For distribution calculations, we only keep frequency counts per option per question, and we don't combine anything so it doesn't matter that the options themselves aren't numbers.

Options for Radios, Likerts, Dropdowns, and Checkboxes can have a `value` attribute. When specified, this value is used
instead of the title for encoding the option in the CSV export. It is of use e.g., when the selected option(s) are long
sentences, and you just want something shorter in your CSV export.

### Type: Drawing
Let's a user draw on an image. 
Required and allowed options (minimal example and maximal example):

```ruby
[{
  id: :v1,
  type: :drawing,
  title: 'Kleur de plekken in je lichaam waar je merkt dat het sterker wordt',
  width: 240,
  height: 536,
  image: 'bodymap.png',
  color: '#e57373',
}, {
  section_start: 'De hoofddoelen',
  hidden: true,
  tooltip: 'some tooltip',
  id: :v2,
  type: :drawing,
  title: 'Kleur de plekken in je lichaam waar je merkt dat het sterker wordt',
  width: 240,
  height: 536,
  image: '/a_directory_under_public/somedir/bodymap.png',
  color: '#64b5f6',
  radius: 15,
  density: 40,
  section_end: true
}]
```

Height and width should be specified as integers, without any postfix such as `px`.

Image can be the URL of an image, or the filename of an image that exists in the asset pipeline.

The only optional parameters are `radius` and `density`. They default to 15 and 40, respectively.


### Type: Days

This question type is used to let the user select days or day parts until today, from `from_days_ago` until today.

Required and allowed options (minimal example and maximal example):

```ruby
[{
  id: :v1,
  type: :days,
  title: 'Wanneer ben je gestopt?',
  from_days_ago: 14,
}, {
  section_start: 'Tot slot',
  hidden: true,
  id: :v1,
  type: :days,
  title: 'Wanneer ben je gestopt?',
  shows_questions: [:v56],
  hides_questions: [:v57],
  date_format: '%A %e %B',
  from_days_ago: 14,
  exclude_weekends: false,
  include_today: false,
  morning_and_afternoon: false,
  required: false,
  tooltip: 'some tooltip',
  section_end: true
}]
```

The setting `exclude_weekends` (defaults to `false`), `include_today` (defaults to `false`), and `morning_and_afternoon` (defaults to `false`). The latter setting means that two checkboxes will be generated per day, one labeled as morning and one labeled as afternoon.

The settings `shows_questions` and `hides_questions` can be optionally specified, in which case those are triggered when the user selects at least one of the day(part)s.

If `required` (defaults to `false`) is `true` then the user is required to select at least one day(part).

The setting `date_format` can be overridden to specify a different date format. The formatted date is appended by "morning" and "afternoon" if `morning_and_afternoon` is set to `true`.


## Questionnaire Scores

Questionnaire scores are automatically calculated and stored with the questionnaire results. The realtime distribution calculations also calculate distributions for questionnaire scores.

Questionnaire content has the following format:
```ruby
{ questions: [], scores: [] }
```
Both these entries are required, but they may be empty.

Scores is an array of scores with the following properties.

Minimal example:
```ruby
[{ id: :s1,
   label: 'The average of v1 and v2',
   ids: %i[v1 v2],
   operation: :average
}]
```
Each score should have a unique `id` property. That means that these ids should be different from any other score id or question id in this questionnaire.
`ids` is the list of IDs that the `operation` should be performed over. It may include ids of scores that occurred earlier in the `scores` array.

Maximal example:
```ruby
[{ id: :s1,
   label: 'The average of v1 and v2',
   ids: %i[v1 v2],
   preprocessing: { v2: { multiply_with: -1, offset: 100 } },
   operation: :average,
   require_all: true,
   round_to_decimals: 0
}]
```
If `round_to_decimals` is missing, the result is not rounded, and the realtime distribution calculation will **not** calculate a distribution for this score. Analogously, if you specify the `round_to_decimals` attribute, the realtime distribution calculation will automatically calculate the distribution for this score. If you're only dealing with integers, you can use `round_to_decimals: 0`.
If `require_all` is missing, it works the same as when specifying `require_all: false`.
All other attributes are required. If `require_all` is `true`, it means that the score is only calculated for responses where all of the IDs in the list of ids are present. The default for `require_all` is false, meaning that if a user didn't fill out certain questions in the ids list for a score, we still try to calculate the average over the ones that are present.
The `preprocessing` key is optional, and if provided, should be a hash with a (sub)set of the IDs in `ids` as keys. Each entry in a hash represents how this value will be preprocessed. Currently, only the following operations are supported: `multiply _with`, which multiplies the value with a given number (which can be integer or float, positive or negative), and `offset`, which adds a constant number to the value (this number can also be an integer or float, positive or negative). Both `multiply_with` and `offset` are optional. If both are provided, `multiply_with` is performed first. It is possible to chain operations by defining a new score that takes as input a previously preprocessed score (see below).

- The only currently supported `operation` is `:average`.
- The set of ids may also include ids of scores that occurred earlier in the scores array, e.g.:

```ruby
{
  questions: [ '...' ],
  scores: [{
           id: :s1,
           label: 'Positive excited',
           ids: %i[v1 v2 v3 v4],
           operation: :average,
           require_all: false,
         }, {
           id: :s2,
           label: 'Positive not excited',
           ids: %i[v5 v6 v7 v8],
           operation: :average,
           require_all: false,
         }, {
           id: :s3,
           label: 'Positive',
           ids: %i[s1 s2],
           operation: :average,
           require_all: true,
           round_to_decimals: 1
         }]
}
```



