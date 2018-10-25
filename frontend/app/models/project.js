import DS from 'ember-data';

export default DS.Model.extend({
  projectname: DS.attr('string'),
  description: DS.attr('string'),
  alerts: DS.attr(),

  mailboxes: DS.hasMany('mailbox', {async:false})
});
