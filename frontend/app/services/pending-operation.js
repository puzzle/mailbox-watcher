import Service from "@ember/service";

export default Service.extend({
  pending: true,

  pending() {
    return this.pending;
  },

  start() {
    this.pending = true;
  },

  done() {
    this.pending = false;
  }
});
