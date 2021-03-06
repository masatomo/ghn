class Ghn
  class Notification
    attr_reader :notification, :follow_issuecomment

    def initialize(notification, follow_issuecomment)
      @notification = notification
      @follow_issuecomment = follow_issuecomment
    end

    def type_class
      klass = "#{subject_type}Notification"
      Ghn.const_get(klass)
    rescue NameError
      Ghn::UnknownNotification
    end

    def url
      if follow_issuecomment && comment?
        "https://github.com/#{repo_full_name}/#{type}/#{thread_number}#issuecomment-#{comment_number}"
      else
        "https://github.com/#{repo_full_name}/#{type}/#{thread_number}"
      end
    end

    private

    def comment?
      notification[:subject][:url] != notification[:subject][:latest_comment_url]
    end

    def repo_full_name
      notification[:repository][:full_name]
    end

    def subject_type
      notification[:subject][:type]
    end

    def thread_number
      notification[:subject][:url].match(/[^\/]+\z/)[-1]
    end

    def comment_number
      if comment?
        notification[:subject][:latest_comment_url].match(/\d+\z/)[-1]
      end
    end
  end

  class IssueNotification < Notification
    def type
      'issues'
    end
  end

  class PullRequestNotification < Notification
    def type
      'pull'
    end
  end

  class CommitNotification < Notification
    def type
      'commit'
    end
  end

  class ReleaseNotification < Notification
    def url
      url = notification[:subject][:url]
      result = JSON.parse(Net::HTTP.get(URI.parse(url)))
      result['html_url']
    end
  end

  class UnknownNotification < Notification
    def url
      warn "unknown subject type #{subject_type}"
    end
  end
end
