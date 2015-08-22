require 'mechanize'

module F1Results
  class Agent < ::Mechanize
    def get_page_from_default_url(event)
      default_urls(event).each do |url|
        page = get_page_from_url(url)
        break if !page.nil?
      end
      return page
    end

    def get_page_from_url(url)
      begin
        get(url)
        return page
      rescue Mechanize::ResponseCodeError, Net::HTTPNotFound
        return nil
      end
    end

    private

      def default_urls(event)
        [
          "content/fom-website/en/championship/results/#{event.year}-race-results/#{event.year}-#{event.country_slug}-results/#{event.type_slug}.html",
          "content/fom-website/en/championship/results/#{event.year}-race-results/#{event.year}-#{event.country_name.gsub(' ', '-')}-results/#{event.type_slug}.html"
        ].map { |path| (::File.join(F1Results::BASEURL, path)) }
      end
  end
end
