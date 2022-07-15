class Item < ApplicationRecord
  belongs_to :merchant

  validates_presence_of :name
  validates_presence_of :description
  validates_presence_of :unit_price

  def self.search_by_fragment(frag)
    where("name ILIKE ?", "%#{frag}%")
  end
end
