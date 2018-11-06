import { helper } from "@ember/component/helper";

export function isAuthenticated() {
  const token = localStorage.getItem("authenticityToken");
  return Boolean(token);
}

export default helper(isAuthenticated);
