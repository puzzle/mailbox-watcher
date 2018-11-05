import DS from 'ember-data';

export default DS.Model.extend({
  project: DS.belongsTo('project', {async:false}),
  name: DS.attr('string'),
  description: DS.attr('string'),
  status: DS.attr('string'),
  alerts: DS.attr(),

  folders: DS.hasMany('folder', {async:false})
});
