# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../lib/config_reader'

class ConfigReaderTest < Test::Unit::TestCase
  context 'validate config file' do
    def test_error_appears_if_config_file_does_not_exist
      config_reader.expects(:yaml_path).returns('src/tests/fixtures/config/not_existing_file.yml')

      assert_equal false, config_reader.validate_config_file
      assert_equal 'File src/tests/fixtures/config/not_existing_file.yml does not exist', config_reader.errors.first
    end

    def test_error_appears_if_no_rules_defined
      config_reader.expects(:yaml_path).returns('src/tests/fixtures/config/invalid_config_file_without_rules.yml')

      assert_equal false, config_reader.validate_config_file
      assert_equal 'Rules in folder folder1 are not valid', config_reader.errors.first
    end

    def test_error_appears_if_no_folder_defined
      config_reader.expects(:yaml_path).returns('src/tests/fixtures/config/invalid_config_file_without_folder.yml')

      assert_equal false, config_reader.validate_config_file
      assert_equal 'Folders in mailbox mailbox1 are not valid', config_reader.errors.first
    end

    def test_error_appears_if_no_mailbox_defined_in_config_file
      config_reader.expects(:yaml_path).returns('src/tests/fixtures/config/invalid_config_file_without_mailbox.yml')

      assert_equal false, config_reader.validate_config_file
      assert_equal 'Mailboxes in project my-project are not valid', config_reader.errors.first
    end

    def test_config_file_valid
      config_reader.expects(:yaml_path).returns('src/tests/fixtures/config/valid_config_file.yml')

      assert_equal true, config_reader.validate_config_file
    end

    def test_config_file_valid_if_max_age_not_defined
      config_reader.expects(:yaml_path).returns('src/tests/fixtures/config/valid_config_file_without_max_age.yml')

      assert_equal true, config_reader.validate_config_file
    end

    def test_config_file_valid_if_alert_regex_not_defined
      config_reader.expects(:yaml_path).returns('src/tests/fixtures/config/valid_config_file_without_alert_regex.yml')

      assert_equal true, config_reader.validate_config_file
    end
  end
 
 context 'validate secret file' do
    def test_error_appears_if_secret_file_does_not_exist
      config_reader.expects(:yaml_path).returns('src/tests/fixtures/secrets/not_existing_file.yml')

      assert_equal false, config_reader.validate_secret_file
      assert_equal 'File src/tests/fixtures/secrets/not_existing_file.yml does not exist', config_reader.errors.first
    end

    def test_error_appears_if_no_mailbox_defined_in_secret_file
      config_reader.expects(:yaml_path).returns('src/tests/fixtures/secrets/invalid_secret_file_without_mailbox.yml')

      assert_equal false, config_reader.validate_secret_file
      assert_equal 'Mailboxes in project my-project are not valid', config_reader.errors.first
    end

    def test_error_appears_if_no_hostname_defined
      config_reader.expects(:yaml_path).returns('src/tests/fixtures/secrets/invalid_secret_file_without_hostname.yml')

      assert_equal false, config_reader.validate_secret_file
      assert_equal 'Hostname is not defined in mailbox1 mailbox options', config_reader.errors.first
    end

    def test_error_appears_if_no_username_defined
      config_reader.expects(:yaml_path).returns('src/tests/fixtures/secrets/invalid_secret_file_without_username.yml')

      assert_equal false, config_reader.validate_secret_file
      assert_equal 'Username is not defined in mailbox1 mailbox options', config_reader.errors.first
    end

    def test_error_appears_if_no_password_defined
      config_reader.expects(:yaml_path).returns('src/tests/fixtures/secrets/invalid_secret_file_without_password.yml')

      assert_equal false, config_reader.validate_secret_file
      assert_equal 'Password is not defined in mailbox1 mailbox options', config_reader.errors.first
    end

    def test_secret_file_valid
      config_reader.expects(:yaml_path).returns('src/tests/fixtures/secrets/valid_secret_file.yml')

      assert_equal true, config_reader.validate_secret_file
    end

    def test_secret_file_valid_if_port_not_defined
      config_reader.expects(:yaml_path).returns('src/tests/fixtures/secrets/valid_secret_file_without_port.yml')

      assert_equal true, config_reader.validate_secret_file
    end

    def test_secret_file_valid_if_tls_not_defined
      config_reader.expects(:yaml_path).returns('src/tests/fixtures/secrets/valid_secret_file_without_tls.yml')

      assert_equal true, config_reader.validate_secret_file
    end
  end

  context 'collect project settings' do
    def test_collect_project_settings_from_config_file
      config_reader.expects(:yaml_path).returns('src/tests/fixtures/config/valid_config_file.yml')

      assert_equal true, config_reader.validate_config_file
      assert_equal 'This is a project-description', config_reader.project_description
      assert_equal 'This is a mailbox-description', config_reader.mailbox_description('mailbox1')
      assert_equal 'This is a folder-description', config_reader.folder_description('mailbox1', 'folder1')
      assert_equal '/(Error|Failure)/', config_reader.alert_regex('mailbox1', 'folder1')
      assert_equal 2, config_reader.max_age('mailbox1', 'folder1')
    end
  end

  context 'collect imap config' do
    def test_collect_imap_config_from_secret_file
      config_reader.expects(:yaml_path).returns('src/tests/fixtures/secrets/valid_secret_file.yml')

      imap_config = {'hostname'=> 'hostname.example.com',
                     'password'=> 'password',
                     'port'=> 144,
                     'tls'=> 'start_tls',
                     'username'=> 'user'}

      assert_equal true, config_reader.validate_secret_file
      assert_equal imap_config, config_reader.imap_config('mailbox1')
    end
  end

  private

  def config_reader
    @config_reader ||= ConfigReader.new('my-project')
  end
end
