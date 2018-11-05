import Route from '@ember/routing/route';
export default Route.extend({

  model(params) {
    var mailMonToken = localStorage.getItem('authenticityToken')
    return this.store.findRecord('project', params.projectname, { token: mailMonToken })
      .then(function(project){
        return project
      }).catch(function(error){
        if (error.errors[0].status == 404) {
          return {
                  'error': true,
                  'message': "Project '" + params.projectname + "' was not found"
                  };
        }
      });
  },

  actions: {
    reloadModel: function() {
      this.modelFor('project').reload();
    }
  }
});
