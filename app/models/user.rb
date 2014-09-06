class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  
  belongs_to :language

  scope :online, -> { where('last_active_at > ?', Time.now - 15.minutes) }

  def friends
    User.where(id: self.friends_ids)
  end
end
