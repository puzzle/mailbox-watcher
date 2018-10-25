import { helper } from '@ember/component/helper';

export function token() {
  var token = localStorage.getItem('mail_mon_token')
  return (token) ? true : false
}

export default helper(token);
