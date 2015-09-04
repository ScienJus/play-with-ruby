这个库使我第一次了解到Ruby“一种功能，多种写法”的语言风格。

如果想要使用HTTP相关的操作，首先需要引用`net/http`库：

```
require 'net/http'
```

不过在介绍这个库之前，首先介绍一下`URI`这个model，这个model提供了一些对uri的简单操作，想要使用这个model同样也需要引入它：

```
require 'uri'
```

接下来便可以使用它简化uri处理：

```
#创建一个uri对象
uri = URI('http://www.baidu.com/posts?page=1#time=1305299742')

uri.scheme #=> 'http'

uri.host #=> 'www.baidu.com'

uri.path #=> '/posts'

uri.query #=> 'page=1'

uri.fragment #=> 'time=1305299742'

uri.to_s #=> 'http://www.baidu.com/posts?page=1#time=1305299742'
```

这里主要介绍一下`encode_www_form`这个方法，这个方法可以将Hash转换成query形式的字符串，这样就不用自己去拼query了，例如：

```
uri = URI('http://www.baidu.com/posts')

uri.query = URI.encode_www_form(
	page: 1
)

uri.to_s #=> 'http://www.baidu.com/posts?page=1'
```

接下来便可以使用`net/http`发送请求：

发送get请求有许多种方式，常见的有使用`get`和`get_response`方法直接发送uri，或是使用`Net::HTTP::Get`通过uri创建一个request对象：

```
uri = URI('http://www.baidu.com')

#方法1
page = Net::HTTP.get uri

#方法2
res = Net::HTTP.get_response uri

res.body if res.is_a?(Net::HTTPSuccess)

Net::HTTP.start(uri.host, uri.port) do |http|
  #方法3
  req = Net::HTTP::Get.new uri

  res = http.request req
  
  res.body if res.is_a?(Net::HTTPSuccess)
end
```

发送post请求也是用类似的`post_form`方法和创建`Net::HTTP::Post`对象：

```
uri = URI('http://www.baidu.com')

#方法1
res = Net::post_form(uri, page: 1)

res.body if res.is_a?(Net::HTTPSuccess)

Net::HTTP.start(uri.host, uri.port) do |http|
  #方法2
  req = Net::HTTP::Post.new uri
  req.set_form_data(page: 1)

  res = http.request req
  
  res.body if res.is_a?(Net::HTTPSuccess)
end
```

request可以通过`self:[]`直接设置header，也可以通过`initialize_http_header`方法或是在`get`请求时直接带上header：

```
uri = URI('http://www.baidu.com')

Net::HTTP.start(uri.host, uri.port) do |http|
  req = Net::HTTP::Get.new(uri)
      
  #方法1
  req.initialize_http_header({
      'User-Agent' => 'PixivIOSApp/5.6.0'
  })
    
  #方法2
  req['User-Agent'] = 'PixivIOSApp/5.6.0'
        
  res = http.request req
    
  #方法3
  res = http.get(uri, 
    'User-Agent' => 'PixivIOSApp/5.6.0'
  )

end
```

当然同样也可以使用`self:[]`，`get_fields`和`to_hash`等方法得到response中的header，需要注意的是第一个方法得到的是String类型，而后两个方法得到的是Array类型：

```
uri = URI('http://www.baidu.com')

res = Net::HTTP.get_response uri

#方法1
res['set-cookie']

#方法2
res.get_fields['set-cookie']

#方法3
res.to_hash['set-cookie']
```

除了header，response中还有很多属性，比如返回的状态码，返回的信息等：

```
#返回码
res.code #=> '200'

#返回信息
res.message #=> 'OK'

#返回内容
res.body
```

在创建Http服务时，通过`use_ssl`参数可以设置是否使用HTTPS连接：

```
uri = URI('https://www.baidu.com')

Net::HTTP.start(uri.host, uri.port,
  use_ssl: uri.scheme == 'https') do |http|
  req = Net::HTTP::Get.new uri
  
  res = http.request req
end
```

还可以指定代理地址：

```
uri = URI('https://www.baidu.com')

proxy_addr = 'your.proxy.host'
proxy_port = 8080

Net::HTTP.start(uri.host, uri.port, proxy_addr, proxy_port) do |http|
  req = Net::HTTP::Get.new uri
  
  res = http.request req
end
```

我使用这个库写了一个由Ruby封装的Pixiv Api，可以在[这里][1]看到。

[1]:../codes/pixiv.rb