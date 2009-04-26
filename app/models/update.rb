class Update < ActiveRecord::Base
  belongs_to :user

  UPDATE_TYPE = {
    :announcement => 0,
    :stock => 1,
    :job_announcement => 2,
    :wall_post => 3
  }.freeze

end
