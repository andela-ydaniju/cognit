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

class Investment < ActiveRecord::Base
end
