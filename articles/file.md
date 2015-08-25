#文件操作

`File.open`和`File.new`方法通过路径打开一个本地文件，并且可以指定以下模式：

 - `r`：只读模式
 - `r+`：读写模式
 - `w`：只写模式，如果文件已存在会覆盖掉原有内容
 - `w+`：在`w`的基础上可读
 - `a`：只写模式，如果文件已存在会在末尾追加内容
 - `a+`：在`a`的基础上可读

```
filename = ARGV.first

#默认为只读模式
file = File.open(filename)

#手动指定只读模式
file = File.open(filename, 'r')

#读写模式（会覆盖原有文件）
file = File.open(filename, "w+")

#追加模式
file = File.open(filename, "a+")
```

`File.exist?`方法可以在打开文件前先判断文件是否存在：

```
#判断文件是否存在
file = File.open(filename) if File.exist? filename
```

获得文件对象后，使用`read`方法可以读取文件内容，或是使用`readline`方法仅读取一行。

```
#读取文件所有内容
puts file.read()

#读取一行内容
puts file.readline()
```

使用`write`方法可以向文件中写入内容，如果文件为读写模式会先清空原有的数据，追加模式则会在原有数据后面继续写入。

```
#将用户输入内容写到文件里
line = STDIN.gets

file.write(line)
```

文件操作完毕后，需要调用`close`方法关闭该文件。

```
file.close()
```

其他方法：

一些操作文件路径的方法：

 - `basename`：从路径中获得文件名
 - `dirname`：从路径中获得文件所在文件夹
 - `expand_path`：将路径转换为绝对路径
 - `extname`：获得文件的后缀名
 - `identical?`：判断两个路径所指向的文件是否相同
 - `join`：将多个字符串通过路径分隔符拼接起来
 - `link`：将一个新路径指向另一个已有路径
 - `split`：将文件夹路径和文件名分割

示例：

```
File.basename('/home/ruby/test.rb') #=> 'test.rb'

File.dirname('/home/ruby/test.rb') #=> 'test.rb'

File.expand_path('test.rb', '/home/ruby') #=> '/home/ruby/test.rb'

File.extname('test.rb') #=> '.rb'

File.join('home', 'ruby', 'test.rb') #=> 'home/ruby/text.rb'

File.link('/home/ruby/test.rb', 'test')

File.identical?('/home/ruby/test.rb', 'test') #=> true

File.split('/home/ruby/test.rb') #=> ['/home/ruby', 'test.rb']
```

操作文件属性的方法：

 - `exist?`：判断文件是否存在
 - `file?`：判断是否为文件
 - `readable?`：判断文件是否可读
 - `writable?`：判断文件是否可写 
 - `executable?`：判断文件是否可执行
 - `size`：获得文件大小
 - `atime`：获得文件最后一次读取/执行的时间
 - `ctime`：获得文件最后一次创建/更改所有者/更改权限的时间
 - `mtime`：获得文件最后一次修改的时间
 - `ftype`：获得文件的类型
 
示例：

```
File.exist?('/home/ruby/test.rb') #=> true

File.file?('/home/ruby/test.rb') #=> true

File.readable?('/home/ruby/test.rb') #=> true

File.writable?('/home/ruby/test.rb') #=> true

File.executable?('/home/ruby/test.rb') #=> true

File.size('/home/ruby/test.rb') #=> 201

File.atime('/home/ruby/test.rb') #=> 2015-08-25 19:04:02 +0900

File.mtime('/home/ruby/test.rb') #=> 2015-08-25 19:04:02 +0900

File.ctime('/home/ruby/test.rb') #=> 2015-08-25 19:04:02 +0900

File.ftype('/home/ruby/test.rb') #=> 'file'
```

操作文件夹的方法：

 - `home`：获得根路径
 - `mkdir`：创建文件夹
 - `rmdir`：删除文件夹
 - `entries`：获得文件夹下所有文件
 - `foreach`：遍历文件夹下所有文件
 
示例：

```
Dir.home #=> /Users/xieenlong

Dir.mkdir('/home/ruby')

Dir.rmdir('/home/ruby')

Dir.entries('/home/ruby') #=> ['.', '..', 'test.rb']

Dir.foreach('/home/ruby') {|filename| puts filename }
```