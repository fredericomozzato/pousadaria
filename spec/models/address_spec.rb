require "rails_helper"

RSpec.describe Room, type: :model do
  describe "#valid" do
    it "válido com todos os atributos obrigatórios" do
      owner = Owner.new(email: "owner@email.com", password: "123456")
      inn = Inn.new(
      name: "Mar Aberto",
      corporate_name: "Pousada Mar Aberto/SC",
      registration_number: "84.485.218/0001-73",
      phone: "4899999-9999",
      email: "pousadamaraberto@hotmail.com",
      description: "Pousada na beira do mar com suítes e café da manhã incluso.",
      pay_methods: "Crédito, débito, dinheiro ou pix",
      pet_friendly: true,
      user_policies: "A pousada conta com lei do silêncio das 22h às 8h",
      check_in_time: Time.new(2000, 1, 1, 9, 0, 0, "UTC"),
      check_out_time: Time.new(2000, 1, 1, 15, 30, 0, "UTC"),
      owner: owner
      )

      address = Address.new(
        street: "Rua das Flores",
        number: "300",
        neighborhood: "Centro",
        city: "Florianópolis",
        state: "SC",
        postal_code: "88000-000",
        inn: inn
      )

      expect(address).to be_valid
    end

    it "inválido sem rua" do
      address = Address.new(street: "")

      expect(address).to_not be_valid
      expect(address.errors.include?(:street)).to be true
    end

    it "inválido sem número" do
      address = Address.new(number: "")

      expect(address).to_not be_valid
      expect(address.errors.include?(:number)).to be true
    end

    it "inválido com número negativo" do
      address = Address.new(number: "-1")

      expect(address).to_not be_valid
      expect(address.errors.include?(:number)).to be true
    end

    it "inválido sem bairro" do
      address = Address.new(neighborhood: "")

      expect(address).to_not be_valid
      expect(address.errors.include?(:neighborhood)).to be true
    end

    it "inválido sem cidade" do
      address = Address.new(city: "")

      expect(address).to_not be_valid
      expect(address.errors.include?(:city)).to be true
    end

    it "inválido sem estado" do
      address = Address.new(state: "")

      expect(address).to_not be_valid
      expect(address.errors.include?(:state)).to be true
    end

    it "inválido com estado diferente com menos de 2 caracteres" do
      address = Address.new(state: "S")

      expect(address).to_not be_valid
      expect(address.errors.include?(:state)).to be true
    end

    it "inválido com estado com mais de 2 caracteres" do
      address = Address.new(state: "SCC")

      expect(address).to_not be_valid
      expect(address.errors.include?(:state)).to be true
    end

    it "inválido sem CEP" do
      address = Address.new(postal_code: "")

      expect(address).to_not be_valid
      expect(address.errors.include?(:postal_code)).to be true
    end
  end

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
