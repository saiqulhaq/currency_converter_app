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

require 'rails_helper'

RSpec.describe Rate, type: :model do
  it 'historical column should be default false' do
    expect(subject.historical).to be_falsey
  end

  it 'should has unique date+hour' do
    create(:rate, date: Date.today, hour: 1)
    instance_y = build(:rate, date: Date.today, hour: 1)
    expect { instance_y.save }.to raise_error

    instance_y.hour = 2
    expect(instance_y.save).to be_truthy
  end

  it 'should has many quotes' do
    instance = described_class.new
    expect(instance).to respond_to(:quotes)
    expect(instance.quotes).to be_a(ActiveRecord::Associations::CollectionProxy)
  end
end
