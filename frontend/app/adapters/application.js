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
