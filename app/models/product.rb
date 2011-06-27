class Product < ActiveRecord::Base
  default_scope :order => 'title'
  has_many :line_items
  before_destroy :ensure_not_referenced_by_any_line_item

  validates :title, :description, :image_url, :presence => true
  validates :price, :numericality => { :greater_than_or_equal_to => 0.01 }
  validates :image_url, :format => {
    :with     => %r{\.(gif|jpg|png)$}i,
    :message  => 'must be URL for GIF, JPG or PNG image.'
  }
  validates :title, :uniqueness => true, :length =>  { :minimum => 10, :message => "must be at least 10 characters long" }

  private

    def ensure_not_referenced_by_any_line_item
      if line_items.empty?
        true
      else
        errors.add(:base, 'Line Items present')
        false
      end
    end
end
