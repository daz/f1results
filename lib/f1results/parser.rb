module F1Results
  class Parser
    def initialize(page)
      @page = page
      @event = Event.new
    end

    def parse
      @event.name = event_name
      @event.type = event_type
      @event.grand_prix = event_grand_prix
      @event.circuit = event_circuit
      @event.results = event_results
      # TODO: date
      return @event
    end

    private

      def event_name
        return @page.parser.at_xpath('//h1').text.gsub(/[[:space:]]+/, ' ').strip
      end

      def event_type
        if m = @event.name.match(/(?:.+) - (.+)/)
          result = m[1]
            .gsub(/(?<=RACE )RESULT/i, '')
            .gsub(/OVERALL(?= QUALIFYING)/i, '')
            .gsub(/(?<=PRACTICE)( )(?=[1-3])/i, '')
            .sub(/(?<=QUALIFYING)\s*\d+\z/i, '') # strip numbers for Qualifying
            .strip
            .downcase
          result.to_sym
        end
      end

      def event_grand_prix
        node = @page.parser.at_xpath('(//dialog)[3]//a[.//title[text()="Active"]]')
        node.xpath('.//svg').remove

        return node.text.strip
      end

      def event_circuit
        node = @page.parser.at_xpath('//h1/../../../../../div/following-sibling::div[1]//p[2]')
        return node.text
      end

      def event_results
        results = []
        tbody = @page.parser.at_xpath('//tbody')

        # Remove driver abbreviation from driver cell
        tbody.xpath('.//span[@class="md:hidden"]').each(&:remove)

        # Turn HTML tbody into an array of arrays
        data = tbody.xpath('.//tr').map do |row|
          row.xpath('./td|./th').map do |cell|
            cell = cell.text.gsub(/[[:space:]]+/, ' ').strip
            cell.empty? ? nil : cell
          end
        end

        header = @page.parser.xpath('//thead//th').map do |cell|
          cell.text.to_s
            .gsub(/\./, '') # Pos. -> Pos
            .gsub(/[[:space:]]+/, '')
            .gsub(/\/.*/, '') # Time/Retired -> Time
            .downcase
            .to_sym
        end

        # Set result class type
        result_class = case
        when @event.practice?
          PracticeResult
        when @event.qualifying?
          QualifyingResult
        else
          RaceResult
        end

        # Make each table row a Result
        data.each_with_index do |row, i|
          hash = Hash[header.zip(row)]
          hash[:position] = i + 1

          result = result_class.new(hash)
          results << result
        end

        return results
      end
  end
end
