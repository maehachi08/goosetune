class Goosetune::Ustream
  def initialize
    url = 'http://api.ustream.tv/json/user/6018269/listAllVideos/?limit=100'
    uri = URI.parse(URI.escape(url))
    json = Net::HTTP.get(uri)
    @response = JSON.parse(json)
  end
end
