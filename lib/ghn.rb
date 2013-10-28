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
      puts marked(notification.to_s)
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

  def self.usage
    <<MESSAGE
Usage: #{File.basename $0} [options] [command] [user/repo]
    options:   -h, --help, --usage  Show this message

    command:   list   List unread notifications
               open   Open notifications in browser
               read   Mark as read listed notifications

    user/repo: GitHub user and repository (e.g. github/hubot)
               You can specify it to narrow down target notifications

MESSAGE
  end

  def self.no_token
    <<MESSAGE
** Authorization required.

Please set ghn.token to your .gitconfig.
    $ git config --global ghn.token [Your GitHub access token]

To get new token, visit
https://github.com/settings/tokens/new

MESSAGE
  end
end
