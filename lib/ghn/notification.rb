class Ghn
  class Notification
    def initialize(data)
      @data = data
    end

    def repo
      @data['repository']['full_name']
    end

    def type
      pull_request? ? 'pull' : 'issues'
    end

    def number
      @data['subject']['url'].match(/[^\/]+\z/).to_a.first
    end

    def pull_request?
      !!@data['subject']['url'].match(/pulls/)
    end

    def to_s
      "https://github.com/#{repo}/#{type}/#{number}"
    end
  end
end
