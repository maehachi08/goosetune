class Goosetune::Youtube
  Dotenv.load

  API_KEY = ENV["API_KEY"]
  CHANNEL_ID = 'UCFDL0NuxUBAvvu1PnIwW2ww' #playyouhousejp
  GOOGLE_API_URL = 'https://www.googleapis.com/'
  BASE_URL = GOOGLE_API_URL + 'youtube/v3/'

  attr_reader :youtube_channnel_id

  def initialize(youtube_channnel_id='')
    @youtube_channnel_id = youtube_channnel_id
  end

  def is_playgoose_channnel?
    if @youtube_channnel_id == 'UCx66obAJ42B0XwHIm_iupkw'
      return true
    else
      return false
    end
  end

  def is_playyouhouse_channel?
    if @youtube_channnel_id == 'CFDL0NuxUBAvvu1PnIwW2ww'
      return true
    else
      return false
    end
  end

  # GET https://www.googleapis.com/youtube/v3/search
  #   - https://developers.google.com/youtube/v3/docs/search/list?hl=ja
  def search_params(options='')
    _parameters = []
    _parameters << 'search'
    _parameters << '?part=snippet'
    _parameters << '&channelId=' + @youtube_channnel_id
    _parameters << '&key=' + API_KEY
    _parameters << '&maxResults=50'
    _parameters << '&order=date'
    _parameters << '&type=video'
    _parameters << options
    _parameters.join('')
  end

  # GET https://www.googleapis.com/youtube/v3/videos
  #   - https://developers.google.com/youtube/v3/docs/videos/list
  def videos_params(video_id)
    _parameters = []
    _parameters << 'videos'
    _parameters << '?part=contentDetails,statistics'
    _parameters << '&id=' + video_id
    _parameters << '&key=' + API_KEY
    _parameters.join('')
  end

  def get_request(options='')
    uri = URI.parse(URI.escape(BASE_URL + options))
    json = Net::HTTP.get(uri)
    JSON.parse(json)
  end
end
