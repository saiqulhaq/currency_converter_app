# frozen_string_literal: true

# == Schema Information
#
# Table name: rates
#
#  id         :bigint(8)        not null, primary key
#  date       :date
#  hour       :integer
#  historical :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :rate do
    date { rand(100).days.ago }
    hour { rand(23) }
    historical { [true, false].sample }
  end
end
