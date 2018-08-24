# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../models/folder'

class FolderTest < Test::Unit::TestCase
  context 'validate folder' do
    def test_folder_valid
      folder = Folder.new('folder1',
                          'this is a folder description',
                          2,
                          '/(Error|Failure)/')

      assert_equal [], folder.errors
    end

    def test_folder_valid_max_age_undefined
      folder = Folder.new('folder1',
                          'this is a folder description',
                          nil,
                          '/(Error|Failure)/')

      assert_equal [], folder.errors
    end

    def test_folder_valid_regex_undefined
      folder = Folder.new('folder1',
                          'this is a folder description',
                          2,
                          nil)

      assert_equal [], folder.errors
    end

    def test_folder_invalid_max_age_and_regex_undefined
      folder = Folder.new('folder1',
                          'this is a folder description',
                          nil,
                          nil)

      assert_equal 'Rules in folder folder1 are not valid', folder.errors.first
    end
  end
end
