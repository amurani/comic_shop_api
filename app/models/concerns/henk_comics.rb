module HenkComics
    require 'open-uri'

    HENK_COMIC_comics_URL = "http://www.comics.nl/shop/comics/page/"

    def initialize
    end

    def self.list_commics
        comics = []
        comic_page_count = 1
        # while comic.length !== comic_page_count 
            comics_page_url = "http://www.comics.nl/shop/comics/page/#{comic_page_count}"
            comics_page_html = make_http_request comics_page_url
            comics = parse_comics_page comics_page_html
        # end
        comics
    end
    
    def self.make_http_request(http_url)
        http_url = URI.parse(http_url)
        http_response = open http_url
        http_response.read rescue ""
    end

    def self.parse_comics_page(comics_page_html)
        comics = []
        dom = Nokogiri::HTML comics_page_html
        dom.css('ul.products li.product').each do |li_tag|
            comic = parse_comic li_tag
            comics.push comic
        end
        
        comics
    end

    def self.parse_comic(li_tag)
        comic = { }
        
        link_to_comic = li_tag.css('a').first["href"]
        image_for_comic = li_tag.css('a img').first["src"]
        comic_name = li_tag.css('a h2').first.text

        comic[:link_to_comic] = link_to_comic
        comic[:image_for_comic] = "http://#{image_for_comic}"
        comic[:name] = comic_name
        comic[:comic_summary] = get_comic_details_by_url link_to_comic

        comic
    end

    def self.get_comic_details_by_url(comic_url)
        comic_page_html = make_http_request comic_url
        dom = Nokogiri::HTML comic_page_html
        comic_summary = dom.css('.summary p').last.text

        comic_summary
    end

end
