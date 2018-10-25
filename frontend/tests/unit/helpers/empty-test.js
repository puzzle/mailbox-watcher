import { empty } from 'mailbox-watcher/helpers/empty';
import { module, test } from 'qunit';

module('Unit | Helper | empty');

test('it works', function(assert) {
  assert.equal(empty([['something']]), false);
  
  assert.equal(empty([[]]), true);
});
