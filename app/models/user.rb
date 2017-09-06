class User < ApplicationRecord
	has_many :projects, dependent: :destroy

	validates 	:name, 
				presence: true, 
				uniqueness: true, 					#验证唯一性,不区分大小写
				uniqueness: {case_sensitive: false} #验证唯一性,区分大小写

				
	# validates	:email,
	# 			presence: true, 
	# 			format: {with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },#格式验证
	# 			uniqueness: true, 
	# 			uniqueness: {case_sensitive: false} 

	validates	:password, presence: true, length: { minimum: 6 }	#长度验证

	#添加密码  需要安装 gem 'bcrypt', '~> 3.1.7'
  	has_secure_password #validations: true
 	#user = User.new(u_name: 'batu',u_email: 'batu@qq.com',password: 'aaa',password_confirmation: 'aaa' )
end