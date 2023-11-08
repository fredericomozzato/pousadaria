require "rails_helper"

RSpec.describe Inn, type: :model do
  describe "#valid?" do
    it "inválido com nome vazio" do
    inn = Inn.new(name: "")

    expect(inn.valid?).to be false
    expect(inn.errors.include?(:name)).to be true
    end

    it "inválido com Razão social vazia" do
      inn = Inn.new(corporate_name: "")

      expect(inn.valid?).to be false
      expect(inn.errors.include?(:corporate_name)).to be true
    end

    it "inválido com CNPJ vazio" do
      inn = Inn.new(registration_number: "")

      expect(inn.valid?).to be false
      expect(inn.errors.include?(:registration_number)).to be true
    end

    it "inválido com telefone vazio" do
      inn = Inn.new(phone: "")

      expect(inn.valid?).to be false
      expect(inn.errors.include?(:phone)).to be true
    end

    it "inválido com email vazio" do
      inn = Inn.new(email: "")

      expect(inn.valid?).to be false
      expect(inn.errors.include?(:email)).to be true
    end

    it "inválido com meios de pagamento vazios" do
      inn = Inn.new(pay_methods: "")

      expect(inn.valid?).to be false
      expect(inn.errors.include?(:pay_methods)).to be true
    end
  end
end
