# JwtDenylist class inherits from ApplicationRecord and includes the Devise JWT Revocation Strategy Denylist.
# This class is used to manage JWT tokens that have been revoked or should no longer be valid.
class JwtDenylist < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Denylist

  # Sets the table name for this model to 'jwt_denylist'.
  self.table_name = 'jwt_denylist'
end
