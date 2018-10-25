import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('and', 'helper:and', {
  integration: true
});

test('it works', function(assert) {
  this.render(hbs`{{and true true}}`);

  assert.equal(this.$().text().trim(), 'true');

  this.render(hbs`{{and 1 1}}`);

  assert.equal(this.$().text().trim(), 'true');

  this.render(hbs`{{and 0 true 'test'}}`);

  assert.equal(this.$().text().trim(), 'false');

  this.render(hbs`{{and 1 true 'test'}}`);

  assert.equal(this.$().text().trim(), 'true');

  this.render(hbs`{{and 0 1 true}}`);

  assert.equal(this.$().text().trim(), 'false');

  this.render(hbs`{{and 1 true 1 'test'}}`);

  assert.equal(this.$().text().trim(), 'true');
});
