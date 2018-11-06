import AuthenticatedRoute from "./authenticated_route";
import { inject as service } from "@ember/service";

export default AuthenticatedRoute.extend({
  pendingOperation: service(),
  model(params) {
    pendingOperation.start();
    this.store
      .findRecord("project", params.projectname)
      .then(function(project) {
        pendingOperation.stop();
        return project;
      });
  },

  actions: {
    refresh: function() {
      this.refresh();
    }
  }
});
