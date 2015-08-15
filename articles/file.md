##文件操作

`File.open`方法可以根据文件路径打开一个本地文件，并得到一个文件对象，该方法有3种模式，默认为`r`（只读模式），可以通过`w`设置为读写模式或通过`a`设置为追加模式：

```ruby
filename = ARGV.first

#只读模式
file = File.open(filename)

#读写模式
file = File.open(filename, "w")

#追加模式
file = File.open(filename, "a")
```

`File.exists?`可以在打开文件前先判断文件是否存在：

```ruby
#判断文件是否存在
isExists = File.exists filename
```

获得文件对象后，使用`read`方法可以读取文件内容，或是使用`readline`方法仅读取一行。

```ruby
#打印文件所有内容
puts file.read()

#打印一行内容
puts file.readline()
```

使用`write`方法可以向文件中写入内容，如果文件为读写模式会先清空原有的数据，追加模式则会在原有数据后面继续写入。

```ruby
#将用户输入内容写到文件里
line = STDIN.gets

file.write(line)
```

文件操作完毕后，需要调用`close`方法关闭该文件。

```ruby
file.close()
```


