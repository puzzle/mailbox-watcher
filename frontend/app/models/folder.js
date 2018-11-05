import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr('string'),
  description: DS.attr('string'),
  max_age: DS.attr('string'),
  alert_regex: DS.attr('string'),
  number_of_mails: DS.attr('number'),
  alerts: DS.attr(),

  alert_mails: DS.hasMany('mail', {async:false}),
  mailbox: DS.belongsTo('mailbox', {async:false})
});
