import { module, test } from 'qunit';
import { setupTest } from 'ember-qunit';

module('Unit | Service | pending-operation', function(hooks) {
  setupTest(hooks);

  // Replace this with your real tests.
  test('it exists', function(assert) {
    let service = this.owner.lookup('service:pending-operation');
    assert.ok(service);
  });
});
