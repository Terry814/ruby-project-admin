module WebsiteScarper
  class Scarper
    def initialize(website)
      @website = URI(website).scheme ? website : "http://#{website}"
      @links, @pdf_links, @social_links = Hash.new(0), Hash.new(0), Hash.new(0)
      @blacklist, @parsed = Set.new, Set.new

      # Make sure home page link makes it to result
      @links[Link.new("Home page", @website)] = 1000
    end

    def scarpe(timeout=30, pages_to_parse=9999)
      begin
        Timeout::timeout(timeout) do
          1.upto(pages_to_parse) do
            next_link = links_sorted.find { |link| should_scrape_link?(link) }
            break unless next_link

            # get links from page and merge
            begin
              new_links = scrape_link(next_link)
              process_new_links(filter_new_links(new_links))
            rescue Exception => e
              Rails.logger.debug e
              Rails.logger.debug "error opening #{next_link.link}, blacklisting it"
              @blacklist << next_link
              links.delete(next_link)
            end
          end
        end
      rescue Timeout::Error => e
        Rails.logger.debug 'timeout'
      end
    end

    def links(limit=10, min_occurence=2)
      filtered_links = @links.select { |_, f| f >= min_occurence }
      links_sorted(filtered_links).take(limit)
    end

    def parsed_pages_count
      @parsed.size
    end

    def pdf_links(limit=2)
      links_sorted(@pdf_links).take(limit)
    end

    def social_links(limit=5)
      links_sorted(@social_links).take(limit)
    end

    private

    def should_scrape_link? link
      !@parsed.member?(link) && link.host == root_host
    end

    def scrape_link link
      puts "scarping #{link.link}"
      @parsed << link

      page = Nokogiri::HTML(open(link.link))

      # set title to link if any
      title = page.xpath('//head//title').text and link.title = title

      page.xpath("//a")
        .select { |a| a['href'].kind_of?(String) && !a['href'].start_with?('#') }
        .map { |a| Link.new(a.text.strip, make_url(a['href'])) }
    end

    def make_url href
      URI.join(@website, URI.encode(href)).to_s.sub(/(\/)+$/, '')
    end

    def filter_new_links new_links
      new_links.delete_if do |l|
        uri = URI(l.link)

        @blacklist.member?(l) || 
          l.extension == '.xml' ||
          !uri.scheme.start_with?('http') ||
          uri.path.split('/').count > 3
      end
    end

    def process_new_links new_links
      new_links.each do |link|
        @pdf_links[link] += 1 and next if link.extension == '.pdf'
        @social_links[link] += 1 and next if link.social?
        @links[link] += 1
      end
    end

    def links_sorted links_hash=@links
      links_hash.sort_by { |_, f| -f }.map(&:first)
    end

    def root_host
      URI(@website).host
    end
  end
end