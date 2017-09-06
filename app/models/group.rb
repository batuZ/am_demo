class Group < ApplicationRecord
	belongs_to :project
	has_many :photos, dependent: :destroy

	validates 	:name, :project_id, presence: true

end