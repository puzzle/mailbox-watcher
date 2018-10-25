import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('token', 'helper:token', {
  integration: true
});

test('it works', function(assert) {
  this.render(hbs`{{token}}`);

  assert.equal(this.$().text().trim(), 'false');
});
