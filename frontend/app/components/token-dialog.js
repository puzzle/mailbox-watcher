import $ from 'jquery';
import Component from '@ember/component';

export default Component.extend({
  didInsertElement() {
    if (localStorage.getItem('mail_mon_token') === null) {
      this.$('#open-modal-button').click();
    }

    $('form.token').on('submit', function(e){
      e.preventDefault();
      var token = $(this).children().children().val();
      localStorage.setItem('mail_mon_token', token);
      $('.modal-backdrop.fade.in').removeClass('modal-backdrop fade in');
      $('#token-modal').hide();
      location.reload();
    })
  }
});
