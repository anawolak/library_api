class User < ApplicationRecord
  self.primary_key = 'id'
  has_many :borrowed_books, class_name: 'Book', foreign_key: 'borrowed_by'
  
  validates :email, presence: true, uniqueness: true
end
