#Active Record

Active Record是Rails MVC模式中的M（Model）层，主要负责需要存储到数据库的数据映射。

>在Active Record模式中，对象中既有持久存储的数据，也有针对数据的操作。Active Record 模式把数据存取逻辑作为对象的一部分，处理对象的用户知道如何把数据写入数据库，以及从数据库中读出数据。

###声明Model

如果想要声明一个Model，只需要使它继承Active Record就可以了：

```
class User < ActiveRecord::Base
end
```

当然也需要具体操作的数据库表：

```
create table users (
	id int auto_increment,
	username varchar(20) not null,
	password varchar(20) not null,
	age smallint,
	primary key(id)
);
```

便可以对Model进行操作了：

```
user = User.new
user.username = '1@qq.com'
user.password = 'jbgsn'
user.age = 18
user.save
puts user.id
```

在大部分情况下，Rails推荐Model与数据库表遵守一种命名规定，包括表名约定和字段名约定：

- 表名约定指Model类名为首字母大写驼峰命名的单数形式，表名为全小写下划线分隔的复数形式，例如上面的`User`和`users`。

- 字段名则比较复杂，首先Rails会默认使用`id`作为表的主键，`关联表名（单数）_id`作为表的外键。除此之外还有一些可选字段，包括：`created_at`（记录创建时间）、`updated_at`（记录更新时间）、`lock_version`（乐观锁字段）、`type`（单表继承字段）、`关联表名_type`（多态关联的类型）、`关联表名（复数）_count`（关联表个数）等字段，如果表中有对应的字段，Rails则会在对应的数据库操作中更新这些字段的值。

当然也可以通过以下方式显式指定表名和主键，只不过这样容易造成一些混乱，所以不推荐：

```
class User < ActiveRecord::Base
  self.table_name = "user_"
  self.primary_key = "user_id"
end
```

###增删改查

**查询对象**

`first`、`last`和`all`分别的可以得到表中的第一个、最后一个和全部对象：

```
first_user = User.first
last_user = User.last
users = User.all
```

`find`方法可以通过主键查找对象，`find_by_*`方法可以通过指定的属性查找对象：

```
user = User.find(1)
users = User.find([1, 2, 3])
user = User.find_by_username('1@qq.com')
```

`find_by_sql`方法可以通过sql语句查询对象：

```
user = User.find_by_sql('select * from users where id = 1')
```

`find_by_sql`虽然比较灵活，但是写起来麻烦而且难维护，所以一般还是推荐通过`where`方法进行查询，该方法有两种写法：通过Hash指定字段名和值（但是多个字段只能是以`and`连接），或是通过字符串条件语句并赋值：

```
users = User.where(username: '1@qq.com')
users = User.where('username = ? or id = ?', '1@qq.com', 1)
```

还有一个方法名叫`where.not`，用法正好和`where`相反。

`order`方法可以指定查询数据的排序条件：

```
users = User.order('name ASC')
```

`offset`和`limit`方法可以指定查询结果的起始位置和个数：

```
users = User.offset(3).limit(2)
```

`select`方法可以指定查询的字段：

```
users = User.select('id')
```

`group`和`having`可以用于分组查询，并对分组的结果进行条件筛选：

```
users = User.select('age, count(age)').group('age').having('count(age) > ?', 100)
```

如果查询结果很大，可以使用`find_each`方法分批次处理：

```
User.find_each do |user|
  puts user.username
end
```


**创建对象**

通过`new`、`save`和`create`方法可以创建一个Model，`new`方法会声明一个对象，之后通过调用对象的`save`方法才会保存到数据库，而`create`则是`new`和`save`的结合，会直接将新创建的对象保存到数据库，例如：

```
user = User.new(username: '1@qq.com', password: 'jbgsn')
user.save

user = User.create(username: '1@qq.com', password: 'jbgsn')
```

`save`和`create`方法还有另一种版本：`save!`和`create!`，它们之间的区别是，在资料验证失败时，无感叹号的方法会返回`boolean`类型，而有感叹号的版本会抛出异常。

**更新对象**

对于已经存在与数据库的对象，修改属性后直接使用`save`方法即可更新数据，或者也可以使用`update`方法，它同样拥有带感叹号的版本，区别也和`save`一样：

```
user = User.first
user.update(password: 'newpassword')
```

通过`update_all`方法可以批量更新数据，一般用在`where`后：

```
User.where(password: 'default_password').update_all(password: 'new_password')
```

**删除对象**

通过`destroy`方法删除对象：

```
user = User.first
user.dertroy
```
通过`destroy_all`方法可以批量删除，一般用在`where`后：

```
User.where(password: 'default_password').destroy_all()
```

###Scopes

对Model增加Scopes可以声明常用的查询语句，使代码复用性变得更好，例如：

```
class User < ActiveRecord::Base
  scope :kids, -> { where('age < ?', 18) }
end

kids = User.kids
```
