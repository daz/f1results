require 'mechanize'

module F1Results
  class Agent < ::Mechanize
    def get_event(season, country, type)
      event = Event.new(:season => season, :type => type)

      begin
        get(::File.join(F1Results::BASEURL, "results/season/#{season}/"))
      rescue Mechanize::ResponseCodeError, 404
        raise "No results for season: #{season}"
      end

      season_country_link = case
      when country.is_a?(String)
        event.country = country
        page.link_with(:text => event.country)
      when country.is_a?(Integer)

        # Get the link to the country on the nth row

        next_page = page.parser.at_xpath("//tr[not(position()=1)][#{country}]/td[1]/a")
        event.country = next_page.text
        page.link_with(:node => next_page)
      when country == :latest

        # Get the link to the country in the last row where results are present

        next_page = page.parser.at_xpath('(//tr/td[3][node()])[last()]/../td[1]/a')
        event.country = next_page.text
        page.link_with(:node => next_page)
      end
      raise "Grand Prix not found: #{season} #{country}" if season_country_link.nil?

      click(season_country_link)
      event.grand_prix = page.parser.at_xpath('//h2').text

      results_link = if event.qualifying?
        page.link_with(:text => 'QUALIFYING') || page.link_with(:text => 'SUNDAY QUALIFYING')
      elsif event.race?
        page.link_with(:text => 'RACE', :dom_class => 'L3Selected')
      end

      raise "No #{event.type} results for: #{season} #{country}" if results_link.nil?
      click(results_link)
      table = page.parser.xpath('//table[contains(@class, "raceResults")]')

      event.parse_results_table(table)
    end
  end
end
