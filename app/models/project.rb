class Project < ApplicationRecord
	belongs_to :user
	has_many :groups, dependent: :destroy

	validates 	:name, :user_id, presence: true

end
