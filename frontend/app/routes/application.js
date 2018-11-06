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
      if (error.errors[0].status === "401") {
        localStorage.removeItem("authenticityToken");
        location.reload();
      }
    }
  }
});
