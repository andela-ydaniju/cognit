# == Schema Information
#
# Table name: investments
#
#  id          :integer          not null, primary key
#  name        :string
#  cost        :integer
#  invest_type :string
#  long_term   :string
#  short_term  :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
name = ['Happy Child', 'Own a House', 'Joy Ride']
cost = [45_000, 2_100_000, 1_000_050]
invest_type = ['School Savings', 'Real Estate', 'Car Purchase']

3.times do |i|
  Investment.create(
    name: name[i],
    cost: cost[i],
    invest_type: invest_type[i]
  )
end
