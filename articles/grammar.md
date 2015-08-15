注：本章的所有内容均默认读者有过使用其他编程语言的经验，所以不会详细介绍语句的用途，而是只展示其在Ruby中的写法。

###命令行输出

使用`print`和`puts`方法可以将内容输出到命令行，他们的区别是`puts`会在结尾自动换行，`print`则不会：

```ruby
puts "Hello Ruby!"
print "Hello Ruby!"
```

###注释

单行注释以`#`开头：

```ruby
#输出Hello Ruby!
puts "Hello Ruby!"
```

多行注释以`=begin`开头，以`=end`结尾：

```ruby
=begin
  输出Hello Ruby!
=end
puts "Hello Ruby!"
```

在这里顺便说一下：在Ruby中缩进一般使用2个空格而不是Tab（4个空格）。

###变量

Ruby是弱类型语言，可以直接在语句中使用`name = value`的格式声明一个变量并赋值：

```ruby
color = "red"
```

Ruby中有两种方法可以格式化输出变量，分别是以`#{name}`格式嵌入在字符串中或是在字符串后追加`%`：

```ruby
name = "Rachel"
age = 14
#可以这样输出
puts "My name is #{name}. I'm #{age} years old" 
#或是这样
puts "My name is %s. I'm %d years old" % [name, age]
#如果只需要一个变量，则不使用数组
puts "My name is %s" % name
```

###接收输入内容

使用`gets`可以获取输入内容，但是内容会包含尾部的换行符，可以使用`chomp`方法去掉这个换行符：

```ruby
puts "How old are you"
age = gets.chomp()
puts "you are %d years old!" % age
```

###接收运行参数

使用`ARGV`常量可以拿到运行的填写的参数，使用`$0`可以获得当前运行的ruby脚本的文件名：

```ruby
first, second, third = ARGV

puts "The script is called: #{$0}"
puts "Your first variable is: #{first}"
puts "Your second variable is: #{second}"
puts "Your third variable is: #{third}"
```

注意：当同时使用`gets`和`ARGV`时，需要将`gets`替换为`STDIN.gets`。

###条件语句（if）

Ruby中的if语句由`if`、`elsif`和`else`组成：

```ruby
age = 30

if age < 12
  puts "you are a child"
elsif age < 30
  puts "you are a teenager"
elsif age < 60
  puts "you are a adult"
else
  puts "you are a elder"
end
```

除此之外还有一些很符合语义的写法：

```ruby
age = 10

if age < 12 then puts "you are a child"

puts "you are a child" if age < 12
```

在这种语义中，还可以使用`unless`作为和`if`相反的写法。
```ruby
age = 10

puts "you are a child" unless age > 12
```

###条件语句（switch）

Ruby中的switch语句由`case`、`when`和`else`组成：

```ruby
sex = male

case sex
when "male" then puts "you are a boy"
when "fumale" then puts "you are a girl"
else puts "???"
end
```

###循环语句（for）

使用`for`关键词可以快速定义简单循环事件或迭代数组：

```ruby
pages = [1, 2, 3, 4, 5]

#快速遍历数组

for page in pages
  puts "now is page %d" % page
end

#或者

pages.each do |page|
  puts "now is page %d" % page
end

#简单循环事件

for index in (0..5)
  puts "now is page %d" % page
end

#或者

(0..5).each do |page|
  puts "now is page %d" % page
end
```

顺便提一下，如果只需要循环指定的次数，可以直接简写为：

```ruby
3.times { puts "因为很重要所以要说三遍！！！" }
```
###循环语句（while）

使用`while`关键词可以定义较为复杂的循环事件：

```ruby
while i < 10 do
  i += 1
end
```

它同样有作为相反语义的关键词`until`：

```ruby
until i >= 10 do
  i += 1
end
```

也同样可以简写为：

```ruby
i += 1 while i < 10

i += 1 until i >= 10
```

###循环语句（loop）

使用`loop`可以定义一个无限循环的语句块：

```ruby
loop do
  puts "刷屏!!!"
end
```

由于loop本身并没有循环结束的条件，所以特定关键词结束循环（之后会提到）。

###循环控制

使用以下关键词可以在循环中控制语句走向：
 - `break`：跳出循环
 - `next`：跳到下一次循环（类似于continue）
 - `redo`：无条件重新执行本次循环
 - `retry`：重新开始整个循环



###方法

在Ruby中使用`def`关键词声明一个方法：

```ruby
def say_hello()
  puts "Hello!"
end
```

其中既可以显式的定义参数的数量和每个参数的名称，也可以直接通过`*args`获得所有参数：

```ruby
#下面两个方法实际是一样的
def puts_two_args(arg1, arg2)
  puts "arg1: %s, arg2: %s" % [arg1, arg2]
end

def puts_two_args( *args ) 
  arg1, arg2 = args
  puts "arg1: %s, arg2: %s" % [arg1, arg2]
end
```

也可以给每个参数都定义一个默认值：

```ruby
def puts_two_args(arg1 = "nothing", arg2 = "nothing")
  puts "arg1: %s, arg2: %s" % [arg1, arg2]
end
```

Ruby的方法默认会返回最后一条语句的值，也可以通过`return`显式返回或返回多个值：

```ruby
#会返回num1 + num2
def add(num1, num2)
  num1 + num2
end

#返回多个值
def get(x, y)
  return x, y
end
```

###类

通过`class`关键词可以声明一个类，它的格式大概为：

```ruby
class Person
  attr_reader :name
  
  @@count = 0 

  def initialize(name)
    @name = name
    @@count += 1
  end

  def say_name
    puts "My name is %s" % @name
  end

  def self.how_many_person
    puts "There are %d persons" % @@count
  end
end
```

以上代码声明了`Person`类，其中：
 - `initialize`为构造方法
 - `name`为实例变量，以`@`修饰
 - `count`为类变量，以`@@`修饰
 - `say_name`为实例方法
 - `how_many_person`为类方法

实例变量可以通过`attr_reader`、`attr_writer`和`attr_accessor`分别设定该变量只可读、只可写、可读写。

声明类方法有三种方式，分别为`self.methodName`、`className.methodName`和`className::methodName`，个人比较喜欢第一种。

之后便可以通过`className.new`调用构造方法创建一个该类的新实例。

###继承

在声明类的时候通过`<`可以继承一个已有类：

```ruby
class Student < person
  attr_reader :school
  
  def initialize(name, school)
    super(name)
    @school = school
  end

  def say_school
    puts "My school is %s" % @school
  end
end
```

###模块

Ruby中没有interface，但是提供了module和mixin机制。可以将通过`module`定义的模块引用进类以使用该模块的方法：

```ruby
module Learner
  def study
    puts "I'm Studying now"
  end
end

class Student 
  include Learner
end
```

因为模块不可以直接实例化，所以可以将常量定义在模块内直接调用：

```ruby
module Math
  PI = 3.14
end

puts Math::PI
```

