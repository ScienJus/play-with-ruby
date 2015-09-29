#搭建Rails环境

###安装Rails

这里使用gem安装rails，所以首先需要将gem源替换为国内的淘宝源：

```
#查看当前的gem源，默认情况只有https://rubygems.org/
gem sources -l

#删除https://rubygems.org/
gem sources —remove https://rubygems.org/

#添加http://ruby.taobao.org/
gem sources -a http://ruby.taobao.org/
```

使用gem安装rails：

```
gem install rails
```

查看rails是否安装成功：

```
rails --version
```

###安装Passenger和Nginx

使用gem安装passenger：

```
gem install passenger
```

由于nginx必须在编译时导入模块，所以这里选择直接用passenger编译好nginx：

```
passenger-install-nginx-module
```

接下来passenger会询问是自动下载并编译nginx还是编译用户指定nginx源码，选择第1种方式的话passenger会自动下载nginx源码并编译，但是我在这里莫名其妙的无法通过passenger下载nginx源码（开vpn也不行），只好手动下载后选择第2种方式，这里可以直接输入命令：

```
passenger-install-nginx-module --auto --prefix=/usr/local/nginx --nginx-source-dir=/path/to/nginx/source/nginx-1.8.0
```

安装成功后可以直接启动nginx查看是否能正常运行：

```
/usr/local/nginx/sbin/nginx
```

打开浏览器输入localhost可以看到nginx的欢迎页面则说明安装成功了。

配置一个引用：

```
sudo ln -s /usr/local/nginx/sbin/nginx /usr/sbin/
```

启动和关闭方式：

```
#启动
sudo nginx

#关闭
sudo nginx --stop

#重新启动
sudo nginx -s reload
```