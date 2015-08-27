require 'net/http'
require 'json'

def login(username, password)
  params = {
    client_id: 'bYGKuGVw91e0NMfPGp44euvGt59s',
    client_secret: 'HP3RmkgAmEGro0gn1x9ioawQE8WMfvLXDz3ZqxpK',
    grant_type: 'password',
    username: username,
    password: password
  }

  uri = URI('https://oauth.secure.pixiv.net/auth/token')

  Net::HTTP.start(uri.host, uri.port, 
  :use_ssl => uri.scheme == 'https') do |http|
    req = Net::HTTP::Post.new(uri)
    req.set_form_data(params)
    res = http.request req
    if res.is_a?(Net::HTTPSuccess)
      json = JSON.parse res.body
      json['response']['access_token']
    end
  end
end

def search(
  key_words,
  token,
  page: 1,
  mode: 'exact_tag',
  period: 'all',
  per_page: 30,
  order: 'desc',
  sort: 'date' ,
  image_sizes: ['px_128x128'],
  profile_image_sizes: ['px_50x50'],
  include_stats: true,
  include_sanity_level: true
)
  uri = URI('https://public-api.secure.pixiv.net/v1/search/works.json');
 
  uri.query = URI.encode_www_form(
    q: key_words,
    page: page,
    mode: mode,
    period: period,
    per_page: per_page,
    order: order,
    sort: sort,
    image_sizes: image_sizes,
    profile_image_sizes: profile_image_sizes,
    include_stats: include_stats,
    include_sanity_level: include_sanity_level
  )

  Net::HTTP.start(uri.host, uri.port,
  :use_ssl => uri.scheme == 'https') do |http|
    req = Net::HTTP::Get.new(uri)
      
    # 方法1 通过initialize_http_header设置header  
    req.initialize_http_header({
      'Authorization' => "Bearer #{token}",
      'User-Agent' => 'PixivIOSApp/5.6.0'
    })
    
    # 方法2 通过self:[]设置header
    # req['Authorization'] = "Bearer #{token}"
    # req['User-Agent'] = 'PixivIOSApp/5.6.0'
        
    res = http.request req
    
    # 方法3 直接提交uri和header
    # res = http.get(uri, {
    #   'Authorization' => "Bearer #{token}",
    #   'Referer' => 'http://spapi.pixiv.net/',
    #   'User-Agent' => 'PixivIOSApp/5.6.0'
    # })

    puts res.body
  end
end

def ranking(
  token,
  mode: 'daily',
  page: 1,
  per_page: 50,
  date: nil,
  image_sizes: ['px_128x128'],
  profile_image_sizes: ['px_50x50'],
  include_stats: true,
  include_sanity_level: true
)
  uri = URI('https://public-api.secure.pixiv.net/v1/ranking/all')
  
  uri.query = URI.encode_www_form(
    mode: mode,
    page: page,
    per_page: per_page,
    date: date,
    image_sizes: image_sizes,
    profile_image_sizes: profile_image_sizes,
    include_stats: include_stats,
    include_sanity_level: include_sanity_level
  )
  
  Net::HTTP.start(uri.host, uri.port,
  :use_ssl => uri.scheme == 'https') do |http|
    req = Net::HTTP::Get.new(uri)
      
    req.initialize_http_header({
      'Authorization' => "Bearer #{token}",
      'User-Agent:' => 'PixivIOSApp/5.6.0'
    })
            
    res = http.request req
    
    puts res.body
  end
end

def by_author(
  author_id,
  token,
  page: 1,
  per_page: 30,
  publicity: 'public',
  image_sizes: ['px_128x128'],
  profile_image_sizes: ['px_50x50'],
  include_stats: true,
  include_sanity_level: true
)
  uri = URI("https://public-api.secure.pixiv.net/v1/users/#{author_id}/works.json")

  uri.query = URI.encode_www_form(
    page: page,
    per_page: per_page,
    publicity: publicity,
    image_sizes: image_sizes,
    profile_image_sizes: profile_image_sizes,
    include_stats: include_stats,
    include_sanity_level: include_sanity_level
  )

  Net::HTTP.start(uri.host, uri.port,
  :use_ssl => uri.scheme == 'https') do |http|
    req = Net::HTTP::Get.new(uri)
    
    req.initialize_http_header({
      'Authorization' => "Bearer #{token}",
      'User-Agent:' => 'PixivIOSApp/5.6.0'
    })
          
    res = http.request req
  
    puts res.body
  end
end

token = login('931996776@qq.com', 'xel0429')

puts "token : #{token}"

# search('kancolle', token, :page => 1)
by_author(273812, token)


