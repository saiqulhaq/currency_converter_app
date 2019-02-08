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

class Rate < ApplicationRecord
end
