class Goosetune::Ustream::Video < Goosetune::Ustream
  def get_ustreams
    ustreams = {}

    @response['results'].each do |entry|
      video_snippet = {}
      id = entry['id']
      video_snippet[:id]          = entry['id'].chomp
      video_snippet[:title]       = entry['title'].chomp
      video_snippet[:url]         = entry['url'].chomp
      video_snippet[:thumbnail]   = entry['imageUrl']['medium'].chomp
      video_snippet[:published]   = entry['createdAt'].chomp
      video_snippet[:view_counts] = entry['totalViews'].chomp
      ustreams[id] = video_snippet
    end

    ustreams
  end

  def get_view_counts
    view_counts = {}

    @response['results'].each do |entry|
      view_counts[:"#{entry['id']}"] = entry['totalViews'].chomp
    end

    view_counts
  end
end
