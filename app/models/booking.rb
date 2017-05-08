class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :listing
  before_create :overlapping_dates, :future_dates_only, :check_in_first
  validate :overlapping_dates, :future_dates_only, :check_in_first
  validates_presence_of :user_id, :listing_id, :check_in, :check_out

  # http://stackoverflow.com/questions/325933/determine-whether-two-date-ranges-overlap#325964
  # (StartA <= EndB) and (EndA >= StartB)
  def overlapping_dates
    return if self.listing_id.nil?

    self.listing.bookings.where.not(id: nil).each do |x|
      next if x == self
      if self.check_in <= x.check_out && self.check_out >= x.check_in
        self.errors.add(:check_in, "overlaps with #{x.to_json}")
      end
    end
  end

  def future_dates_only
    return if self.check_in.nil? || self.check_out.nil?

    if self.check_in <= DateTime.now || self.check_out <= DateTime.now
      self.errors.add(:check_in, "must check in and out in a future date")
    end
  end

  def check_in_first
    return if self.check_out.nil? || self.check_in.nil?

    if self.check_in >= self.check_out
      self.errors.add(:check_in, "must check in first")
    end
  end
end
