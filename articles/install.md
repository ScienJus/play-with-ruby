##环境搭建

###安装curl

```
sudo apt-get update

sudo apt-get install curl
```

###安装rvm

```
curl -L http://get.rvm.io | bash -s stable --ruby
```

如果出现了：

```
GPG signature verification failed for '/home/ubuntu/.rvm/archives/rvm-1.26.11.tgz' - 'https://github.com/rvm/rvm/releases/download/1.26.11/1.26.11.tar.gz.asc'!
```

则：

```
curl -sSL https://rvm.io/mpapis.asc | gpg --import 
```

后重新执行

安装成功后设置环境变量

```
source source ~/.rvm/scripts/rvm
```

查看rvm版本

```
rvm -v
```

###安装ruby
切换到淘宝镜像

```
sed -i 's!cache.ruby-lang.org/pub/ruby!ruby.taobao.org/mirrors/ruby!' $rvm_path/config/db
```

安装

```
rvm requirements && rvm pkg install readline
```

查看可用ruby版本

```
rvm list known
```

安装ruby版本

```
rvm install 2.2.1
```

切换ruby版本

```
rvm use 2.2.1 --default
```

查看当前ruby版本

```
ruby -v
```
