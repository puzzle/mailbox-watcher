import Route from '@ember/routing/route';

export default Route.extend({

  model()  {
    var mailMonToken = localStorage.getItem('mail_mon_token')

    if (mailMonToken != null) {
      return this.store.findAll('project', { token: mailMonToken })
    }
  }
});
