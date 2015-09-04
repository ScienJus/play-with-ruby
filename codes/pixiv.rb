require 'net/http'
require 'uri'
require 'json'
require "fileutils"

#Thanks: https://github.com/upbit/pixivpy/

class Pixiv
  
  def initialize(username, password)
    @username = username
    @password = password
    login
  end  
  
  def login
    params = {
      client_id: 'bYGKuGVw91e0NMfPGp44euvGt59s',
      client_secret: 'HP3RmkgAmEGro0gn1x9ioawQE8WMfvLXDz3ZqxpK',
      grant_type: 'password',
      username: @username,
      password: @password
    }

    uri = URI('https://oauth.secure.pixiv.net/auth/token')

    Net::HTTP.start(uri.host, uri.port, 
    :use_ssl => uri.scheme == 'https') do |http|
      req = Net::HTTP::Post.new(uri)
      req.set_form_data(params)
      res = http.request req
      if res.is_a?(Net::HTTPSuccess)
        json = JSON.parse res.body
        @token = json['response']['access_token']
      end
    end
  end

  def search(
    key_words,
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
        'Authorization' => "Bearer #{@token}",
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
        'Authorization' => "Bearer #{@token}",
        'User-Agent:' => 'PixivIOSApp/5.6.0'
      })
            
      res = http.request req
    
      if res.is_a?(Net::HTTPSuccess)
        json = JSON.parse res.body
        json['response'][0]['works']
      end
    end
  end

  def by_author(
    author_id,
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
        'Authorization' => "Bearer #{@token}",
        'User-Agent:' => 'PixivIOSApp/5.6.0'
      })
          
      res = http.request req
  
      puts res.body
    end
  end
  
  def illust_details(id) 
    uri = URI("https://public-api.secure.pixiv.net/v1/works/#{id}.json")
    
    uri.query = URI.encode_www_form(
      profile_image_sizes: 'px_170x170,px_50x50',
      image_sizes: 'px_128x128,small,medium,large,px_480mw',
      include_stats: true
    )
    
    Net::HTTP.start(uri.host, uri.port,
    :use_ssl => uri.scheme == 'https') do |http|
      req = Net::HTTP::Get.new(uri)
    
      req.initialize_http_header({
        'Authorization' => "Bearer #{@token}",
        'User-Agent:' => 'PixivIOSApp/5.6.0'
      })
          
      res = http.request req
  
      if res.is_a?(Net::HTTPSuccess)
        json = JSON.parse res.body
        json['response'][0]
      end
    end
  end
  
  def self.download(url, dir) 
    uri = URI(url)
    
    FileUtils.makedirs(dir) unless Dir.exist?(dir)
    
    path = File.join(dir, File.basename(url))
    
    Net::HTTP.start(uri.host, uri.port,
    :use_ssl => uri.scheme == 'https') do |http|
      req = Net::HTTP::Get.new(uri)
    
      req.initialize_http_header({
        'Referer' => 'http://www.pixiv.net'
      })
          
      res = http.request req
    
      if res.is_a?(Net::HTTPSuccess)
        File.open(path, 'w') do |file|
          file.write(res.body)
          file.close
        end
      end
    end
  
  end
  
end


pixiv = Pixiv.new('931996776@qq.com', 'xel0429')

# pixiv.search('kancolle', :page => 1)
# pixiv.by_author(273812)

works = pixiv.ranking

works.each do |rank|
  puts "rank => #{rank['rank']}"
  id = rank['work']['id']
  illust = pixiv.illust_details id
  author = illust['user']
  puts "id => #{illust['id']}"
  puts "title => #{illust['title']}"
  puts "author_id => #{author['id']}"
  puts "nickname => #{author['name']}"
  puts "image => #{illust['image_urls']['large']}"
  puts ""
  Pixiv.download(illust['image_urls']['large'], File.join(Dir.home, 'pixiv', 'ranking'))
  puts '————————————————————————————————————————————————'
end



