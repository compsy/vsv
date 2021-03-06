# frozen_string_literal: true

require 'rails_helper'

describe PersonExporter do
  it_behaves_like 'an object_exporter object'

  context 'without people' do
    it 'works without people' do
      export = described_class.export_lines.to_a.join.split("\n")
      expect(export.size).to eq 1
    end
  end

  context 'with people' do
    let!(:student) { FactoryBot.create :student }
    let!(:person) { FactoryBot.create :person }
    let!(:mentor) { FactoryBot.create :mentor }

    # Create a person that should be filtered out
    let!(:student2) { FactoryBot.create(:student, :with_test_phone_number) }

    describe 'works with people' do
      let(:export) { described_class.export_lines.to_a.join.split("\n") }

      it 'exports the correct identifier' do
        expect(ENV['TEST_PHONE_NUMBERS'].split(',')).to include student2.mobile_phone

        expect(export.size).to eq 4

        ids = Person.all.map { |p| p.external_identifier unless Exporters.test_phone_number? p.mobile_phone }
        id_col = export.last.split(';', -1).first
        expect(ids).to(be_any { |id| id_col.include? id })
        expect(id_col).to match(/\A"[a-z0-9]{4}"\z/)
        expect(export.last.split(';', -1).size).to eq export.first.split(';', -1).size
      end
    end
  end
end
