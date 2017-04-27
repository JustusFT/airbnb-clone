class User < ApplicationRecord
  include Clearance::User
  validates_confirmation_of :password
end
