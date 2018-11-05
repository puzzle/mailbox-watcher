import { helper } from '@ember/component/helper';

export function authenticityToken() {
  var token = localStorage.getItem('authenticityToken')
  return (token) ? true : false
}

export default helper(authenticityToken);
