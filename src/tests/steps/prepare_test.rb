# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../steps/prepare'
require_relative '../../models/project'
require_relative '../../models/mailbox'
require_relative '../../models/imap_config'
require_relative '../../models/folder'

class PrepareTest < Test::Unit::TestCase
  context 'prepare project' do
    def test_prepare_project
      Dir.expects(:glob)
         .with(['config/*.yml'])
         .returns(['test/project1.yml'])
      ConfigReader.any_instance
                  .expects(:base_path)
                  .returns('src/tests/fixtures')
                  .times(2)

      prepare_step = Prepare.new('project1')
      project1 = prepare_step.execute

      assert_equal 'project1', project1.projectname
      assert_equal 'mailbox1', project1.mailboxes.first.name
      assert_equal [], prepare_step.errors
      assert_equal 200, prepare_step.state
    end

    def test_does_not_return_not_existing_project
      Dir.expects(:glob)
         .with(['config/*.yml'])
         .returns(['test/project1.yml'])
      ConfigReader.any_instance.expects(:base_path)
                  .returns('src/tests/fixtures')
                  .times(2)

      prepare_step = Prepare.new('not-existing-project')
      assert_equal nil, prepare_step.execute
      assert_equal 'Config for project not-existing-project not found',
                   prepare_step.errors.first
      assert_equal 404, prepare_step.state
    end

    def test_does_not_return_project_with_no_secret_file
      Dir.expects(:glob)
         .with(['config/*.yml'])
         .returns(['test/project1.yml'])
      ConfigReader.any_instance
                  .expects(:base_path)
                  .returns('src/tests/fixtures')
      ConfigReader.any_instance
                  .expects(:yaml_path)
                  .returns('src/tests/fixtures/secrets/not-existing-file.yml')

      prepare_step = Prepare.new('not-existing-project')
      assert_equal nil, prepare_step.execute
      assert_equal 'Secret-File for project project1 does not exist',
                   prepare_step.errors.first
      assert_equal 404, prepare_step.state
    end
  end
end
