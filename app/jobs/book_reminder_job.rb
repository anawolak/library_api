class BookReminderJob < ApplicationJob
  queue_as :default

  def perform(*args)
    send_due_soon_reminders
    send_overdue_reminders
  end

  private

  def send_due_soon_reminders
    days_from_now = 3.days.from_now.beginning_of_day..3.days.from_now.end_of_day
    
    borrowings = Borrowing.active
                          .where(due_date: days_from_now)
                          .includes(:user, :book)
    
    borrowings.each do |borrowing|
      send_reminder(
        borrowing.user,
        borrowing.book,
        "Your borrowed book '#{borrowing.book.title}' is due in 3 days (#{borrowing.due_date.strftime('%Y-%m-%d')})"
      )
    end
  end

  def send_overdue_reminders
    borrowings = Borrowing.overdue.includes(:user, :book)
    
    borrowings.each do |borrowing|
      days_overdue = ((Time.current - borrowing.due_date) / 1.day).to_i
      send_reminder(
        borrowing.user,
        borrowing.book,
        "Your borrowed book '#{borrowing.book.title}' is #{days_overdue} day(s) overdue! Due date was #{borrowing.due_date.strftime('%Y-%m-%d')}"
      )
    end
  end

  def send_reminder(user, book, message)
    Rails.logger.info "Reminder message for #{user.full_name} (#{user.email}): #{message}"
    
    #TODO: Add mailing
  end
end
