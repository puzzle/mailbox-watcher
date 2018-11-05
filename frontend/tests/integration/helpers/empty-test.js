import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('empty', 'helper:empty', {
  integration: true
});

test('it works', function(assert) {
  this.render(hbs`{{empty ['something'] }}`);

  assert.equal(this.$().text().trim(), 'false');
  
  this.render(hbs`{{empty }}`);

  assert.equal(this.$().text().trim(), 'true');
});
