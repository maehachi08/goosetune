class Goosetune::Youtube
  Dotenv.load
  API_KEY = ENV["API_KEY"]
  CHANNEL_ID = 'UCFDL0NuxUBAvvu1PnIwW2ww' #playyouhousejp
  GOOGLE_API_URL = 'https://www.googleapis.com/'
  BASE_URL = GOOGLE_API_URL + 'youtube/v3/'

  def initialize
  end

  # GET https://www.googleapis.com/youtube/v3/search
  #   - https://developers.google.com/youtube/v3/docs/search/list?hl=ja
  def seaech_params(options='')
    method = 'search'
    part = '?part=snippet'
    max_result = '&maxResults=50'
    sort_param = '&order=date'
    query_type = '&type=video'
    channel = '&channelId=' + CHANNEL_ID
    api_key = '&key=' + API_KEY
    method + part + channel + api_key + max_result + sort_param + query_type + options
  end

  # GET https://www.googleapis.com/youtube/v3/videos
  #   - https://developers.google.com/youtube/v3/docs/videos/list
  def videos_params(video_id)
    method = 'videos'
    part = '?part=contentDetails,statistics'
    id = '&id=' + video_id
    api_key = '&key=' + API_KEY
    method + part + id + api_key
  end

  def get_request(options='')
    uri = URI.parse(URI.escape(BASE_URL + options))
    json = Net::HTTP.get(uri)
    JSON.parse(json)
  end
end  
