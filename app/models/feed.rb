class Feed < ActiveRecord::Base
  validates :url, presence: true, uniqueness: true
  validate  :validate_parseable

  def self.post_all_to_pinboard
    all.each(&:post_to_pinboard)
  end

  def url=(url)
    self[:url] = url.gsub('feed://', 'http://') if url
  end

  def feed
    @feed ||= Feedjira::Feed.fetch_and_parse(url)
  end

  def latest_entries
    last_modified ? entries.select {|e| e.last_modified > last_modified } : entries
  end

  def entries
    feed.entries
  end

  def post_to_pinboard
    pinboard = Pinboard::Client.new(token: Token.default.token)

    latest_entries.each do |e|
      pinboard.add url: e.url, description: e.title
    end

    update_attribute :last_modified, feed.last_modified
  end

  def validate_parseable
    begin
      entries
    rescue
      errors.add(:url, "isn't parseable")
    end
  end
end
