module XlsxFixtureHelper
  def xlsx_with(shared_strings_xml)
    file = Tempfile.new(%w[fixture .xlsx])
    Zip::OutputStream.open(file.path) do |out|
      out.put_next_entry('xl/sharedStrings.xml')
      out.write(shared_strings_xml)
    end
    file
  end

  def build_shared_strings_xml(texts)
    <<~EOF
      <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
      <sst xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" count="#{texts.size}" uniqueCount="#{texts.uniq.size}">
        #{texts.map { |text| %(<si><t xml:space="preserve">#{text}</t></si>) }.join("\n")}
      </sst>
    EOF
  end

  def dollar_placeholder(key)
    "$#{key.to_s.upcase}$"
  end
end