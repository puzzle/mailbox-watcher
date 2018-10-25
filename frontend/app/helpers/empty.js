import { helper } from '@ember/component/helper';

export function empty(array) {
  array = [].concat(...array)
  return !array.length
}

export default helper(empty);
