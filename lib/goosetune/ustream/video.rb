class Goosetune::Ustream::Video < Goosetune::Ustream
  def get_ustreams
    ustreams = {}

    @response['videos'].each do |entry|
      # id: '90113779'
      # title: 'Goose house UST LIVE #63-2'
      # description: Recorded on 2016/07/30
      # url: http://www.ustream.tv/recorded/90113779
      # length: '5185.7578125'
      # created_at: 1469878224
      # file_size: '1229374451'
      # views: 32533
      # protect: public
      # thumbnail:
      #   default: https://ustvstaticcdn2-a.akamaihd.net/i/video/picture/0/1/90/90113/90113779/1_4509151_90113779,192x108,b,1:3.jpg
      # media_urls:
      #   flv: http://tcdn.ustream.tv/video/90113779?preset_id=1&e=1470772712&h=fa23151f306f32660b7f0a55f0020889&source=api
      # links:
      #   channel:
      #     href: https://api.ustream.tv/channels/4509151.json
      #     id: '4509151'
      # tinyurl: http://ustre.am/:666I3
      # schedule: 
      # owner:
      #   id: '6018269'
      #   username: playyouhouse
      #   picture: https://ustvstaticcdn1-a.akamaihd.net/i/user/picture/6/0/1/8/6018269/6018269_logo_______1347285093,48x48,r:1.jpg
      # 
      video_snippet = {}
      id = entry['id']
      video_snippet[:id]          = entry['id'].chomp
      video_snippet[:title]       = entry['title'].chomp
      video_snippet[:url]         = entry['url'].chomp
      video_snippet[:thumbnail]   = entry['thumbnail']['default'].chomp
      # created_at is unix timestamp
      video_snippet[:published]   = Time.at( entry['created_at'] ).to_s.chomp
      video_snippet[:view_counts] = entry['views']
      ustreams[id] = video_snippet
    end

    ustreams
  end

  def get_view_counts
    view_counts = {}

    @response['videos'].each do |entry|
      view_counts[:"#{entry['id']}"] = entry['views']
    end

    view_counts
  end
end
