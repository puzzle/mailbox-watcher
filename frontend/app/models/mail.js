import DS from 'ember-data';

export default DS.Model.extend({
  subject: DS.attr('string'),
  sender: DS.attr('string'),
  received_at: DS.attr('string'),

  folder: DS.belongsTo('folder', {async:false})
});
