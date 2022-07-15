class Merchant < ApplicationRecord
  has_many :items

  validates_presence_of :name

  def self.search_by_name(keyword)
      where("name ILIKE ?", "%#{keyword}%").order(name: :asc).first
  end
end
