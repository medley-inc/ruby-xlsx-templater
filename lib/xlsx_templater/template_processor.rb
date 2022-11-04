module XlsxTemplater
  class TemplateProcessor
    attr_reader :data, :escape_html

    def initialize(data, escape_html = true)
      @data = data
      @escape_html = escape_html
    end

    def render(document)
      document.force_encoding(Encoding::UTF_8) if document.respond_to?(:force_encoding)
      data.each do |key, value|
        document.gsub!("$#{key.to_s.upcase}$", safe(value))
      end
      document
    end

    def self.scan_params template_path
      document = Zip::File.open(template_path)
                   .select { |entry| entry.name == SHARED_STRINGS_XML }
                   .first
                  
      unless document
        raise ::XlsxTemplater::InvalidInputError, "There is no entry matching to #{SHARED_STRINGS_XML}"
      end
                   
      document = document
                   .get_input_stream
                   .read
      document.force_encoding(Encoding::UTF_8) if document.respond_to?(:force_encoding)
      document.scan(/\$([A-Z_\d+]+)\$/).flatten
    end

    private
    def safe(text)
      if escape_html
        text.to_s.gsub('&', '&amp;').gsub('>', '&gt;').gsub('<', '&lt;')
      else
        text.to_s
      end
    end
  end
end
