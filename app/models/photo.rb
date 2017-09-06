class Photo < ApplicationRecord
	mount_uploader :avatar, AvatarUploader
	belongs_to :group
	validates 	:name, :group_id, presence: true

end
