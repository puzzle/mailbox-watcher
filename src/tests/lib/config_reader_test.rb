# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../lib/config_reader'

class ConfigReaderTest < Test::Unit::TestCase
  context 'collect projects' do
    def test_collect_projects
      Dir.expects(:glob)
         .with(['config/*.yml'])
         .returns(['test/project1.yml',
                   'test/project2.yml'])
      config_reader.expects(:base_path)
                   .returns(path_to_fixtures)
                   .times(4)

      projects = config_reader.projects

      project1 = projects.first
      assert_equal 'project1', project1.projectname
      assert_equal 'This is a project-description', project1.description

      mailbox1 = project1.mailboxes.first
      assert_equal 'mailbox1', mailbox1.name
      assert_equal 'This is a mailbox-description', mailbox1.description

      imap_config = mailbox1.imap_config
      assert_equal 'mailbox1', imap_config.mailboxname
      assert_equal 'hostname.example.com', imap_config.hostname
      assert_equal 'cGFzc3dvcmQ=\\n', imap_config.password
      assert_equal 144, imap_config.port
      assert_equal true, imap_config.ssl
      assert_equal 'dXNlcg==\\n', imap_config.username

      folder1 = mailbox1.folders.first
      assert_equal 'folder1', folder1.name
      assert_equal 'This is a folder-description', folder1.description
      assert_equal '/(Error|Failure)/', folder1.alert_regex
      assert_equal 2, folder1.max_age
    end

    def test_project_valid_if_max_age_not_defined
      Dir.expects(:glob)
         .with(['config/*.yml'])
         .returns(['test/valid_config_file_without_max_age.yml'])
      config_reader.expects(:base_path)
                   .returns(path_to_fixtures)
      config_reader.expects(:yaml_path)
                   .with('valid_config_file_without_max_age')
                   .returns("#{path_to_fixtures}/config/project1.yml")

      projects = config_reader.projects
      assert_equal [], projects.first
                               .mailboxes.first
                               .folders.first.errors
    end

    def test_project_valid_if_alert_regex_not_defined
      Dir.expects(:glob)
         .with(['config/*.yml'])
         .returns(['test/valid_config_file_without_alert_regex.yml'])
      config_reader.expects(:base_path)
                   .returns(path_to_fixtures)
      config_reader.expects(:yaml_path)
                   .with('valid_config_file_without_alert_regex')
                   .returns("#{path_to_fixtures}/config/project1.yml")

      projects = config_reader.projects
      assert_equal [], projects.first
                               .mailboxes.first
                               .folders.first.errors
    end

    def test_secret_file_does_not_exist
      Dir.expects(:glob)
         .with(['config/*.yml'])
         .returns(['test/project1.yml'])
      config_reader.expects(:yaml_path)
                   .with('project1')
                   .returns("#{path_to_fixtures}/not_existing_file.yml")
      config_reader.expects(:base_path)
                   .returns(path_to_fixtures)

      config_reader.projects
      assert_equal 'Secret-File for project project1 does not exist',
                   config_reader.errors.first
    end

    def test_error_appears_if_invalid_config_file_no_folders
      Dir.expects(:glob)
         .with(['config/*.yml'])
         .returns(['test/invalid_config_file_without_folder.yml'])
      config_reader.expects(:base_path)
                   .returns(path_to_fixtures)
      config_reader.expects(:yaml_path)
                   .with('invalid_config_file_without_folder')
                   .returns("#{path_to_fixtures}/config/project1.yml")

      assert_equal 'Folders in mailbox mailbox1 are not valid',
                   config_reader.projects.first
                                .mailboxes.first
                                .errors.first
    end

    def test_error_appears_if_invalid_config_file_no_fitting_mailbox_in_secret_file
      config_path = '/config/project1.yml'
      secret_path = '/secrets/invalid_secret_file_without_mailbox.yml'
      config_file = YAML.load_file(path_to_fixtures + config_path)
      secret_file = YAML.load_file(path_to_fixtures + secret_path)

      Dir.expects(:glob)
         .with(['config/*.yml'])
         .returns(['test/project1.yml'])
      config_reader.expects(:base_path)
                   .returns(path_to_fixtures)
                   .times(2)
      config_reader.expects(:load_file)
                   .with("#{path_to_fixtures}/config/project1.yml")
                   .returns(config_file)
      config_reader.expects(:load_file)
                   .with("#{path_to_fixtures}/secrets/project1.yml")
                   .returns(secret_file)

      projects = config_reader.projects
      assert_equal 'Mailbox mailbox1 is not defined in Secret-File',
                   projects.first
                           .mailboxes.first
                           .errors.first
    end

    def test_error_appears_if_invalid_config_file_no_mailboxes
      Dir.expects(:glob)
         .with(['config/*.yml'])
         .returns(['test/invalid_config_file_without_mailbox.yml'])
      config_reader.expects(:base_path)
                   .returns(path_to_fixtures)
      config_reader.expects(:yaml_path)
                   .with('invalid_config_file_without_mailbox')
                   .returns("#{path_to_fixtures}/config/project1.yml")

      projects = config_reader.projects
      assert_equal 'Mailboxes in project invalid_config_file_without_mailbox are not valid',
                   projects.first.errors.first
    end

    def test_error_appears_if_invalid_config_file_no_rules
      Dir.expects(:glob)
         .with(['config/*.yml'])
         .returns(['test/invalid_config_file_without_rules.yml'])
      config_reader.expects(:base_path)
                   .returns(path_to_fixtures)
      config_reader.expects(:yaml_path)
                   .with('invalid_config_file_without_rules')
                   .returns("#{path_to_fixtures}/config/project1.yml")

      projects = config_reader.projects
      assert_equal 'Rules in folder folder1 are not valid',
                   projects.first
                           .mailboxes.first
                           .folders.first
                           .errors.first
    end
  end

  context 'collect imap config' do
    def test_error_appears_if_invalid_secret_file_no_hostname
      config_path = '/config/project1.yml'
      secret_path = '/secrets/invalid_secret_file_without_hostname.yml'
      config_file = YAML.load_file(path_to_fixtures + config_path)
      secret_file = YAML.load_file(path_to_fixtures + secret_path)

      Dir.expects(:glob)
         .with(['config/*.yml'])
         .returns(['test/project1.yml'])
      config_reader.expects(:base_path)
                   .returns(path_to_fixtures)
                   .times(2)
      config_reader.expects(:load_file)
                   .with("#{path_to_fixtures}/config/project1.yml")
                   .returns(config_file)
      config_reader.expects(:load_file)
                   .with("#{path_to_fixtures}/secrets/project1.yml")
                   .returns(secret_file)

      projects = config_reader.projects
      assert_equal  'hostname is not defined in mailbox1 mailbox options',
                    projects.first
                            .mailboxes.first
                            .imap_config.errors.first
    end

    def test_error_appears_if_invalid_secret_file_no_requirements
      config_path = '/config/project1.yml'
      secret_path = '/secrets/invalid_secret_file_without_requirements.yml'
      config_file = YAML.load_file(path_to_fixtures + config_path)
      secret_file = YAML.load_file(path_to_fixtures + secret_path)

      Dir.expects(:glob)
         .with(['config/*.yml'])
         .returns(['test/project1.yml'])
      config_reader.expects(:base_path)
                   .returns(path_to_fixtures)
                   .times(2)
      config_reader.expects(:load_file)
                   .with("#{path_to_fixtures}/config/project1.yml")
                   .returns(config_file)
      config_reader.expects(:load_file)
                   .with("#{path_to_fixtures}/secrets/project1.yml")
                   .returns(secret_file)

      projects = config_reader.projects
      assert_equal ['hostname is not defined in mailbox1 mailbox options',
                    'username is not defined in mailbox1 mailbox options',
                    'password is not defined in mailbox1 mailbox options'],
                   projects.first
                           .mailboxes.first
                           .imap_config.errors
    end

    def test_imap_config_valid_if_valid_secret_file_without_port_and_without_tls
      config_path = '/config/project1.yml'
      secret_path = '/secrets/valid_secret_file_without_port_and_without_tls.yml'
      config_file = YAML.load_file(path_to_fixtures + config_path)
      secret_file = YAML.load_file(path_to_fixtures + secret_path)

      Dir.expects(:glob)
         .with(['config/*.yml'])
         .returns(['test/project1.yml'])
      config_reader.expects(:base_path)
                   .returns(path_to_fixtures)
                   .times(2)
      config_reader.expects(:load_file)
                   .with("#{path_to_fixtures}/config/project1.yml")
                   .returns(config_file)
      config_reader.expects(:load_file)
                   .with("#{path_to_fixtures}/secrets/project1.yml")
                   .returns(secret_file)

      projects = config_reader.projects
      assert_equal [], projects.first
                               .mailboxes.first
                               .imap_config.errors
    end
  end

  private

  def config_reader
    @config_reader ||= ConfigReader.new
  end

  def path_to_fixtures
    'src/tests/fixtures'
  end
end
