require 'ghn/version'
require 'ghn/token'
require 'ghn/command'
require 'ghn/notification'
require 'github_api'

class Ghn
  def initialize(token, command)
    @token = token
    @command = command
  end

  def run
    send(@command.command, *@command.args)
  end

  def run_print
    run.each do |notification|
      process(notification)
    end
  end

  def process(notification)
    case
    when @command.open?
      system "open #{notification}"
    when @command.read?
      mark(notification)
      puts marked(notification)
    when @command.list?
      puts notification
    else
      raise ArgumentError, "no such command: #{@command.command}"
    end
  end

  def client
    @client ||= Github.new(oauth_token: @token.token)
  end

  def list(target = nil)
    params = {}
    unless target.nil?
      params['user'], params['repo'] = target.split('/')
    end

    client.activity.notifications.list(params).map { |data| Ghn::Notification.new(data) }
  end

  def mark(notification, read = true)
    client.activity.notifications.mark(thread_id: notification['id'], read: read)
  end

  def marked(notification)
    "[x] #{notification}"
  end
end
