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
  include IdentityCache
  has_many :quotes, dependent: :delete_all
  cache_has_many :quotes
end
