# README

## 创建工程

## 引用说明 gemfile
	* 密码gem
	 gem 'bcrypt', '~> 3.1.7'

	* 上传文件gem
	 gem 'carrierwave', '~> 1.0'

	图片上传相对路径：#"/uploads/user/avatar/4/weixin.png"
	u.avatar.url

	图片上传绝对路径：#"/test_carrierwave/public/uploads/user/avatar/4/weixin.png"
	u.avatar.current_path 

	图片名称：#"weixin.png" 
	u.avatar.identifier 

	图片未save前的临时文件： “=> "1504499678-34439-0002-7702/21.jpg" ”
	u.avatar_cache

## 模型
	rails g scaffold User name password_digest
	rails g scaffold Project name user_id:integer
	rails g controller sessions new create destroy
    rails g uploader Avatar(mount_uploader :avatar, AvatarUploader)

    --- Group ---
	rails g scaffold Group name project_id:integer 'focal_length:decimal{5,2}' width:integer height:integer 'ccd_width:decimal{5.3}' 'ccd_height:decimal{5,3}' camera_model


    --- Photo ---
	rails g scaffold Photo name group_id:integer tagPath avatar
    rails g migration add_pos_to_photos 'X:decimal{18,10}' 'Y:decimal{18,10}' 'Z:decimal{8,3}'
    rails g migration remove_pos_from_photos X:decimal Y:decimal Z:decimal camera_model width:integer height:integer focal_length:decimal


