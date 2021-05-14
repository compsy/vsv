/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb

// console.log('Hello World from Webpacker')

import 'core-js/stable'
import 'regenerator-runtime/runtime'

import 'babel-polyfill'

import '../stylesheets/application.scss'

// Make jquery available
import $ from 'jquery'
global.$ = global.jQuery = $
import {} from 'jquery-ujs'

// Make the M function and other materialize javascript functions available
require('materialize-css')

// I18n stuff
import I18n from '../../../public/javascripts/i18n'
I18n.defaultLocale = 'nl' // TODO: should be: I18n.defaultLocale = "<%= I18n.default_locale %>";
I18n.locale = 'nl' // TODO: should be: I18n.locale = "<%= I18n.locale %>";
require('../../../public/javascripts/translations')

// Support component names relative to this directory:
const componentRequireContext = require.context('components', true)
const ReactRailsUJS = require('react_ujs')
ReactRailsUJS.useContext(componentRequireContext)
