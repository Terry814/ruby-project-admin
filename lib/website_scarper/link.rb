module WebsiteScarper
  class Link
    attr_reader :link
    attr_accessor :title

    def initialize(title, link)
      @title = title
      @link = URI(link).scheme ? link : "http://#{link}"
    end

    def social?
      %w( instagram twitter facebook ).reduce(false) { |i, s| i || host.include?(s) }
    end

    def host
      URI(@link).host
    end

    def extension
      File.extname(URI(@link).path || '')
    end

    def hash
      @link.hash
    end

    def eql?(other)
      other.respond_to?(:hash) && hash == other.hash
    end

    def to_s
      "#{@title} - #{@link}"
    end
  end
end