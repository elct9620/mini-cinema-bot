# frozen_string_literal: true

module VSCinemas
  class MovieList
    include Enumerable

    # @since 0.1.0
    attr_reader :page, :continue

    # @param page [Number]
    # @param continue [Boolean]
    #
    # @since 0.1.0
    def initialize(page: 1, continue: false)
      @page = page
      @continue = continue
    end

    # @since 0.1.0
    def each(&block)
      return enum_for(:each) unless defined?(yield)

      doc.css('.movieList li').map { |el| MovieItem.new(el) }.each(&block)
      self.next.each(&block) if next? && continue?
    end

    # Parsed Document
    #
    # @return [Nokogiri::HTML::Document]
    #
    # @since 0.1.0
    def doc
      @doc ||= Nokogiri::HTML(body)
    end

    # Target URI
    #
    # @return [URI]
    #
    # @since 0.1.0
    def uri
      @uri ||= URI("#{ENDPOINT}#{PATH}?p=#{page}")
    end

    # Downloaded Web Page
    #
    # @return [String]
    #
    # @since 0.1.0
    def body
      @body ||= Net::HTTP.get(uri).force_encoding('UTF-8')
    end

    # Next Page
    #
    # @return [Number]
    #
    # @since 0.1.0
    def next_page
      @next_page ||= doc.css('.pagebar li.press+li').text&.to_i
    end

    # Has Next Page
    #
    # @return [Boolean]
    #
    # @since 0.1.0
    def next?
      next_page && next_page != 0
    end

    # Next List
    #
    # @return [VSCinemas::MovieList]
    #
    # @since 0.1.0
    def next
      MovieList.new(page: next_page, continue: continue) if next?
    end

    # Continue to Next Page
    #
    # @return [Boolean]
    #
    # @since 0.1.0
    def continue?
      continue == true
    end
  end
end
