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
    raise get_request(search_params(term)).to_yaml

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
      video_snippet[:original_title] = split( id: video_snippet[:id], title: video_snippet[:title] )
      videos[video_id] = video_snippet
    end
    videos
  end

  def split(video_snippet={})
    yaml = YAML.load_file('config/data.yaml')

    # YAMLファイルに該当エントリーがある場合は先に返す
    if yaml.keys.include?( video_snippet[:id] )
      original_title  = yaml[video_snippet[:id]]['original_title']
      original_artist = yaml[video_snippet[:id]]['original_artist']
      return original_artist,original_title
    end

    # カバー動画のみ抽出
    #   - カバー動画以外のタイトルは規則性がないため
    #
    # 栄光の架け橋／ゆず（Coverr）対応
    #   - H-Wut0BVQ_U
    if video_snippet[:title].match( /coverr/i )
      original_title  = video_snippet[:title].gsub(/\／.*/,'')
                                             .gsub(/\Wcoverr\W/i,'')
                                             .gsub(/^\s|\s$/,'')
      original_artist = video_snippet[:title].gsub(/.*\/|.*\／/,'')
                                             .gsub(/\Wcoverr\W/i,'')
					     .gsub(/^\s|\s$/,'')
    elsif video_snippet[:title].match( /cover/i )
      if video_snippet[:title].match( /\／/ )
        original_title  = video_snippet[:title].gsub(/\／.*/,'')
                                               .gsub(/\Wcover\W/i,'')
                                               .gsub(/^\s|\s$/,'')
      else
        original_title  = video_snippet[:title].gsub(/\/.*|\／.*/,'')
                                               .gsub(/\Wcover\W/i,'')
                                               .gsub(/^\s|\s$/,'')
      end
      original_artist = video_snippet[:title].gsub(/.*\/|.*\／/,'')
                                             .gsub(/\Wcover\W/i,'')
					     .gsub(/^\s|\s$/,'')

    # ====== Play You. Houseなタイトル ======
    # Play You. House
    # Play You.House
    # playyou house
    # PlayYou House
    # playyouhouse
    # /Play\sYou\.\sHouse|Play\sYou\.House|playyou\shouse|playyouhouse/i
    elsif video_snippet[:title].match( /Play\sYou\.\sHouse|Play\sYou\.House|playyou\shouse|playyouhouse/i )

      # "Sing／PlayYou House（Original）" みたいな文字列への対応
      if video_snippet[:title].match( /\／/ )
        original_title  = video_snippet[:title].gsub(/\/.*|\／.*/,'')
      else
        original_title  = video_snippet[:title]
      end

      original_artist = 'Play You. House'
    # cover|Coverという文字はないがタイトルとアーティスト名の間にスラッシュがあるもの
    elsif video_snippet[:title].match( /\/|\／/ )
      if video_snippet[:title].match( /original/i )
        # Goosehouseオリジナルと見なす
        #   - この分岐を通るPlay You. HouseエントリーはYAMLへ記載済み
        #     - oSL2nCSD17g,6e3KeO4ICKI
        original_title  = video_snippet[:title].gsub(/\/.*|\／.*/,'')
        original_artist = 'Goosehouse'
      elsif video_snippet[:title].match( /goose/i )
        original_title  = video_snippet[:title].gsub(/\/.*|\／.*/,'')
        original_artist = 'Goosehouse'
      else
        # タイトルにスラッシュを含むエントリー
        #   - この分岐を通る日時を表すスラッシュを含むエントリーはYAMLへ記載済み
        #      - 6p-B0AgbXtA
        original_title  = video_snippet[:title].gsub(/\/.*|\／.*/,'')
        original_artist = video_snippet[:title].gsub(/.*\/|.*\／/,'')
                                               .gsub(/^\s|\s$/,'')
      end
    elsif video_snippet[:title].match( /goose/i )
      original_title  = video_snippet[:title].gsub(/\Wcover\W/i,'').gsub(/^\s|\s$/,'')
      original_artist = 'Goosehouse'
    else
      original_artist = original_title  = video_snippet[:title].gsub(/\Wcover\W/i,'').gsub(/^\s|\s$/,'')
    end

    return original_artist,original_title
  end

end
