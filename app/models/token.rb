class Token < ActiveRecord::Base
  def self.default
    where('token IS NOT NULL').first
  end
end
