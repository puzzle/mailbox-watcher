import Route from '@ember/routing/route';
export default Route.extend({

  model(params) {
    var mailMonToken = localStorage.getItem('mail_mon_token')
    return this.store.findRecord('project', params.projectname, { token: mailMonToken })
  },

  actions: {
    reloadModel: function() {
      this.modelFor('project').reload();
    }
  }
});
