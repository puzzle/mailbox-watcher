import Route from "@ember/routing/route";

export default Route.extend({
  model() {
    const authenticityToken = localStorage.getItem("authenticityToken");

    if (authenticityToken != null) {
      return this.store.findAll("project", { token: authenticityToken });
    }
  }
});
