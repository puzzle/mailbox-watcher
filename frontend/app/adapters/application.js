import DS from "ember-data";

import $ from "jquery";

export default DS.JSONAPIAdapter.extend({
  namespace: "api"
});

$.ajaxPrefilter(function(options) {
  const authenticityToken = localStorage.getItem("authenticityToken");
  const url = options.url;
  options.url = url + "?token=" + authenticityToken;
});

// not very ember way of doing this, but quite simple :)
$(document).ajaxStart(() => {
  $('#spinner').removeClass('hide');
});

$(document).ajaxStop(() => {
  $('#spinner').addClass('hide');
});
