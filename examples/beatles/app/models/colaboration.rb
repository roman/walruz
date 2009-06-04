class Colaboration < ActiveRecord::Base
  
  has_many :songs, :as => :author
  has_and_belongs_to_many :beatles
  
end
