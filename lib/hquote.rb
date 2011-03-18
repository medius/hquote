# Hquote: A simple Ruby on Rails plugin to get historical stock quotes from Yahoo
# Author: Puru Choudhary (puruchoudhary@gmail.com)
# Repository: git@github.com:medius/hquote.git

# Usage: 
# quote_req = {:symbol=>"aapl",:start_month=>"0",:start_date=>"1",:start_year=>"2011",
# :end_month=>"2",:end_date=>"14",:end_year=>"2011",:period=>"d"}
# Hquote.get_ohlcv(quote_req)
#
# => [{:date=>"2011-03-11", :open=>"345.33", :high=>"352.32", :low=>"345.00", 
# :close=>"351.99", :volume=>"16813300", :adj_close=>"351.99"}, {:date=>"2011-03-10", 
# :open=>"349.12", :high=>"349.77", :low=>"344.90", :close=>"346.67", :volume=>"18126400", 
# :adj_close=>"346.67"}, .... ]

# Credit: This work is derived from John Yerhot's rQuote plugin
# https://github.com/johnyerhot/rquote

class Hquote
  require 'cgi'
  require 'net/http'

  @@service_uri = "http://ichart.finance.yahoo.com/table.csv"
  
  # We pass a quote_req hash that contains all the arguments for our request
  def self.get_ohlcv(quote_req)
    output = Array.new
    i = 0
    response = self.send_request(quote_req)
    String.new(response).split("\n").each do |line|
      a = line.chomp.split(",")
      unless i == 0
        output << { :date => a[0], 
                  :open => a[1],
                  :high => a[2],
                  :low  => a[3],
                  :close => a[4],
                  :volume => a[5],
                  :adj_close => a[6]
                }
      end          
      i += 1
    end
    return output
  end
  
  private
  def self.send_request(quote_req)
    completed_path = @@service_uri + self.construct_args(quote_req)
    uri = URI.parse(completed_path)
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      http.get completed_path
    end
    print "Response:\n" + response.body
    return response.body
  end
  
  def self.construct_args(quote_req)
    path =        "?s=" + quote_req[:symbol]
    path = path + "&a=" + quote_req[:start_month]
    path = path + "&b=" + quote_req[:start_date]
    path = path + "&c=" + quote_req[:start_year]
    path = path + "&d=" + quote_req[:end_month]
    path = path + "&e=" + quote_req[:end_date]
    path = path + "&f=" + quote_req[:end_year]
    path = path + "&g=" + quote_req[:period]
  end
  
end