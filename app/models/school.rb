class School < ApplicationRecord
  has_many :users
  has_many :sections
  has_many :levels
end
