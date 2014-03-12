class Subject < ActiveRecord::Base
  has_many :professors
  attr_accessible :name
end
