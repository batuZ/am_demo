# CarrierWave

This gem provides a simple and extremely flexible way to upload files from Ruby applications.
It works well with Rack based web applications, such as Ruby on Rails.
这个宝石提供了一个简单而非常灵活的方法来从Ruby应用程序上传文件。
它适用于基于Rack的Web应用程序，例如Ruby on Rails。


[![Build Status](https://travis-ci.org/carrierwaveuploader/carrierwave.svg?branch=master)](http://travis-ci.org/carrierwaveuploader/carrierwave)
[![Code Climate](http://img.shields.io/codeclimate/github/carrierwaveuploader/carrierwave.svg)](https://codeclimate.com/github/carrierwaveuploader/carrierwave)
[![git.legal](https://git.legal/projects/1363/badge.svg "Number of libraries approved")](https://git.legal/projects/1363)


## Information

* RDoc documentation [available on RubyDoc.info](http://rubydoc.info/gems/carrierwave/frames)
* Source code [available on GitHub](http://github.com/carrierwaveuploader/carrierwave)
* More information, known limitations, and how-tos [available on the wiki](https://github.com/carrierwaveuploader/carrierwave/wiki)

## Getting Help

* Please ask the community on [Stack Overflow](https://stackoverflow.com/questions/tagged/carrierwave) for help if you have any questions. Please do not post usage questions on the issue tracker.
* Please report bugs on the [issue tracker](http://github.com/carrierwaveuploader/carrierwave/issues) but read the "getting help" section in the wiki first.

## Installation

Install the latest release:

```
$ gem install carrierwave -v "1.0.0"
```

In Rails, add it to your Gemfile:

```ruby
gem 'carrierwave', '~> 1.0'
```

Finally, restart the server to apply the changes.
最后，重新启动服务器以应用更改。

As of version 1.0, CarrierWave requires Rails 4.0 or higher and Ruby 2.0
or higher. If you're on Rails 3, you should use v0.11.0.
从1.0版开始，CarrierWave需要Rails 4.0或更高版本和Ruby 2.0
或更高。 如果你在Rails 3，你应该使用v0.11.0。

## Getting Started 入门

Start off by generating an uploader:
通过生成上传器开始：

	rails generate uploader Avatar

this should give you a file in:
这应该给你一个文件：

	app/uploaders/avatar_uploader.rb

Check out this file for some hints on how you can customize your uploader. It
should look something like this:
查看这个文件有关如何自定义上传者的一些提示。 它应该看起来像这样：

```ruby
class AvatarUploader < CarrierWave::Uploader::Base
  storage :file
end
```

You can use your uploader class to store and retrieve files like this:
您可以使用上传者类来存储和检索这样的文件：

```ruby
uploader = AvatarUploader.new

uploader.store!(my_file)

uploader.retrieve_from_store!('my_file.png')
```

CarrierWave gives you a `store` for permanent storage, and a `cache` for
temporary storage. You can use different stores, including filesystem
and cloud storage.
CarrierWave为您提供永久存储的“存储”和“缓存”临时存储。 您可以使用不同的商店，包括文件系统和云存储。

Most of the time you are going to want to use CarrierWave together with an ORM.
It is quite simple to mount uploaders on columns in your model, so you can
simply assign files and get going:
大多数时候，您将要使用CarrierWave和ORM。将上传器安装在模型的列上是非常简单的，所以可以只需分配文件即可：

### ActiveRecord

Make sure you are loading CarrierWave after loading your ORM, otherwise you'll
need to require the relevant extension manually, e.g.:
确保在加载您的ORM后加载CarrierWave，否则你会需要手动要求相关的扩展，例如：

```ruby
require 'carrierwave/orm/activerecord'
```

Add a string column to the model you want to mount the uploader by creating
a migration:
通过创建将要添加上传者的模型列添加到模型中迁移：
  rails g scaffold User name avatar
	rails g migration add_avatar_to_users avatar:string
	rake db:migrate

Open your model file and mount the uploader:
打开你的模型文件并挂载上传者：

```ruby
class User < ActiveRecord::Base
  mount_uploader :avatar, AvatarUploader
end
```

Now you can cache files by assigning them to the attribute, they will
automatically be stored when the record is saved.
现在，您可以通过将文件分配给属性来缓存文件保存记录时自动存储。

```ruby
u = User.new
u.avatar = params[:file] # Assign a file like this, or

# like this
File.open('somewhere') do |f|
  u.avatar = f
end

u.save!
u.avatar.url # => '/url/to/file.png'
u.avatar.current_path # => 'path/to/file.png'
u.avatar_identifier # => 'file.png'
```

**Note**: `u.avatar` will never return nil, even if there is no photo associated to it.
To check if a photo was saved to the model, use `u.avatar.file.nil?` instead.
**注意**：`u.avatar`永远不会返回零，即使没有照片相关联。要检查照片是否保存到模型中，请改用`u.avatar.file.nil？`。

### DataMapper, Mongoid, Sequel

Other ORM support has been extracted into separate gems:
其他ORM支持已经提取到单独的宝石中：
* [carrierwave-datamapper](https://github.com/carrierwaveuploader/carrierwave-datamapper)
* [carrierwave-mongoid](https://github.com/carrierwaveuploader/carrierwave-mongoid)
* [carrierwave-sequel](https://github.com/carrierwaveuploader/carrierwave-sequel)

There are more extensions listed in [the wiki](https://github.com/carrierwaveuploader/carrierwave/wiki)

## Multiple file uploads
多个文件上传

CarrierWave also has convenient support for multiple file upload fields.
CarrierWave还支持多个文件上传领域。

### ActiveRecord

Add a column which can store an array. This could be an array column or a JSON
column for example. Your choice depends on what your database supports. For
example, create a migration like this:
添加一个可以存储数组的列。 这可以是数组列或JSON列。 您的选择取决于您的数据库支持。 例如，创建一个这样的迁移：

#### For databases with ActiveRecord json data type support (e.g. PostgreSQL, MySQL)
对于具有ActiveRecord json数据类型支持的数据库（例如PostgreSQL，MySQL）

	rails g migration add_avatars_to_users avatars:json
	rake db:migrate

#### For database without ActiveRecord json data type support (e.g. SQLite)
对于没有ActiveRecord json数据类型支持的数据库（例如SQLite）

	rails g migration add_avatars_to_users avatars:string
	rake db:migrate

__Note__: JSON datatype doesn't exists in SQLite adapter, that's why you can use a string datatype which will be serialized in model.
__Note__：SQLite适配器中不存在JSON数据类型，这就是为什么可以使用将在模型中序列化的字符串数据类型。

Open your model file and mount the uploader:
打开你的模型文件并挂载上传者：

```ruby
class User < ActiveRecord::Base
  mount_uploaders :avatars, AvatarUploader
  serialize :avatars, JSON # If you use SQLite, add this line.
end
```

Make sure your file input fields are set up as multiple file fields. For
example in Rails you'll want to do something like this:
确保您的文件输入字段设置为多个文件字段。 例如，在Rails中，您将需要执行以下操作：

```erb
<%= form.file_field :avatars, multiple: true %>
```

Also, make sure your upload controller permits the multiple file upload attribute, *pointing to an empty array in a hash*. For example:
此外，请确保您的上传控制器允许多个文件上传属性，*指向散列*中的空数组。 例如：

```ruby
params.require(:user).permit(:email, :first_name, :last_name, {avatars: []})
```

Now you can select multiple files in the upload dialog (e.g. SHIFT+SELECT), and they will
automatically be stored when the record is saved.
现在，您可以在上传对话框中选择多个文件（例如，SICKFT + SELECT），并在保存记录时自动存储。

```ruby
u = User.new(params[:user])
u.save!
u.avatars[0].url # => '/url/to/file.png'
u.avatars[0].current_path # => 'path/to/file.png'
u.avatars[0].identifier # => 'file.png'
```

## Changing the storage directory
更改存储目录

In order to change where uploaded files are put, just override the `store_dir`
method:
为了更改放置上传的文件，只需覆盖`store_dir`方法：

```ruby
class MyUploader < CarrierWave::Uploader::Base
  def store_dir
    'public/my/upload/directory'
  end
end
```

This works for the file storage as well as Amazon S3 and Rackspace Cloud Files.
Define `store_dir` as `nil` if you'd like to store files at the root level.
这适用于文件存储以及Amazon S3和Rackspace Cloud Files.Define`store_dir`为`nil`，如果要在根级别存储文件。

If you store files outside the project root folder, you may want to define `cache_dir` in the same way:
如果将文件存储在项目根文件夹外，可能需要以相同的方式定义“cache_dir”：

```ruby
class MyUploader < CarrierWave::Uploader::Base
  def cache_dir
    '/tmp/projectname-cache'
  end
end
```

## Securing uploads
保护上传
Certain files might be dangerous if uploaded to the wrong location, such as PHP
files or other script files. CarrierWave allows you to specify a whitelist of
allowed extensions or content types.
某些文件可能会被上传到错误的位置，例如PHP文件或其他脚本文件。 CarrierWave允许您指定允许的扩展或内容类型的白名单。

If you're mounting the uploader, uploading a file with the wrong extension will
make the record invalid instead. Otherwise, an error is raised.
如果您正在装载上传器，则上传扩展名错误的文件会使记录无效。 否则，会出现错误。

```ruby
class MyUploader < CarrierWave::Uploader::Base
  def extension_whitelist
    %w(jpg jpeg gif png)
  end
end
```

The same thing could be done using content types.
Let's say we need an uploader that accepts only images. This can be done like this
同样的事情可以使用内容类型来完成。据说我们需要一个只接受图像的上传器。 这可以这样做

```ruby
class MyUploader < CarrierWave::Uploader::Base
  def content_type_whitelist
    /image\//
  end
end
```

You can use a blacklist to reject content types.
Let's say we need an uploader that reject JSON files. This can be done like this
您可以使用黑名单来拒绝内容类型。据说我们需要一个拒绝JSON文件的上传者。 这可以这样做

```ruby
class NoJsonUploader < CarrierWave::Uploader::Base
  def content_type_blacklist
    ['application/text', 'application/json']
  end
end
```

### Filenames and unicode chars
文件名和unicode字符

Another security issue you should care for is the file names (see
[Ruby On Rails Security Guide](http://guides.rubyonrails.org/security.html#file-uploads)).
By default, CarrierWave provides only English letters, arabic numerals and some symbols as
white-listed characters in the file name. If you want to support local scripts (Cyrillic letters, letters with diacritics and so on), you have to override `sanitize_regexp` method. It should return regular expression which would match all *non*-allowed symbols.
您应该关心的另一个安全问题是文件名,默认情况下，CarrierWave仅提供英文字母，阿拉伯数字和一些符号
白名单中的文件名。 如果你想支持本地脚本（西里尔字母，带变音符号的字母等），你必须重写`sanitize_regexp`方法。 它应该返回正则表达式，它将匹配所有* non * -allowed符号。

```ruby
CarrierWave::SanitizedFile.sanitize_regexp = /[^[:word:]\.\-\+]/
```

Also make sure that allowing non-latin characters won't cause a compatibility issue with a third-party
plugins or client-side software.
还要确保允许非拉丁字符不会导致与第三方插件或客户端软件的兼容性问题。

## Setting the content type
设置内容类型

As of v0.11.0, the `mime-types` gem is a runtime dependency and the content type is set automatically.
You no longer need to do this manually.
从v0.11.0开始，`mime-types` gem是一个运行时依赖关系，内容类型是自动设置的。你不再需要手动这样做了。

## Adding versions
添加版本

Often you'll want to add different versions of the same file. The classic example is image thumbnails. There is built in support for this*:
通常你需要添加不同版本的同一个文件。 典型的例子是图像缩略图。 有内置的支持*：

*Note:* You must have Imagemagick and MiniMagick installed to do image resizing. MiniMagick is a Ruby interface for Imagemagick which is a C program. This is why MiniMagick fails on 'bundle install' without Imagemagick installed.
*注意：*您必须安装Imagemagick和MiniMagick才能进行图像调整大小。 MiniMagick是一个用于Imagemagick的Ruby界面，它是一个C程序。 这就是为什么MiniMagick在没有安装Imagemagick的“捆绑安装”中失败。

Some documentation refers to RMagick instead of MiniMagick but MiniMagick is recommended.
一些文档指的是RMagick而不是MiniMagick，但是建议使用MiniMagick。

To install Imagemagick on OSX with homebrew type the following:
要使用自制软件在OSX上安装Imagemagick，请键入以下内容：

```
$ brew install imagemagick
```

```ruby
class MyUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  process resize_to_fit: [800, 800]

  version :thumb do
    process resize_to_fill: [200,200]
  end

end
```

When this uploader is used, an uploaded image would be scaled to be no larger
than 800 by 800 pixels. A version called thumb is then created, which is scaled
and cropped to exactly 200 by 200 pixels. The uploader could be used like this:
当使用此上传者时，上传的图像将缩放到不超过800 x 800像素。 然后创建一个名为thumb的版本，该版本被缩放并裁剪为200×200像素。 上传者可以这样使用：

```ruby
uploader = AvatarUploader.new
uploader.store!(my_file)                              # size: 1024x768

uploader.url # => '/url/to/my_file.png'               # size: 800x800
uploader.thumb.url # => '/url/to/thumb_my_file.png'   # size: 200x200
```

One important thing to remember is that process is called *before* versions are
created. This can cut down on processing cost.
一个重要的事情要记住，这个进程被称为*之前*版本被创建。 这可以减少加工成本。

It is possible to nest versions within versions:
可以在版本中嵌套版本：

```ruby
class MyUploader < CarrierWave::Uploader::Base

  version :animal do
    version :human
    version :monkey
    version :llama
  end
end
```

### Conditional versions
有条件的版本
Occasionally you want to restrict the creation of versions on certain
properties within the model or based on the picture itself.
有时你想限制在模型中的某些属性上的版本创建，或者基于图片本身。

```ruby
class MyUploader < CarrierWave::Uploader::Base

  version :human, if: :is_human?
  version :monkey, if: :is_monkey?
  version :banner, if: :is_landscape?

private

  def is_human? picture
    model.can_program?(:ruby)
  end

  def is_monkey? picture
    model.favorite_food == 'banana'
  end

  def is_landscape? picture
    image = MiniMagick::Image.open(picture.path)
    image[:width] > image[:height]
  end

end
```

The `model` variable points to the instance object the uploader is attached to.
`model`变量指向上传者附加的实例对象。

### Create versions from existing versions
从现有版本创建版本

For performance reasons, it is often useful to create versions from existing ones
instead of using the original file. If your uploader generates several versions
where the next is smaller than the last, it will take less time to generate from
a smaller, already processed image.
出于性能原因，从现有版本创建版本，而不是使用原始文件通常是有用的。 如果您的上传者生成下一个小于上一个版本的多个版本，则从较小的已处理映像生成的时间将会更少。

```ruby
class MyUploader < CarrierWave::Uploader::Base

  version :thumb do
    process resize_to_fill: [280, 280]
  end

  version :small_thumb, from_version: :thumb do
    process resize_to_fill: [20, 20]
  end

end
```

The option `:from_version` uses the file cached in the `:thumb` version instead
of the original version, potentially resulting in faster processing.
选项`：from_version`使用缓存在`：thumb`版本而不是原始版本的文件，可能导致更快的处理。

## Making uploads work across form redisplays
使上传在整个表单重新显示中工作

Often you'll notice that uploaded files disappear when a validation fails.
CarrierWave has a feature that makes it easy to remember the uploaded file even
in that case. Suppose your `user` model has an uploader mounted on `avatar`
file, just add a hidden field called `avatar_cache` (don't forget to add it to
the attr_accessible list as necessary). In Rails, this would look like this:
通常你会注意到上传的文件在验证失败时消失.
CarrierWave有一个功能，即使在这种情况下也能轻松记住上传的文件。 
假设你的`user`模型有一个挂载在`avatar`文件上的上传者，
只需添加一个名为`avatar_cache`的隐藏字段（不要忘记根据需要将它添加到attr_accessible列表中）。
 在Rails中，这将如下所示：

```erb
<%= form_for @user, html: { multipart: true } do |f| %>
  <p>
    <label>My Avatar</label>
    <%= f.file_field :avatar %>
    <%= f.hidden_field :avatar_cache %>
  </p>
<% end %>
````

It might be a good idea to show the user that a file has been uploaded, in the
case of images, a small thumbnail would be a good indicator:
向用户显示一个文件已被上传可能是一个好主意，在图像的情况下，一个小的缩略图将是一个很好的指标：

```erb
<%= form_for @user, html: { multipart: true } do |f| %>
  <p>
    <label>My Avatar</label>
    <%= image_tag(@user.avatar_url) if @user.avatar? %>
    <%= f.file_field :avatar %>
    <%= f.hidden_field :avatar_cache %>
  </p>
<% end %>
```

## Removing uploaded files
删除上传的文件
If you want to remove a previously uploaded file on a mounted uploader, you can
easily add a checkbox to the form which will remove the file when checked.
如果要删除已挂载的上传者上一个上传的文件，您可以轻松地添加一个复选框，以便在选中时删除该文件。

```erb
<%= form_for @user, html: { multipart: true } do |f| %>
  <p>
    <label>My Avatar</label>
    <%= image_tag(@user.avatar_url) if @user.avatar? %>
    <%= f.file_field :avatar %>
  </p>

  <p>
    <label>
      <%= f.check_box :remove_avatar %>
      Remove avatar
    </label>
  </p>
<% end %>
```

If you want to remove the file manually, you can call <code>remove_avatar!</code>, then save the object.
如果要手动删除文件，可以调用<code> remove_avatar！</ code>，然后保存对象。

```erb
@user.remove_avatar!
@user.save
#=> true
```

## Uploading files from a remote location
从远程位置上传文件

Your users may find it convenient to upload a file from a location on the Internet
via a URL. CarrierWave makes this simple, just add the appropriate attribute to your
form and you're good to go:
您的用户可能会通过网址从Internet上的位置上传文件变得方便。 
CarrierWave使这个简单，只需添加适当的属性到您的表单，你很好去：

```erb
<%= form_for @user, html: { multipart: true } do |f| %>
  <p>
    <label>My Avatar URL:</label>
    <%= image_tag(@user.avatar_url) if @user.avatar? %>
    <%= f.text_field :remote_avatar_url %>
  </p>
<% end %>
```

If you're using ActiveRecord, CarrierWave will indicate invalid URLs and download
failures automatically with attribute validation errors. If you aren't, or you
disable CarrierWave's `validate_download` option, you'll need to handle those
errors yourself.
如果您正在使用ActiveRecord，则CarrierWave将显示无效的URL，并自动下载属性验证错误的故障。 如果没有，或者禁用CarrierWave的“validate_download”选项，则需要自己处理这些错误。

## Providing a default URL
提供默认网址

In many cases, especially when working with images, it might be a good idea to
provide a default url, a fallback in case no file has been uploaded. You can do
this easily by overriding the `default_url` method in your uploader:
在许多情况下，特别是在使用图像时，提供默认的网址可能是个好主意，如果没有上传文件，则可以使用回退。 您可以通过覆盖上传者中的“default_url”方法轻松地执行此操作：

```ruby
class MyUploader < CarrierWave::Uploader::Base
  def default_url(*args)
    "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  end
end
```

Or if you are using the Rails asset pipeline:
或者如果您使用Rails资产管道：

```ruby
class MyUploader < CarrierWave::Uploader::Base
  def default_url(*args)
    ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  end
end
```

## Recreating versions
重新创建版本

You might come to a situation where you want to retroactively change a version
or add a new one. You can use the `recreate_versions!` method to recreate the
versions from the base file. This uses a naive approach which will re-upload and
process the specified version or all versions, if none is passed as an argument.
您可能会遇到一个需要追溯更改版本或添加新版本的情况。 您可以使用`recreate_versions !`方法从基础文件重新创建版本。 这使用一种天真的方式，如果没有一个参数作为参数传递，它将重新上传和处理指定的版本或所有版本。

When you are generating random unique filenames you have to call `save!` on
the model after using `recreate_versions!`. This is necessary because
`recreate_versions!` doesn't save the new filename to the database. Calling
`save!` yourself will prevent that the database and file system are running
out of sync.
当您生成随机唯一的文件名时，您必须在使用`recreate_versions！`之后在模型上调用`save！`。 这是必要的，因为`recreate_versions！`不会将新的文件名保存到数据库。 自己调用`save !`会阻止数据库和文件系统运行不一致。

```ruby
instance = MyUploader.new
instance.recreate_versions!(:thumb, :large)
```

Or on a mounted uploader:
或者挂载上传者：

```ruby
User.find_each do |user|
  user.avatar.recreate_versions!
end
```

Note: `recreate_versions!` will throw an exception on records without an image. To avoid this, scope the records to those with images or check if an image exists within the block. If you're using ActiveRecord, recreating versions for a user avatar might look like this:
注意：`recreate_versions！`将在没有图像的记录上抛出异常。 
为了避免这种情况，将记录范围记录给具有图像的记录，或检查图像是否存在于块内。 
如果您使用的是ActiveRecord，则为用户头像创建版本可能如下所示：

```ruby
User.find_each do |user|
  user.avatar.recreate_versions! if user.avatar?
end
```

## Configuring CarrierWave
配置CarrierWave

CarrierWave has a broad range of configuration options, which you can configure,
both globally and on a per-uploader basis:
CarrierWave具有广泛的配置选项，可以在全球和每个上传器的基础上进行配置：

```ruby
CarrierWave.configure do |config|
  config.permissions = 0666
  config.directory_permissions = 0777
  config.storage = :file
end
```

Or alternatively:

```ruby
class AvatarUploader < CarrierWave::Uploader::Base
  permissions 0777
end
```

If you're using Rails, create an initializer for this:
如果您使用Rails，请为此创建一个初始值

	config/initializers/carrierwave.rb

If you want CarrierWave to fail noisily in development, you can change these configs in your environment file:
如果您希望CarrierWave在开发过程中失败，您可以在环境文件中更改这些配置：

```ruby
CarrierWave.configure do |config|
  config.ignore_integrity_errors = false
  config.ignore_processing_errors = false
  config.ignore_download_errors = false
end
```


## Testing with CarrierWave
##用CarrierWave测试

It's a good idea to test your uploaders in isolation. In order to speed up your
tests, it's recommended to switch off processing in your tests, and to use the
file storage. In Rails you could do that by adding an initializer with:
测试上传者是个好主意。 为了加快测试速度，建议在测试中关闭处理，并使用文件存储。 在Rails中，您可以通过添加一个初始化程序：

```ruby
if Rails.env.test? or Rails.env.cucumber?
  CarrierWave.configure do |config|
    config.storage = :file
    config.enable_processing = false
  end
end
```

Remember, if you have already set `storage :something` in your uploader, the `storage`
setting from this initializer will be ignored.
记住，如果您已经在上传者中设置了`storage：something`，那么这个初始化器的`storage`设置将被忽略。

If you need to test your processing, you should test it in isolation, and enable
processing only for those tests that need it.
如果需要测试您的处理，您应该单独进行测试，并且只能对那些需要的测试进行处理。

CarrierWave comes with some RSpec matchers which you may find useful:
CarrierWave带有一些您可能会发现的RSpec匹配器：

```ruby
require 'carrierwave/test/matchers'

describe MyUploader do
  include CarrierWave::Test::Matchers

  let(:user) { double('user') }
  let(:uploader) { MyUploader.new(user, :avatar) }

  before do
    MyUploader.enable_processing = true
    File.open(path_to_file) { |f| uploader.store!(f) }
  end

  after do
    MyUploader.enable_processing = false
    uploader.remove!
  end

  context 'the thumb version' do
    it "scales down a landscape image to be exactly 64 by 64 pixels" do
      expect(uploader.thumb).to have_dimensions(64, 64)
    end
  end

  context 'the small version' do
    it "scales down a landscape image to fit within 200 by 200 pixels" do
      expect(uploader.small).to be_no_larger_than(200, 200)
    end
  end

  it "makes the image readable only to the owner and not executable" do
    expect(uploader).to have_permissions(0600)
  end

  it "has the correct format" do
    expect(uploader).to be_format('png')
  end
end
```

Setting the enable_processing flag on an uploader will prevent any of the versions from processing as well.
Processing can be enabled for a single version by setting the processing flag on the version like so:
在上传器上设置enable_processing标志将阻止任何版本的处理。
可以通过在版本上设置处理标志来为单个版本启用处理：

```ruby
@uploader.thumb.enable_processing = true
```

## Fog

If you want to use fog you must add in your CarrierWave initializer the
following lines
如果要使用fog，您必须在CarrierWave初始化器中添加以下几行

```ruby
config.fog_provider = 'fog' # 'fog/aws' etc. Defaults to 'fog'
config.fog_credentials = { ... } # Provider specific credentials
```

## Using Amazon S3
使用亚马逊S3

[Fog AWS](http://github.com/fog/fog-aws) is used to support Amazon S3. Ensure you have it in your Gemfile:

```ruby
gem "fog-aws"
```

You'll need to provide your fog_credentials and a fog_directory (also known as a bucket) in an initializer.
For the sake of performance it is assumed that the directory already exists, so please create it if it needs to be.
You can also pass in additional options, as documented fully in lib/carrierwave/storage/fog.rb. Here's a full example:
您需要在初始化程序中提供您的fog_credentials和fog_directory（也称为bucket）。
为了表现，假设目录已经存在，所以如果需要，请创建它。
您还可以传递其他选项，如lib / carrierwave / storage / fog.rb中所述。 这是一个完整的例子：

```ruby
CarrierWave.configure do |config|
  config.fog_provider = 'fog/aws'                        # required
  config.fog_credentials = {
    provider:              'AWS',                        # required
    aws_access_key_id:     'xxx',                        # required
    aws_secret_access_key: 'yyy',                        # required
    region:                'eu-west-1',                  # optional, defaults to 'us-east-1'
    host:                  's3.example.com',             # optional, defaults to nil
    endpoint:              'https://s3.example.com:8080' # optional, defaults to nil
  }
  config.fog_directory  = 'name_of_directory'                          # required
  config.fog_public     = false                                        # optional, defaults to true
  config.fog_attributes = { cache_control: "public, max-age=#{365.day.to_i}" } # optional, defaults to {}
end
```

In your uploader, set the storage to :fog
在您的上传者中，将存储设置为：fog

```ruby
class AvatarUploader < CarrierWave::Uploader::Base
  storage :fog
end
```

That's it! You can still use the `CarrierWave::Uploader#url` method to return the url to the file on Amazon S3.
而已！ 您仍然可以使用“CarrierWave :: Uploader＃url”方法将URL返回到Amazon S3上的文件。

## Using Rackspace Cloud Files
使用Rackspace云文件

[Fog](http://github.com/fog/fog) is used to support Rackspace Cloud Files. Ensure you have it in your Gemfile:

```ruby
gem "fog"
```

You'll need to configure a directory (also known as a container), username and API key in the initializer.
For the sake of performance it is assumed that the directory already exists, so please create it if need be.
您需要在初始化程序中配置目录（也称为容器），用户名和API密钥。
为了表现，假设目录已经存在，因此如果需要，请创建它。

Using a US-based account:

```ruby
CarrierWave.configure do |config|
  config.fog_provider = "fog/rackspace/storage"   # optional, defaults to "fog"
  config.fog_credentials = {
    provider:           'Rackspace',
    rackspace_username: 'xxxxxx',
    rackspace_api_key:  'yyyyyy',
    rackspace_region:   :ord                      # optional, defaults to :dfw
  }
  config.fog_directory = 'name_of_directory'
end
```

Using a UK-based account:
使用基于英国的帐户：

```ruby
CarrierWave.configure do |config|
  config.fog_provider = "fog/rackspace/storage"   # optional, defaults to "fog"
  config.fog_credentials = {
    provider:           'Rackspace',
    rackspace_username: 'xxxxxx',
    rackspace_api_key:  'yyyyyy',
    rackspace_auth_url: Fog::Rackspace::UK_AUTH_ENDPOINT,
    rackspace_region:   :lon
  }
  config.fog_directory = 'name_of_directory'
end
```

You can optionally include your CDN host name in the configuration.
This is *highly* recommended, as without it every request requires a lookup
of this information.
您可以选择在配置中包括CDN主机名。
这是*高度推荐，因为没有它每个请求都需要查找这些信息。

```ruby
config.asset_host = "http://c000000.cdn.rackspacecloud.com"
```

In your uploader, set the storage to :fog

```ruby
class AvatarUploader < CarrierWave::Uploader::Base
  storage :fog
end
```

That's it! You can still use the `CarrierWave::Uploader#url` method to return
the url to the file on Rackspace Cloud Files.
而已！ 您仍然可以使用`CarrierWave :: Uploader＃url`方法将URL返回到Rackspace Cloud Files上的文件。

## Using Google Storage for Developers
##使用Google Storage for Developers

[Fog](http://github.com/fog/fog-google) is used to support Google Storage for Developers. Ensure you have it in your Gemfile:

```ruby
gem "fog-google"
gem "google-api-client", "> 0.8.5", "< 0.9"
gem "mime-types"
```

You'll need to configure a directory (also known as a bucket), access key id and secret access key in the initializer.
For the sake of performance it is assumed that the directory already exists, so please create it if need be.
您需要在初始化程序中配置目录（也称为存储桶），访问密钥ID和密钥访问密钥。
为了表现，假设目录已经存在，因此如果需要，请创建它。

Please read the [fog-google README](https://github.com/fog/fog-google/blob/master/README.md) on how to get credentials.


```ruby
CarrierWave.configure do |config|
  config.fog_provider = 'fog/google'                        # required
  config.fog_credentials = {
    provider:                         'Google',
    google_storage_access_key_id:     'xxxxxx',
    google_storage_secret_access_key: 'yyyyyy'
  }
  config.fog_directory = 'name_of_directory'
end
```

In your uploader, set the storage to :fog

```ruby
class AvatarUploader < CarrierWave::Uploader::Base
  storage :fog
end
```

That's it! You can still use the `CarrierWave::Uploader#url` method to return
the url to the file on Google.
而已！ 您仍然可以使用`CarrierWave :: Uploader＃url`方法将网址返回到Google上的文件。

## Optimized Loading of Fog
## fog装载优化

Since Carrierwave doesn't know which parts of Fog you intend to use, it will just load the entire library (unless you use e.g. [`fog-aws`, `fog-google`] instead of fog proper). If you prefer to load fewer classes into your application, you need to load those parts of Fog yourself *before* loading CarrierWave in your Gemfile.  Ex:
由于Carrierwave不知道您打算使用哪些Fog部件，所以它只会加载整个库（除非您使用例如[`fog-aws`，`fog-google`]而不是fog适用）。 如果您希望在应用程序中加载较少的类，则需要在您的Gemfile中加载CarrierWave之前，自己加载Fog的这些部分。例如：

```ruby
gem "fog", "~> 1.27", require: "fog/rackspace/storage"
gem "carrierwave"
```

A couple of notes about versions:
* This functionality was introduced in Fog v1.20.
* This functionality is slated for CarrierWave v1.0.0.
关于版本的几个注释：
*此功能在Fog v1.20中引入。
*此功能预计将用于CarrierWave v1.0.0。

If you're not relying on Gemfile entries alone and are requiring "carrierwave" anywhere, ensure you require "fog/rackspace/storage" before it.  Ex:
如果您不依赖Gemfile条目，并且在任何地方都要求“载波”，请确保在之前需要“雾/机架/存储”。例如：

```ruby
require "fog/rackspace/storage"
require "carrierwave"
```

Beware that this specific require is only needed when working with a fog provider that was not extracted to its own gem yet.
A list of the extracted providers can be found in the page of the `fog` organizations [here](https://github.com/fog).
请注意，仅当使用未提取到其自己的宝石的雾提供者时才需要此具体要求。
提取的提供者的列表可以在`fog`组织[这里]（https://github.com/fog）的页面中找到。

When in doubt, inspect `Fog.constants` to see what has been loaded.
当有疑问时，请检查“雾”，查看已加载的内容。

## Dynamic Asset Host
##动态资产主机

The `asset_host` config property can be assigned a proc (or anything that responds to `call`) for generating the host dynamically. The proc-compliant object gets an instance of the current `CarrierWave::Storage::Fog::File` or `CarrierWave::SanitizedFile` as its only argument.
`asset_host`配置属性可以分配一个proc（或任何响应`call`的东西），用于动态生成主机。
proc兼容对象获取当前的“CarrierWave :: Storage :: Fog :: File”或“CarrierWave :: SanitizedFile”的实例作为其唯一的参数。

```ruby
CarrierWave.configure do |config|
  config.asset_host = proc do |file|
    identifier = # some logic
    "http://#{identifier}.cdn.rackspacecloud.com"
  end
end
```

## Using RMagick

If you're uploading images, you'll probably want to manipulate them in some way,
you might want to create thumbnail images for example. CarrierWave comes with a
small library to make manipulating images with RMagick easier, you'll need to
include it in your Uploader:
如果您正在上传图像，则可能需要以某种方式操作它们，例如，您可能需要创建缩略图。 CarrierWave带有一个小图书馆，可以轻松操作RMagick的图像，您需要将其包含在您的Uploader中：

```ruby
class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
end
```

The RMagick module gives you a few methods, like
`CarrierWave::RMagick#resize_to_fill` which manipulate the image file in some
way. You can set a `process` callback, which will call that method any time a
file is uploaded.
RMagick模块为您提供了一些方法，如“CarrierWave :: RMagick＃resize_to_fill”，它以某种方式处理图像文件。 你可以设置一个`process`回调，这个方法会在文件上传时调用该方法。

There is a demonstration of convert here.
Convert will only work if the file has the same file extension, thus the use of the filename method.
这里有一个转换的示范。
如果文件具有相同的文件扩展名，那么转换只能使用文件名方法。

```ruby
class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  process resize_to_fill: [200, 200]
  process convert: 'png'

  def filename
    super.chomp(File.extname(super)) + '.png' if original_filename.present?
  end
end
```

Check out the manipulate! method, which makes it easy for you to write your own
manipulation methods.
看看操纵！ 方法，这使您很容易编写自己的操作方法。

## Using MiniMagick

MiniMagick is similar to RMagick but performs all the operations using the 'mogrify'
command which is part of the standard ImageMagick kit. This allows you to have the power
of ImageMagick without having to worry about installing all the RMagick libraries.
MiniMagick类似于RMagick，但是使用“mogrify”命令来执行所有操作，该命令是标准ImageMagick工具包的一部分。 这样您就可以拥有ImageMagick的强大功能，而无需担心安装所有的RMagick库。

See the MiniMagick site for more details:
有关详细信息，请参阅MiniMagick网站：
https://github.com/minimagick/minimagick

And the ImageMagick command line options for more for whats on offer:
ImageMagick命令行选项可用于更多信息：
http://www.imagemagick.org/script/command-line-options.php

  Currently, the MiniMagick carrierwave processor provides exactly the same methods as
  for the RMagick processor.
目前，MiniMagick载波处理器提供与RMagick处理器完全相同的方法。

```ruby
class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  process resize_to_fill: [200, 200]
end
```

## Migrating from Paperclip
从Paperclip迁移
If you are using Paperclip, you can use the provided compatibility module:
如果您使用的是Paperclip，则可以使用提供的兼容性模块：

```ruby
class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::Compatibility::Paperclip
end
```

See the documentation for `CarrierWave::Compatibility::Paperclip` for more
details.
有关详细信息，请参阅“CarrierWave :: Compatibility :: Paperclip”的文档。
Be sure to use mount_on to specify the correct column:
确保使用mount_on来指定正确的列：

```ruby
mount_uploader :avatar, AvatarUploader, mount_on: :avatar_file_name
```

## I18n

The Active Record validations use the Rails i18n framework. Add these keys to
your translations file:
活动记录验证使用Rails i18n框架。 将这些密钥添加到您的翻译文件中：

```yaml
errors:
  messages:
    carrierwave_processing_error: "Cannot resize image."
    carrierwave_integrity_error: "Not an image."
    carrierwave_download_error: "Couldn't download image."
    extension_whitelist_error: "You are not allowed to upload %{extension} files, allowed types: %{allowed_types}"
    extension_blacklist_error: "You are not allowed to upload %{extension} files, prohibited types: %{prohibited_types}"
```

## Large files

By default, CarrierWave copies an uploaded file twice, first copying the file into the cache, then
copying the file into the store.  For large files, this can be prohibitively time consuming.
默认情况下，CarrierWave将上传的文件复制两次，首先将文件复制到缓存中，然后将文件复制到存储中。 对于大文件，这可能是非常耗时的。

You may change this behavior by overriding either or both of the `move_to_cache` and
`move_to_store` methods:
您可以通过覆盖“move_to_cache”和“move_to_store”方法中的一个或两个来更改此行为：

```ruby
class MyUploader < CarrierWave::Uploader::Base
  def move_to_cache
    true
  end

  def move_to_store
    true
  end
end
```

When the `move_to_cache` and/or `move_to_store` methods return true, files will be moved (instead of copied) to the cache and store respectively.
当“move_to_cache”和/或“move_to_store”方法返回true时，文件将被移动（而不是复制）到缓存并分别存储。

This has only been tested with the local filesystem store.
这只是使用本地文件系统存储进行测试。

## Skipping ActiveRecord callbacks
##跳过ActiveRecord回调
By default, mounting an uploader into an ActiveRecord model will add a few
callbacks. For example, this code:
默认情况下，将上传器加载到ActiveRecord模型中将添加一些回调。 例如，这段代码：

```ruby
class User
  mount_uploader :avatar, AvatarUploader
end
```

Will add these callbacks:
会添加这些回调：
```ruby
after_save :store_avatar!
before_save :write_avatar_identifier
after_commit :remove_avatar!, on: :destroy
after_commit :mark_remove_avatar_false, on: :update
after_save :store_previous_changes_for_avatar
after_commit :remove_previously_stored_avatar, on: :update
```

If you want to skip any of these callbacks (eg. you want to keep the existing
avatar, even after uploading a new one), you can use ActiveRecord’s
`skip_callback` method.
如果您想跳过任何这些回调（例如，您想保留现有的头像，即使上传新的头像），也可以使用ActiveRecord的“skip_callback”方法。

```ruby
class User
  mount_uploader :avatar, AvatarUploader
  skip_callback :commit, :after, :remove_previously_stored_avatar
end
```

## Contributing to CarrierWave
##贡献给CarrierWave

See [CONTRIBUTING.md](https://github.com/carrierwaveuploader/carrierwave/blob/master/CONTRIBUTING.md)

## License

Copyright (c) 2008-2015 Jonas Nicklas

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
