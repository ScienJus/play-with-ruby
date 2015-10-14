#Rails数据库迁移

迁移是Rails管理数据库的方式，相比于直接使用SQL语句创建数据库，它的好处有：

- 使用Ruby DSL编写，与数据库种类无关
- 保存了每个版本的修订记录，可以回退版本
- 多人开发时可以保证数据库结构统一

###创建迁移文件

使用`rails g migration`命令可以新增一个档案：

```
rails g migration create_user
```

该命令会在`db/migration`目录下创建一个名为`时间戳_create_user.rb`的迁移文件，它的格式大概为：

```
class CreateUser < ActiveRecord::Migration

  def change
  end

end
```

这个类中的`change`方法，就是需要在迁移时执行的具体操作。

###迁移文件语法

`create_table`和`remove_table`可以创建表和删除表，例如：

```
class CreateUser < ActiveRecord::Migration

  def change
    create_table :users do |t|
      t.string :username
      t.string :password
      t.integer :age
      t.timestamps
    end
    
    drop_table users
  end

end
```

`add_column`和`remove_column`可以在表中新增字段和删除字段，例如：

```
class ChangeColumn < ActiveRecord::Migration

  def change
    add_column :users, :nickname, :string
    
    remove_column :users, :age, :integer
  end

end
```

字段的类型有：

 - `string`：字符串
 - `text`：文本
 - `integer`：整数
 - `float`：浮点数
 - `decimal`：十进制小数
 - `datetime`：日期时间
 - `timestamp`：时间戳
 - `time`：时间
 - `date`：日期
 - `binary`：二进制
 - `boolean`：布尔值
 - `references`：外键

可选的附加参数：

 - `null`：是否允许为空
 - `default`：默认值
 - `limit`：设定string、text、integer、binary的最大长度
 - `index`：添加索引
 - `index: { unique: true }`：添加唯一索引
 - `foreign_key`：外键

`add_index`和`remove_index`可以新增和移除索引，例如：

```
class CreateIndexToUser < ActiveRecord::Migration

  def change
    add_index :users, :username
    
    remove_index :users, :username 
  end

end
```

索引可以通过`unique: true`指定不允许重复。

###使用命令行快速创建迁移文件

在执行创建迁移文件命令时，如果命名遵守指定的规范，Rails会直接生成迁移的代码，而不需要全部手动编写。

迁移名如果为`CreateXXX`，并且后面跟着字段名和字段类型，迁移就会自动添加创建表代码，例如：

```
rails g migration CreateUser username:string password:string age:integer
```

生成的迁移文件内容为：

```
class CreateUser < ActiveRecord::Migration

  def change
    create_table :users do |t|
      t.string :username
      t.string :password
      t.integer :age
      t.timestamps
    end
  end

end
```

不过该命令可以完全被`rails g model`命令替代，该命令会直接生成model文件和迁移文件，例如上面的命令也可以写成：

```
rails g model User username:string password:string age:integer 
```

如果只准备新增字段或是删除字段，可以直接在创建迁移文件时以`AddXXXToYYY`和`RemoveXXXFromYYY`命名，后面紧接着字段名和字段类型，生成的迁移文件将会自动生成`add_column`和`remove_column`语句，例如：

```
rails g migration AddNicknameToUsers nickname:string
```

生成的迁移文件内容为：

```
class AddNicknameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :nickname, :string
  end
end
```

###使用Seed文件初始化数据

在`db/seeds.rb`可以添加代码用于初始化数据库，之后通过`rake db:seed`即可运行。一般用在第一次迁移数据库后。

###Rake命令

编写完迁移文件后，通过`rake db:migrate`命令即可执行迁移，Rake还有一些其他的命令：
 
 - `rake db:create`：在当前环境下创建数据库
 - `rake db:create:all`：建立所有环境的数据库
 - `rake db:drop`：删除当前环境的数据库
 - `rake db:drop:all`：删除所有环境的数据库
 - `rake db:migrate`：执行迁移操作
 - `rake db:rollback STEP=n`：回退n个数据库操作
 - `rake db:migrate:up VERSION=20080906120000`：执行特定版本的迁移
 - `rake db:migrate:down VERSION=20080906120000`：回退到特定版本的迁移
 - `rake db:seed`：载入初始化数据
 - `rake db:version`：显示当前的迁移版本
 - `rake db:migrate:status`：显示迁移状态



