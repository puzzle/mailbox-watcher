import { helper } from '@ember/component/helper';

export function and([ firstArg, ...restArgs ]) {
  return restArgs.every(a => a && firstArg)
}

export default helper(and);
