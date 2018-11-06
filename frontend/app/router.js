import EmberRouter from '@ember/routing/router';
import config from './config/environment';

const Router = EmberRouter.extend({
  location: config.locationType,
  rootURL: config.rootURL
});

Router.map(function() {
  this.route('project', { path: '/projects/:projectname'});
  this.route('home' , { path: '/'});
  this.route('login');
});

export default Router;
