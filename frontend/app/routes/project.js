import AuthenticatedRoute from "./authenticated_route";

export default AuthenticatedRoute.extend({
  model(params) {
    return this.store.findRecord("project", params.projectname);
  },

  actions: {
    refresh: function() {
      this.refresh();
    }
  }
});
