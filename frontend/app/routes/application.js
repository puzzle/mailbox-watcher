import Route from '@ember/routing/route';

export default Route.extend({

  model()  {
    var mailMonToken = localStorage.getItem('authenticityToken')

    if (mailMonToken != null) {
      return this.store.findAll('project', { token: mailMonToken })
    }
  }
});
