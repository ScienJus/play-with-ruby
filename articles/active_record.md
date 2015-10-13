#Active Record

Active Record是Rails MVC模式中的M（Model）层，主要负责需要存储到数据库的数据映射。

>在Active Record模式中，对象中既有持久存储的数据，也有针对数据的操作。Active Record 模式把数据存取逻辑作为对象的一部分，处理对象的用户知道如何把数据写入数据库，以及从数据库中读出数据。

###生成Model

如果想要操作一个Model对象，只需要使它继承Active Record就可以了：

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
	primary key(id)
);
```

便可以对Model进行操作了：

```
user = User.new
user.username = 1@qq.com
user.password = jbgsn
user.save
puts user.id
```

在大部分情况下，Rails推荐Model与数据库表遵守一种命名规定，包括表名约定和字段名约定：

- 表名约定指Model类名为首字母大写驼峰命名的单数形式，表名为全小写下划线分割的复数形式，例如上面的`User`和`users`。

- 字段名则比较复杂，首先Rails会默认使用`id`作为表的主键，`关联表名（单数）_id`作为表的外键。除此之外还有一些可选字段，包括：`created_at`（记录创建时间）、`updated_at`（记录更新时间）、`lock_version`（乐观锁字段）、`type`（单表继承字段）、`关联表名_type`（多态关联的类型）、`关联表名（复数）_count`（关联表个数）等字段，如果表中有对应的字段，Rails则会在对应的数据库操作中更新这些字段的值。

当然也可以通过以下方式显式指定表名和主键，只不过这样容易造成一些混乱，所以不推荐：

```
class User < ActiveRecord::Base
  self.table_name = "user_"
  self.primary_key = "user_id"
end
```

Rails还提供了一种更简单的方式创建Model，只需要在命令行