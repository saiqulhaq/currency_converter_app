# == Schema Information
#
# Table name: rates
#
#  id              :bigint(8)        not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  historical_date :date
#  live_timestamp  :datetime
#

class Rate < ApplicationRecord
  include IdentityCache

  validates :historical_date, presence: true, if: -> { live_timestamp.nil? }
  validates :live_timestamp, presence: true, if: -> { historical_date.nil? }
  validate :prevent_type_conflict

  has_many :quotes, dependent: :delete_all, inverse_of: :rate
  cache_has_many :quotes

  def historical?
    historical_date.present?
  end

  def live?
    live_timestamp.present?
  end

  private

  def prevent_type_conflict
    if historical? && live?
      errors.add(:base, 'one of historical_date and live_timestamp should be blank')
      return false
    end
    true
  end
end
