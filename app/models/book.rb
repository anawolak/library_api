class Book < ApplicationRecord
    has_many :borrowings, foreign_key: 'book_id', dependent: :destroy
    has_one :active_borrowing, -> { where(returned_at: nil) }, 
            class_name: 'Borrowing', 
            foreign_key: 'book_id'
    has_one :current_borrower, through: :active_borrowing, source: :user

    validates :serial, presence: true, uniqueness: true
    
  def as_json(options = {})
    result = {
      serial: serial,
      title: title,
      author: author,
      borrowed_by: current_borrower&.full_name
    }
    if(options[:include_history])
      result[:borrowing_history] = borrowings.includes(:user).map do |borrowing|
        {
          user: borrowing.user.full_name,
          borrowed_at: borrowing.borrowed_at,
          returned_at: borrowing.returned_at,
          due_date: borrowing.due_date
        }
      end
    end
    result
  end
end
