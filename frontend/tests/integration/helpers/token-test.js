import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('authenticityToken', 'helper:token', {
  integration: true
});

test('it works', function(assert) {
  this.render(hbs`{{authenticityToken}}`);

  assert.equal(this.$().text().trim(), 'false');
});
