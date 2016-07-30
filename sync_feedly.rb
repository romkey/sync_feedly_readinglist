require 'feedlr'

class SyncFeedly
  attr_accessor :client

  def initialize
    @client = Feedlr::Client.new oauth_access_token: ENV.fetch('FEEDLY_ACCESS_TOKEN')
  end

  def get_entries
    entries = @client.stream_entries_contents("user/#{ENV.fetch('FEEDLY_USER_ID')}/tag/global.saved", count: 1000)
    
    entries['items'].each do |item|
      if item['alternate']
        add_item item['alternate'].first['href'], item['title']
      else
        puts "\n\n>>>> MISSING ALTERNATE\n\n"
        pp item
      end
    end

    if entries['continuation'] && false
      get_entries entries['continuation']
    end
  end

  def add_item(url, title)
    puts "add_item('#{url}', '#{title}')"

    system "osascript -e 'tell app \"Safari\" to add reading list item \"#{url}\"'"

#    system "./bin/add_to_readinglist #{url}"
  end
end
