require 'net/http'
require 'json'

def login(username, password)
  params = {
    'client_id' => 'bYGKuGVw91e0NMfPGp44euvGt59s',
    'client_secret' => 'HP3RmkgAmEGro0gn1x9ioawQE8WMfvLXDz3ZqxpK',
    'grant_type' => 'password',
    'username' => username,
    'password' => password
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
  keywords,
  page: 1,
  mode: 'exact_tag',
  period: 'all',
  per_page: 30,
  order: 'desc',
  sort: 'date' ,
  image_sizes: ['px_128x128'],
  profile_image_sizes: ['px_50x50'],
  includ_stats: true,
  include_sanity_level: true
)
  puts "page = #{page}"
  puts "mode = #{mode}"
  puts "order = #{order}"
  puts "sort = #{sort}" 
end

search('www', :page => 5, :mode => 'text')

#token = login('931996776@qq.com', 'xel0429')

#puts "token : #{token}"
