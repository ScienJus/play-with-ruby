#Ruby中的可选参数和命名参数

因为在此之前我最常用的编程语言是Java，所以这里首先以Java作为对比，如果你对此并不感兴趣，可以直接跳到下半部分。

###Java中的可选参数和命名参数

>编写一个方法时，可以为参数添加默认值，当调用者使用该方法时，既可以为这些参数指定具体的值，也可以使用默认值，这种方式称为可选参数。

在我写Java时，曾经对编写拥有可选参数的方法很苦恼，因为Java并不直接支持在方法中指定可选参数。

例如我需要编写一个搜索的Api，它的参数有：

 - 关键词（keyWords）：没有默认值
 - 页数（page）：默认为第1页
 - 分页量（paging size）：默认为20条
 - 搜索方式（mode）：默认以标签（tag）搜索


其实还有很多参数，但是为了避免这个例子太亢长，就到这里为止。

如果使用Java编写这个Api，我只能先定义这样一个方法：

```
//其实mode应该是枚举类型的，但是举例嘛，不要太认真。
void search(String keyWords, Integer page, Integer pagingSize, String mode);
```

定义完这个方法后，还需要在方法内部给每个可选参数赋予默认值，当然由于这对调用者不可见，所以只能在注释中告诉调用者哪些参数拥有默认值，分别是多少，以便他们调用，就像这样：

```
/**
 * 搜索的Api
 * @param keyWords   关键词，必选
 * @param page       页数，默认为1
 * @param pagingSize 每页的数量，默认为20
 * @param page       搜索的方式，默认为标签搜索（tag）
 * @return
 */
void search(String keyWords, Integer page, Integer pagingSize, String mode) {
    if (keyWords == null || "".equals(keyWords)) return;
    page = page == null ? 1 : page;
    pagingSize = pagingSize == null ? 20 : page;
    mode = mode == null ? "tag" : mode;
    ....
}
```

这样一个带有默认值的搜索Api便完成了，但是如果调用者只想指定关键词，其他参数都使用默认值的话，调用代码就会写成这样：

```
search("kancolle", null, null, null);
```

传了好多个`null`啊，而且并不能直观的看出每个`null`的意义，所以严格来说这并不是一个好做法。如果我们只想使这个方法在调用时不用传一大堆`null`，可以用重载稍微改进一下，比如：

```
/**
 * 搜索的Api（只能以标签搜索前20条）
 * @param keyWords   关键词，必选
 * @return
 */
void search(String keyWords) {
    search(keyWords, null, null, null);
}
```

这样虽然调用起来方便了，但是却需要为每种可能指定参数的情况都编写重载方法，例如这个Api就有单参数1种、双参数3种，三参数3种，4参数1种的情况，那就要写整整8个方法，而其中7个只是简单的调用了下其他的方法，这样就很没有必要了。

也许你觉得这样挺好的，只要能方便调用者就行，所以你决定把这8个重载方法都写出来，但是写到一半你会发现，由于`page`和`pagingSize`的类型都是`Integer`，所以会出现两个`search(String, Interger)`方法，编译器就会报错，你将无法接着写下去，除非将这两个方法中的一个改名。

不过最可怕的还不是在这里，而是当你好不容易将这8个方法都写好后，突然有一天一个人这样使用了这个Api：

```
search("kancolle", null);
```

即使没有必要这么写，但是的确会出现这种情况，而且这时候编译器又会报错，因为它分不清调用的是`search(String, Interger)`还是`search(String, String)`，除非将代码修改成这样：

```
search("kancolle", (Integer)null);
```

当我知道这个地方是一个`null`并且将`null`强转成`Integer`是没有意义的，却还是必须要强转，不然能怎么办？接着改名？

以上只是对Java的一些小小吐槽，当然如果你真的遇到了这样的问题，请去参考设计模式中的`Builder模式`，不要真的傻傻的去让调用者传一大堆`null`或是重载一大堆方法。

###Ruby中的可选参数和命名参数

接下来便要进入正题了，实际这种尴尬的情况基本上也只会在Java中出现，因为无论是C#、Python或是Ruby都提供了可选参数这个概念，比如这个Api如果用Ruby写就会是这样：

```
def search(key_words, page = 1, paging_size = 20, mode = 'tag')
  ...
end
```

没错，只需要这一个方法就可以了，比如你可以这样调用：

```
search "kancolle"
```

或是这样：

```
search("kancolle", 2)
```

但是当调用拥有可选参数的方法时，必须严格按照方法定义参数的顺序进行传值，并且一旦自某个参数使用默认值后，该参数之后的所有参数也只能使用默认值。比如假设你只想要改变搜索方式为文本搜索（text），这样进行调用：

```
#进入方法内部后，被赋值为text的却是page。
search("kancolle", "text")
```

所以仅仅是可选参数是无法完全解决这个问题的，还需要引入命名参数这个概念：

>在调用方法时，可以显式的通过参数名对方法中的参数进行传值，称为命名参数。

如果是Python的话，只需要在传参时直接指定参数名即可，比如；

```
search("kancolle", page = 1, mode = "text")
```

但是在Ruby中，则需要对方法进行一些改造，因为Ruby是用Hash实现命名参数的，这里有两种方式，分别介绍一下：

第一种是直接在方法中定义一个Hash参数，用于接收所有命名参数：

```
#params = {} 也可以换成 **params，区别接下来会提到
def search(key_words, params = {})
  default_params = {
    page: 1,
    paging_size: 20,
    mode: 'text'
  }

  #这里通过合并Hash的方式完成默认值的赋值
  params = default_params.merge(params)
  ...
end
```

第二种方法是直接在参数中声明和设置默认值：

```
def search(key_words, page: 1, paging_size: 20, mode: 'tag')
  ...
end
```

一般来说还是第二种更好一些，看着一目了然，也不需要做合并操作。

当然无论使用哪种方式，调用时都是相同的：

```
search('kancolle', page: 2, mode: 'text')
```

有的时候你也许会遇到需要同时使用这两种方式的情况，这时候需要注意的是：虽然`params = {}`和`**params`都可以接收到所有的命名参数，但是只有`**params`可以与第二种方式同时使用，使用`params = {}`的话则会报错，例如：ss

```
#可以运行
def search(key_words: 'all', **params)
  ...
end

#会报错
def search(key_words: 'all', params = {})
  ...
end
```



