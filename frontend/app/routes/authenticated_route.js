import Route from "@ember/routing/route";
import { isBlank } from "@ember/utils";

export default Route.extend({
  beforeModel() {
    const token = localStorage.getItem("authenticityToken");
    if (isBlank(token)) {
      this.transitionTo("login");
    }
  }
});
