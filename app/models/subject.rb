class Subject < ActiveRecord::Base
  has_many :professors
  attr_accessible :name
  validates_presence_of :name
end
