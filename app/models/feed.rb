class Feed < ActiveRecord::Base
  validates :url, presence: true
  validate  :validate_parseable

  def self.post_all_to_pinboard
    all.each(&:post_to_pinboard)
  end

  def url=(url)
    self[:url] = url.gsub('feed://', 'http://') if url
  end

  def entries
    @entries ||= Feedjira::Feed.fetch_and_parse(url).entries
  end

  def post_to_pinboard
    pinboard = Pinboard::Client.new(token: Token.default.token)

    entries.each do |e|
      pinboard.add url: e.url, description: e.title
    end
  end

  def validate_parseable
    begin
      entries
    rescue
      errors.add(:url, "isn't parseable")
    end
  end
end
