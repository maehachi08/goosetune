class Goosetune::Youtube::Video < Goosetune::Youtube
  def get_view_counts
    counts = struct_view_counts(get_request(seaech_params))
    channel = Goosetune::Youtube::Channel.new
    next_token = channel.next_page_token

    while next_token
      counts.merge!(struct_view_counts(get_request(seaech_params("&pageToken=#{next_token}"))))
      next_token = channel.next_page_token("&pageToken=#{next_token}")
    end

    counts
  end

  def struct_view_counts(channel_response)
    videos = {}

    channel_response['items'].each do |item|
      video_id = item['id']['videoId']
      videos[:"#{video_id}"] = view_count(video_id)
    end

    videos
  end

  def view_count(video_id)
    video_result = get_request(videos_params(video_id))
    unless video_result['items'].nil?
      return video_result['items'].first['statistics']['viewCount'].chomp
    end
  end

  def get_youtubes
    videos = struct_youtubes(get_request(seaech_params))
    channel = Goosetune::Youtube::Channel.new
    next_token = channel.next_page_token

    while next_token
      videos.merge!(struct_youtubes(get_request(seaech_params("&pageToken=#{next_token}"))))
      next_token = channel.next_page_token("&pageToken=#{next_token}")
    end

    videos
  end

  def struct_youtubes(channel_response)
    videos = {}

    channel_response['items'].each do |item|
      video_id = ''
      item['id'].each do |id|
        video_id = id.last.chomp if id.first == 'videoId'
      end

      video_snippet = {}
      video_snippet[:id] = video_id
      video_snippet[:view_counts] = view_count(video_id)
      video_snippet[:url] = "https://www.youtube.com/watch?v=#{video_id}"

      item['snippet'].each do |snippet|
	case snippet.first
        when 'publishedAt'
          video_snippet[:published] = snippet.last.chomp
        when 'title'
          video_snippet[:title] = snippet.last.chomp
          video_snippet[:original_artist],video_snippet[:original_title] = split(snippet.last.chomp)
        when 'thumbnails'
          video_snippet[:thumbnail] = snippet.last['medium']['url'].chomp
        end
      end

      videos[video_id] = video_snippet
    end
    videos
  end

  def split(title)
    case title
    when /天野春子（小泉今日子）Cover/
      original_artist = '天野春子（小泉今日子）'
      original_title = '潮騒のメモリー'
    when /学園天国 フィンガー５/
      original_artist = 'フィンガー５'
      original_title  = '学園天国'
    when /18歳／（Original）/
      original_artist = 'Goosehouse'
      original_title = title.gsub(/／[\W|\w].*/,'')
    when /Sing／PlayYou House（Original）/
      original_artist = 'Play You. House'
      original_title = 'Sing'
    when /PYHouse/
      original_artist = 'Goosehouse'
      original_title = title
    when /絵本/
      original_artist = 'Goosehouse'
      original_title = title
     when /ココロオドル\/nobodyknows+/
      original_artist = 'nobodyknows+'
      original_title = title.gsub(/\/nobodyk[\W\w].*/,'')
    when /汽車のうた|ハイウェイ賛歌/
      original_artist = '関取花＆齋藤ジョニー'
      original_title = title.gsub(/\W\w.*/,'')
    when /カントリー・ロード/
      original_artist = '本名陽子'
      original_title  = 'カントリー・ロード'
    when /Cover|cover|Coverr/
      original_artist = title.gsub(/\s\WCover\W|\WCover\W|\s\Wcover\W|\Wcover\W|\WCoverr\W/,'').gsub(/[\W\w].*／/,'')
      original_title = title.gsub(/\s\WCover\W|\WCover\W|\s\Wcover\W|\Wcover\W|\WCoverr\W/,'').gsub(/／[\W\w].*/,'')
    when /^Play You|^playyou/
      original_artist = 'Play You. House'
      original_title = title
    when /Play You|PlayYou/
      original_artist = 'Play You. House'
      original_title = title.gsub(/Play You.*/,'')
    when /\WGoose.*/
      original_artist = 'Goosehouse'
      original_title = title.gsub(/\WGoose[\W|\w].*|\WGoose[\W|\w].*/,'')
    when /／Original|／（Original）/
     original_artist = 'Goosehouse'
     original_title = title.gsub(/／Original|／（Original） /,'')
    when /18歳／（Original）/
     original_artist = 'Goosehouse'
     original_title = title.gsub(/／[\W|\w].*/,'')
    when /／[\W|\w].*（Original）/
      original_artist = title.gsub(/[\W|\w].*／/,'').delete('（Original）')
      original_title = title.gsub(/／[\W|\w].*/,'')
    # ここからは判定順序を考慮
    when /竹渕 慶/
      original_artist = '竹渕 慶'
      original_title = title.gsub(/／[\W|\w].*/,'')
    when /／|\//
      original_artist = title.gsub(/[\W|\w].*／|[\W|\w].*\//,'')
      original_title = title.gsub(/／[\W|\w].*|\/[\W|\w].*/,'')
    when /Goose/
        original_artist = 'Goosehouse'
        original_title = title
    when /こんどのHOUSEは、ストリーミングでは観られない/
        original_artist = 'Play You. House'
        original_title = title
    else
      original_artist = title
      original_title = title
    end
    return original_artist.chomp,original_title.chomp
  end
end
