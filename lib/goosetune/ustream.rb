class Goosetune::Ustream
  def initialize
    # playyouhouse user_id: 6018269
    # playyouhouse channel_id: 4509151
    url = 'https://api.ustream.tv/channels/4509151/videos.json?limit=100'
    uri = URI.parse(URI.escape(url))
    json = Net::HTTP.get(uri)
    @response = JSON.parse(json)
  end
end
