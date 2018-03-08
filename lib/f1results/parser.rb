module F1Results
  class Parser
    def initialize(page)
      @page = page
      @event = Event.new
    end

    def parse
      @event.name = event_name
      @event.type = event_type
      @event.country = event_country
      @event.circuit = event_circuit
      @event.results = event_results
      # TODO: date
      return @event
    end

    private

      def event_name
        # TODO: make helper method for .gsub(/[[:space:]]+/, ' ').strip
        return @page.parser.at_xpath('//h1[@class="ResultsArchiveTitle"]').text
          .gsub(/[[:space:]]+/, ' ').strip
      end

      def event_type
        if match = @event.name.match(/(?:.+) - (.+)/)
          result_title = match[1]
            .gsub(/(?<=RACE )RESULT/, '')
            .gsub(/OVERALL(?= QUALIFYING)/, '')
            .gsub(/(?<=PRACTICE)( )(?=[1|2|3])/, '')
            .parameterize('_')
          return result_title.to_sym
        else
          return nil
        end
      end

      def event_country
        node = @page.parser.at_xpath('//select[@name="meetingKey"]/option[@selected]')
        return node.text
      end

      def event_circuit
        node = @page.parser.at_xpath('//span[@class="circuit-info"]')
        return node.text
      end

      def event_results
        results = []
        table = @page.parser.at_xpath('//tbody')

        # Remove driver abbreviation from driver cell
        table.xpath('//span[@class="uppercase hide-for-desktop"]').each(&:remove)

        # Turn HTML table into an array of arrays
        data = table.xpath('//tr').map do |row|
          row.xpath('./td|./th').map do |cell|
            cell = cell.text.gsub(/[[:space:]]+/, ' ').strip
            cell.blank? ? nil : cell
          end
        end

        # Shift top row of table and convert cell text into symbols
        header = data.shift.map do |cell|
          cell.to_s.parameterize('_').to_sym
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
