class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :listing
  before_create :overlapping_dates, :future_dates_only, :check_in_first
  validate :overlapping_dates, :future_dates_only, :check_in_first

  # http://stackoverflow.com/questions/325933/determine-whether-two-date-ranges-overlap#325964
  # (StartA <= EndB) and (EndA >= StartB)

  def overlapping_dates
    Booking.all.each do |x|
      if self.check_in <= x.check_out && self.check_out >= x.check_in
        self.errors.add(:check_in, "overlaps")
      end
    end
  end

  def future_dates_only
    if self.check_out <= DateTime.now
      self.errors.add(:check_in, "must check in and out in a future date")
    end
  end

  def check_in_first
    if self.check_in >= self.check_out
      self.errors.add(:check_in, "must check in first")
    end
  end
end
