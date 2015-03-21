require 'mechanize'

module F1Results
  class Agent < ::Mechanize
    def get_event(season, country, type)
      event = Event.new(season: season, country: country, type: type)
      path = "content/fom-website/en/championship/results/#{season}-race-results/#{season}-#{event.country_slug}-results/#{event.type_slug}.html"

      begin
        get(::File.join(F1Results::BASEURL, path))
      rescue Mechanize::ResponseCodeError, Net::HTTPNotFound
        raise 'No results'
      end

      event.name = page.parser.xpath('//a[contains(@class, "level-0")]').text
      table = page.parser.xpath('//tbody')

      return event.parse_results_table(table)
    end
  end
end
