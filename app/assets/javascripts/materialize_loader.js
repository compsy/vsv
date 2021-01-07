$(function() {
  // Initialize collapsible (uncomment the lines below if you use the dropdown variation)
  // var collapsibleElem = document.querySelector('.collapsible');
  // var collapsibleInstance = M.Collapsible.init(collapsibleElem, options);

  // Or with jQuery

  // Enable ranges - the thumb element does not show when this is deleted
  var array_of_dom_elements = document.querySelectorAll("input[type=range]");
  M.Range.init(array_of_dom_elements);

  // Enable the sidenav
  $('.sidenav').sidenav();

  // Enable materialize selects (can test in the organization overview)
  $('select').formSelect();

  // Floats the button on the admin dashboard - small screen
  $('.fixed-action-btn').floatingActionButton();

  // Enable collapsible fields (used in the export)
  $('.collapsible').collapsible();

  // Enable materialize textfields
  M.updateTextFields();

  // Fix textareas causing a horizontal scrollbar
  $(window).resize(function() {
    var hiddenDiv = $('.hiddendiv').first();
    if (hiddenDiv.length) {
      hiddenDiv.css('width', window.innerWidth / 2 + 'px');
    }
  });

  // Enable timepickers
  $('.timepicker').timepicker({
    twelveHour: false
  });

  // Enable datepickers
  $('.datepicker').each(function() {
    var self = this;
    var default_date = null;
    if ($(self).data('default-date'))
      default_date = new Date(Date.parse($(self).data('default-date')));
    $(self).datepicker({
      firstDay: 1,
      minDate: new Date(Date.parse($(self).data('min'))),
      maxDate: new Date(Date.parse($(self).data('max'))),
      defaultDate: default_date,                         // This is so we can set a default date already filled out,
      setDefaultDate: $(self).data('set-default-date'),  // allowing the user to skip the input
      format: 'yyyy-mm-dd',
      i18n: {
        months: ['januari', 'februari', 'maart', 'april', 'mei', 'juni', 'juli', 'augustus', 'september', 'oktober', 'november', 'december'],
        monthsShort: ['januari', 'februari', 'maart', 'april', 'mei', 'juni', 'juli', 'augustus', 'september', 'oktober', 'november', 'december'],
        weekdays: ['zondag', 'maandag', 'dinsdag', 'woensdag', 'donderdag', 'vrijdag', 'zaterdag'],
        weekdaysShort: ['zondag', 'maandag', 'dinsdag', 'woensdag', 'donderdag', 'vrijdag', 'zaterdag'],
        weekdaysAbbrev: ['z', 'm', 'd', 'w', 'd', 'v', 'z'],
        clear: 'Wissen',
        cancel: 'Annuleren',
        close: 'Ok'
      }
    });
  });
});
