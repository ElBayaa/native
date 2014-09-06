class Channel < ActiveRecord::Base
  belongs_to :language

  def online_users
    User.online.where("#{self.id} = ANY (current_channels_ids)")
  end
end
