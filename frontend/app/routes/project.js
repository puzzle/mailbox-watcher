import AuthenticatedRoute from "./authenticated_route";

export default AuthenticatedRoute.extend({
  model(params) {
    return this.store
      .findRecord("project", params.projectname)
      .then(function(project) {
        return project;
      })
      .catch(function(error) {
        if (error.errors[0].status == 404) {
          return {
            error: true,
            message: "Project '" + params.projectname + "' was not found"
          };
        }
      });
  },

  actions: {
    reloadModel: function() {
      this.modelFor("project").reload();
    }
  }
});
