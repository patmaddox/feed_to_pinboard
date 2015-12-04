class Feed < ActiveRecord::Base
  validates :url, presence: true
  validate  :validate_parseable

  def url=(url)
    self[:url] = url.gsub('feed://', 'http://') if url
  end

  def entries
    @entries ||= Feedjira::Feed.fetch_and_parse(url).entries
  end

  def post_to_pinboard
    entries.each do |e|
      p e
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
