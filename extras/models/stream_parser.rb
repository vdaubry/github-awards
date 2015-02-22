require 'yajl'

class Models::StreamParser
  def initialize(stream)
    @stream = stream
  end
  
  def parse
    i = 0
    Yajl::Parser.parse(@stream) do |event|
      yield event
      Rails.logger.info "Parsed #{i} lines" if i%1000==0
      i+=1
    end
  end
end