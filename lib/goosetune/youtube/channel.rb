class Goosetune::Youtube::Channel < Goosetune::Youtube
  def next_page_token(options='')
    str = get_request(seaech_params(options))['nextPageToken']
    return str.chomp unless str.nil? # Always,last page don't exist nextPageToken.
  end
end
