import AuthenticatedRoute from "./authenticated_route";

export default AuthenticatedRoute.extend({
  model() {
    const token = localStorage.getItem("authenticityToken");
    const authenticated = Boolean(token);
    if (!authenticated) return;
    return this.store.findAll("project");
  },

  actions: {
    error: function(error) {
      const status = error.errors[0].status;
      switch (status) {
        case "401": {
          localStorage.removeItem("authenticityToken");
          location.reload();
          break;
        }
        case "404": {
          this.transitionTo("/");
          break;
        }
        default: {
          break;
        }
      }
    }
  }
});
