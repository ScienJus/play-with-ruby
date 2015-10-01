#使用Devise添加登录、注册模块

Devise是Rails上得一个权限认证组件，可以非常快速的生成登录、注册、找回密码等功能的，并且非常简单易用。

###安装Devise

在项目的Gemfile文件中添加devise

```
gem 'devise'
```

安装gem后输入以下指令：

```
rails generate devise:install
```

这时会弹出一串文字告诉你需要做哪些准备工作，大概意思为：

确保环境文件中定义了该项目的url，例如在`config/environments/development.rb`文件中添加如下代码：
 
```
config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
```

确保该项目定义了主页路径，例如在`config/routes.rb`中定义：

```
root to: "home#index"
```

确保`app/views/layouts/application.html.erb`中添加了消息提醒，例如：

```
<p class="notice"><%= notice %></p>
<p class="alert"><%= alert %></p>
```

可以通过`rails g devise:views`命令定制页面模板。

###基础应用

首先使用`rails g devise User`生成用户模型（可以将User换成其他名称，例如Admin）。

在需要验证权限的Controller中添加`before_action :authenticate_user!`，例如：

```
class HomeController < ApplicationController
  before_action :authenticate_user!
  def index
  end
end
```

启动服务器，在浏览器中打开`http://localhost:3000`，会发现自动跳转到了`http://localhost:3000/users/sign_in`，说明devise已经配置好了。

###添加邮箱验证

devise默认在注册时不会验证邮箱，需要自行配置：

首先打开`app/models/user.rb`，在`devise`中添加`:confirmable`：

```
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable
end
```

然后编辑`db/migrate/devise_create_users.rb`，去除与邮箱验证相关的注释（4条属性，1个索引）：

```
class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      ## Database authenticatable
      t.string :email,              null: false, default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      ## Rememberable
      t.datetime :remember_created_at

      ## Trackable
      t.integer  :sign_in_count, default: 0, null: false
      t.datetime :current_sign_in_at
      t.datetime :last_sign_in_at
      t.string   :current_sign_in_ip
      t.string   :last_sign_in_ip

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable

      ## Lockable
      # t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      # t.string   :unlock_token # Only if unlock strategy is :email or :both
      # t.datetime :locked_at


      t.timestamps null: false
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :confirmation_token,   unique: true
    # add_index :users, :unlock_token,         unique: true
  end
end
```

在`config/application.rb`中配置一个邮箱：

```
config.action_mailer.delivery_method = :smtp
config.action_mailer.smtp_settings = {
  :address => "smtp.qq.com",
  :port => 587,
  :domain => "qq.com",
  :authentication => :login,
  :user_name => "your email",
  :password => "your password"
}
```

最后在`initializers/devise.rb`中更改`config.mailer_sender`为刚才配置好的邮箱：

```
config.mailer_sender = 'your email'
```

重新启动服务器后，登录界面将会多出重新发送验证邮件的选项，注册也会验证邮件了。








