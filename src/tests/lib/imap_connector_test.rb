# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../../lib/imap_connector'

class ImapConnectorTest < Test::Unit::TestCase
  context 'mail by id' do
    def test_does_not_return_mail_by_id_if_sever_not_reachable
      Net::IMAP.expects(:new)
               .with('hostname.example.com', port: 143)
               .raises(SocketError)

      assert_nil imap_connector.mail('inbox', 3)
      assert_equal 'IMAP-Server hostname.example.com not reachable',
                   imap_connector.errors.first
    end

    def test_does_not_return_mail_by_id_if_authentication_failed
      imap = mock('imap')
      Net::IMAP.expects(:new)
               .with('hostname.example.com', port: 143)
               .returns(imap)
      imap.expects(:authenticate)
          .with('LOGIN', 'bob', '1234')
          .raises(error('authentication failed'))

      assert_nil imap_connector.mail('inbox', 3)
      assert_equal ['Authentication to hostname.example.com failed'],
                   imap_connector.errors
    end

    def test_does_not_return_mail_by_id_if_folder_not_exist
      imap = mock('imap')
      Net::IMAP.expects(:new)
               .with('hostname.example.com', port: 143)
               .returns(imap)
      imap.expects(:authenticate)
          .with('LOGIN', 'bob', '1234')
          .returns(ok_response)
      imap.expects(:select)
          .with('not-existing-folder')
          .raises(error('Mailbox does not exist'))
      imap.expects(:search).never

      assert_nil imap_connector.mail('not-existing-folder', 3)
      assert_equal ['Mailbox does not exist'], imap_connector.errors
    end

    def test_does_not_return_mail_if_mail_with_id_does_not_exist
      imap = mock('imap')
      Net::IMAP.expects(:new)
               .with('hostname.example.com', port: 143)
               .returns(imap)
      imap.expects(:authenticate)
          .with('LOGIN', 'bob', '1234')
          .returns(ok_response)
      imap.expects(:select)
          .with('inbox')
          .returns(ok_response)
      imap.expects(:fetch)
          .with(42, 'ENVELOPE')
          .raises(error('No matching messages (0.000 sec)'))

      assert_nil imap_connector.mail('inbox', 42)
      assert_equal ['Mail does not exist'], imap_connector.errors
    end

    def test_returns_mail_by_id
      imap = mock('imap')
      Net::IMAP.expects(:new)
               .with('hostname.example.com', port: 143)
               .returns(imap)
      imap.expects(:authenticate)
          .with('LOGIN', 'bob', '1234')
          .returns(ok_response)
      imap.expects(:select)
          .with('inbox')
          .returns(ok_response)
      imap.expects(:fetch)
          .with(3, 'ENVELOPE')
          .returns(fetched_data)

      mail = imap_connector.mail('inbox', 3)

      assert_equal 'Build failed in Jenkins', mail.subject
    end

    def test_does_not_return_mail_by_id_if_folder_is_empty
      imap = mock('imap')
      Net::IMAP.expects(:new)
               .with('hostname.example.com', port: 143)
               .returns(imap)
      imap.expects(:authenticate)
          .with('LOGIN', 'bob', '1234')
          .returns(ok_response)
      imap.expects(:select)
          .with('empty-folder')
          .raises(error('Invalid sequence in Fetch'))
      imap.expects(:search).never

      assert_nil imap_connector.mail('empty-folder', 3)
      assert_equal ['Folder empty-folder is empty'], imap_connector.errors
    end
  end

  context 'mails from folder' do
    def test_does_not_return_mails_if_sever_not_reachable
      Net::IMAP.expects(:new)
               .with('hostname.example.com', port: 143)
               .raises(SocketError)

      assert_nil imap_connector.mails_from_folder('inbox')
      assert_equal ['IMAP-Server hostname.example.com not reachable'],
                   imap_connector.errors
    end

    def test_does_not_return_mails_if_authentication_failed
      imap = mock('imap')
      Net::IMAP.expects(:new)
               .with('hostname.example.com', port: 143)
               .returns(imap)
      imap.expects(:authenticate)
          .with('LOGIN', 'bob', '1234')
          .raises(error('authentication failed'))

      assert_nil imap_connector.mails_from_folder('not-existing-folder')
      assert_equal ['Authentication to hostname.example.com failed'],
                   imap_connector.errors
    end

    def test_does_not_return_mails_if_folder_not_exist
      imap = mock('imap')
      Net::IMAP.expects(:new)
               .with('hostname.example.com', port: 143)
               .returns(imap)
      imap.expects(:authenticate)
          .with('LOGIN', 'bob', '1234')
          .returns(ok_response)
      imap.expects(:select)
          .with('not-existing-folder')
          .raises(error('Mailbox does not exist'))
      imap.expects(:search).never

      assert_nil imap_connector.mails_from_folder('not-existing-folder')
      assert_equal ['Folder not-existing-folder does not exist'],
                   imap_connector.errors
    end

    def test_returns_mails_from_folder
      imap = mock('imap')
      Net::IMAP.expects(:new)
               .with('hostname.example.com', port: 143)
               .returns(imap)
      imap.expects(:authenticate)
          .with('LOGIN', 'bob', '1234')
          .returns(ok_response)
      imap.expects(:select)
          .with('inbox')
          .returns(ok_response)
      imap.expects(:search)
          .with(['ALL'])
          .returns([1, 2, 3])

      assert_equal [1, 2, 3], imap_connector.mails_from_folder('inbox')
    end
  end
  context 'most recent mail date' do
    def test_does_not_return_most_recent_mail_date_if_sever_not_reachable
      Net::IMAP.expects(:new)
               .with('hostname.example.com', port: 143)
               .raises(SocketError)

      assert_nil imap_connector.most_recent_mail_date('inbox')
      assert_equal ['IMAP-Server hostname.example.com not reachable'],
                   imap_connector.errors
    end

    def test_does_not_return_most_recent_mail_date_if_authentication_failed
      imap = mock('imap')
      Net::IMAP.expects(:new)
               .with('hostname.example.com', port: 143)
               .returns(imap)
      imap.expects(:authenticate)
          .with('LOGIN', 'bob', '1234')
          .raises(error('authentication failure'))

      assert_nil imap_connector.most_recent_mail_date('inbox')
      assert_equal ['Authentication to hostname.example.com failed'],
                   imap_connector.errors
    end

    def test_does_not_return_most_recent_mail_date_if_folder_not_exist
      imap = mock('imap')
      Net::IMAP.expects(:new)
               .with('hostname.example.com', port: 143)
               .returns(imap)
      imap.expects(:authenticate)
          .with('LOGIN', 'bob', '1234')
          .returns(ok_response)
      imap.expects(:select)
          .with('not-existing-folder')
          .raises(error('Mailbox does not exist'))
      imap.expects(:search).never

      assert_nil imap_connector.most_recent_mail_date('not-existing-folder')
      assert_equal ['Mailbox does not exist'], imap_connector.errors
    end

    def test_returns_most_recent_mail_date
      imap = mock('imap')
      Net::IMAP.expects(:new)
               .with('hostname.example.com', port: 143)
               .returns(imap)
               .times(2)
      imap.expects(:authenticate)
          .with('LOGIN', 'bob', '1234')
          .returns(ok_response)
          .times(2)
      imap.expects(:select)
          .with('inbox')
          .returns(ok_response)
          .times(2)
      imap.expects(:search)
          .with(['ALL'])
          .returns([1, 2, 3])
      imap.expects(:fetch)
          .with(3, 'ENVELOPE')
          .returns(fetched_data)

      time = Time.new(2018, 7, 31, 8)
      assert_equal time, imap_connector.most_recent_mail_date('inbox')
    end

    def test_returns_mails_by_ids
      imap = mock('imap')
      Net::IMAP.expects(:new)
               .with('hostname.example.com', port: 143)
               .returns(imap)
      imap.expects(:authenticate)
          .with('LOGIN', 'bob', '1234')
          .returns(ok_response)
      imap.expects(:select)
          .with('inbox')
          .returns(ok_response)
      ids = [3, 4, 5]
      imap.expects(:fetch)
          .with(ids, 'ENVELOPE')
          .returns([fetched_data, fetched_data, fetched_data])

      mails = imap_connector.mails('inbox', ids)

      assert_equal 'Build failed in Jenkins',
                   mails[0][0].attr['ENVELOPE'].subject
      assert_equal 'Build failed in Jenkins',
                   mails[1][0].attr['ENVELOPE'].subject
      assert_equal 'Build failed in Jenkins',
                   mails[2][0].attr['ENVELOPE'].subject
    end

    def test_does_not_return_mails_by_ids_if_id_does_not_exist
      imap = mock('imap')
      Net::IMAP.expects(:new)
               .with('hostname.example.com', port: 143)
               .returns(imap)
      imap.expects(:authenticate)
          .with('LOGIN', 'bob', '1234')
          .returns(ok_response)
      imap.expects(:select)
          .with('inbox')
          .returns(ok_response)
      ids = [3, 4, 5]
      imap.expects(:fetch)
          .with(ids, 'ENVELOPE')
          .raises(Net::IMAP::Error, 'No matching messages')

      imap_connector.mails('inbox', ids)

      assert_equal ['Mail does not exist'], imap_connector.errors
    end
  end

  private

  def imap_connector
    imap_config = ImapConfig.new(mailboxname: 'mailbox1',
                                 username: base64_username,
                                 password: base64_password,
                                 hostname: 'hostname.example.com')
    @imap_connector ||= ImapConnector.new(imap_config)
  end

  def ok_response
    response = Net::IMAP::TaggedResponse.new
    response.name = 'OK'
    response
  end

  def error(error_message)
    Net::IMAP::NoResponseError.new(bad_response(error_message))
  end

  def bad_response(error_message)
    response = Net::IMAP::TaggedResponse.new
    response.name = 'No'
    text = Net::IMAP::ResponseText.new
    text.text = error_message
    response.data = text
    response
  end

  def fetched_data
    data = Net::IMAP::FetchData.new
    data.attr = { 'ENVELOPE' => envelope }
    [data]
  end

  def envelope
    envelope = Net::IMAP::Envelope.new
    envelope.date = 'Tue, 31 Jul 2018 08:00:00 +0200'
    envelope.subject = 'Build failed in Jenkins'
    envelope
  end

  def base64_username
    Base64.encode64('bob')
  end

  def base64_password
    Base64.encode64('1234')
  end
end
