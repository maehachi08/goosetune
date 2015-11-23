class Goosetune::Youtube::Video < Goosetune::Youtube
  def term(year)
    "&publishedAfter=#{year}-01-01t00:00:00z" + "&publishedBefore=#{year}-12-31t23:59:59z"
  end

  def get_youtubes_by_year(year='2015')
    get_youtubes(:term => term(year))
  end

  def get_view_counts_by_year(year='2015')
    get_view_counts(:term => term(year))
  end

  def get_view_counts(term: '')
    counts = struct_view_counts(get_request(search_params(term)))
    channel = Goosetune::Youtube::Channel.new
    next_token = channel.next_page_token

    while next_token
      options = ''
      options = term + "&pageToken=#{next_token}"
      counts.merge!(struct_view_counts(get_request(search_params(options))))
      next_token = channel.next_page_token(options)
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

  def get_youtubes(term: '')
    videos = struct_youtubes(get_request(search_params(term)))
    channel = Goosetune::Youtube::Channel.new
    next_token = channel.next_page_token(term)

    while next_token
      options = ''
      options = term + "&pageToken=#{next_token}"
      videos.merge!(struct_youtubes(get_request(search_params(options))))
      next_token = channel.next_page_token(options)
    end

    videos
  end

  def struct_youtubes(channel_response)
    videos = {}

    channel_response['items'].each do |item|
      video_snippet = {}
      video_snippet[:id]          = video_id = item['id']['videoId']
      video_snippet[:view_counts] = view_count(video_id)
      video_snippet[:url]         = "https://www.youtube.com/watch?v=#{video_id}"
      video_snippet[:published]   = item['snippet']['publishedAt']
      video_snippet[:title]       = item['snippet']['title']
      video_snippet[:thumbnail]   = item['snippet']['thumbnails']['medium']['url']
      video_snippet[:original_artist],
      video_snippet[:original_title] = split( item['snippet']['title'] )
      videos[video_id] = video_snippet
    end
    videos
  end

end
