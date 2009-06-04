require 'walruz/policies'

class Song < ActiveRecord::Base
  
  check_authorizations :sing => Policies::AuthorOrColabororPolicy,
                       :sell => Policies::AuthorAndNotColaboratorPolicy
  
  belongs_to :author, :polymorphic => true
  
end
