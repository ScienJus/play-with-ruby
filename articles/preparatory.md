##准备工作

###添加用户

创建一个新用户

```
useradd -m -s /bin/bash ScienJus
```

将用户加入sudo组

```
adduser ScienJus sudo
```

设置用户密码

```
passwd ScienJus
```

切换到该用户

```
su ScienJus
```

###安装git

由于本项目发布在github上，所以需要安装git用于发布。

安装git

```
sudo apt-get install git
```

###绑定github

生成一个ssh key

```
ssh-keygen -t rsa -b 4096 -C "xie_enlong@foxmail.com"
```

将`~/.ssh/id_rsa.pub`的内容复制到github上并创建一个ssh key

完成后校验是否绑定

```
ssh -v git@github.com
``

如果出现

```
Hi ScienJus! You've successfully authenticated, but GitHub does not provide shell access.
```

则绑定成功

###创建项目

进入需要创建项目的文件夹，使用`git init`创建项目，使用`git add .`添加文件，`git -m commit  -m 'comment'`提交文件。
```
mkdir play-with-ruby
cd play-with-ruby
git init
vim README.md
git add README.md
git -m commit  -m 'first commit'
```

同步到github
```
git remote add origin git@github.com:ScienJus/play-with-ruby.git
git push origin master
```

