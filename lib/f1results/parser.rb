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
      @event.results = event_results
      # TODO: date
      return @event
    end

    private

      def event_name
        # TODO: make helper method for .gsub(/[[:space:]]+/, ' ').strip
        return @page.parser.xpath('//title').text
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
        slug = node.attr('value').split('/')[-1]
        text = node.text
        return text
      end

      def event_results
        results = []
        table = @page.parser.xpath('//tbody')

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
