import { and } from 'mailbox-watcher/helpers/and';
import { module, test } from 'qunit';

module('Unit | Helper | and');

test('it works', function(assert) {
  assert.equal(and([true, true]), true);

  assert.equal(and([false,true]), false);

  assert.equal(and([false,false]), false);

  assert.equal(and([false,false,true]), false);

  assert.equal(and([true,true,true]), true);

  assert.equal(and([true, true,false]), false);
});
