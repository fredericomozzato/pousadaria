require "rails_helper"

RSpec.describe Room, type: :model do
  describe "#street_values" do
    it "retorna rua e número formatados" do
      inn = Inn.new
      inn.address = Address.new(street: "Rua das Flores", number: "300")

      expect(inn.address.street_values).to eq "Rua das Flores, 300"
    end
  end

  describe "#location_values" do
    it "retorna bairro, cidade e estado formatados" do
      inn = Inn.new
      inn.address = Address.new(neighborhood: "Centro", city: "São Paulo", state: "SP")

      expect(inn.address.location_values).to eq "Centro - São Paulo, SP"
    end
  end
end
