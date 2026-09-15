require 'spec_helper'

RSpec.describe XlsxTemplater::TemplateProcessor do
  let(:data) { build_template_data }
  let(:parser) { described_class.new(data) }

  describe '.scan_params' do
    it 'ドル記号で囲まれたパラメータがスキャンされること' do
      fixture = xlsx_with(build_shared_strings_xml(%w[$PATIENT_ID$ $PATIENT_NAME$]))
      out = XlsxTemplater::TemplateProcessor.scan_params(fixture.path)
      expect(out).to eq(%w[PATIENT_ID PATIENT_NAME])
    end

    it '二重波括弧で囲まれたパラメータがスキャンされること' do
      fixture = xlsx_with(build_shared_strings_xml(%w[{{PATIENT_ID}} {{PATIENT_NAME}}]))
      out = XlsxTemplater::TemplateProcessor.scan_params(fixture.path)
      expect(out).to eq(%w[PATIENT_ID PATIENT_NAME])
    end

    it 'ドル記号と二重波括弧の両方で囲まれたパラメータがスキャンされること' do
      fixture = xlsx_with(build_shared_strings_xml(%w[$PATIENT_ID$ {{PATIENT_NAME}}]))
      out = XlsxTemplater::TemplateProcessor.scan_params(fixture.path)
      expect(out).to eq(%w[PATIENT_ID PATIENT_NAME])
    end

    it 'キーを含まない文字列しかないときに[]を返すか' do
      fixture = xlsx_with(build_shared_strings_xml(['no keys']))
      out = XlsxTemplater::TemplateProcessor.scan_params(fixture.path)
      expect(out).to eq([])
    end

    it 'ドル記号でも二重波括弧でも囲まれていないパラメータはスキャンされないこと' do
      fixture = xlsx_with(build_shared_strings_xml(%w[%PATIENT_ID% %PATIENT_NAME%]))
      out = XlsxTemplater::TemplateProcessor.scan_params(fixture.path)
      expect(out).to eq([])
    end
  end

  describe '#render' do
    it 'ドル記号のキーが値に置き換わること' do
      xml = build_shared_strings_xml(%w[$PATIENT_ID$ $PATIENT_NAME$])
      out = parser.render(xml)
      expect(out).to include(data[:patient_id])
      expect(out).to include(data[:patient_name])
      expect(out).not_to include('$PATIENT_ID$')
      expect(out).not_to include('$PATIENT_NAME$')
    end

    it '二重波括弧のキーが値に置き換わること' do
      xml = build_shared_strings_xml(%w[{{PATIENT_ID}} {{PATIENT_NAME}}])
      out = parser.render(xml)
      expect(out).to include(data[:patient_id])
      expect(out).to include(data[:patient_name])
      expect(out).not_to include('{{PATIENT_ID}}')
      expect(out).not_to include('{{PATIENT_NAME}}')
    end

    it 'ドル記号と二重波括弧の両方のキーが値に置き換わること' do
      xml = build_shared_strings_xml(%w[$PATIENT_ID$ {{PATIENT_NAME}}])
      out = parser.render(xml)
      expect(out).to include(data[:patient_id])
      expect(out).to include(data[:patient_name])
      expect(out).not_to include('$PATIENT_ID$')
      expect(out).not_to include('{{PATIENT_NAME}}')
    end

    it '全キーが値に置き換わること' do
      xml = build_shared_strings_xml(data.keys.map { |key| dollar_placeholder(key) })
      out = parser.render(xml)
      data.each do |key, value|
        expect(out).to include(value.to_s)
        expect(out).not_to include(dollar_placeholder(key))
      end
    end

    it '値に半角の & が含まれても壊れた XML を出力しないこと' do
      data[:clinic_name] = 'メディカル&ケアクリニック'
      xml = build_shared_strings_xml(['$CLINIC_NAME$'])
      out = parser.render(xml)
      expect(out).to include('メディカル&amp;ケアクリニック')
    end

    it 'ドル記号でも二重波括弧でも囲まれていないパラメータは値に置き換わらないこと' do
      xml = build_shared_strings_xml(%w[%PATIENT_ID% %PATIENT_NAME%])
      out = parser.render(xml)
      expect(out).to include('%PATIENT_ID%')
      expect(out).to include('%PATIENT_NAME%')
    end
  end
end

