require "rails_helper"

RSpec.describe User, type: :model do
  describe "#valid?" do
    it "inválido sem nome" do
      user = User.new(name: "")

      expect(user.valid?).to be false
      expect(user.errors.include?(:name)).to be
    end

    it "inválido sem cpf" do
      user = User.new(cpf: "")

      expect(user.valid?).to be false
      expect(user.errors.include?(:cpf)).to be
    end

    it "inválido com cpf duplicado" do
      valid_user = User.create!(
        name: "Fulano",
        cpf: "07889230052",
        email: "fulano@email.com",
        password: "123456"
      )
      invalid_user = User.new(cpf: valid_user.cpf)

      expect(invalid_user.valid?).to be false
      expect(invalid_user.errors.include?(:cpf)).to be
    end

    it "inválido sem email" do
      user = User.new(email: "")

      expect(user.valid?).to be false
      expect(user.errors.include?(:email)).to be
    end

    it "inválido com email duplicado" do
      valid_user = User.create!(
        name: "Fulano",
        cpf: "07889230052",
        email: "fulano@email.com",
        password: "123456"
      )
    invalid_user = User.new(email: valid_user.email)

    expect(invalid_user.valid?).to be false
    expect(invalid_user.errors.include?(:email)).to be
    end

    it "inválido com email inválido" do
      user = User.new(email: "fulanoemail.com")

      expect(user.valid?).to be false
      expect(user.errors.include?(:email)).to be
    end

    it "inválido sem senha" do
      user = User.new(password: "")

      expect(user.valid?).to be false
      expect(user.errors.include?(:password)).to be true
    end

    it "inválido com senha menor que 6 caracteres" do
      user = User.new(password: "12345")

      expect(user.valid?).to be false
      expect(user.errors.include?(:password)).to be true
    end
  end

  describe "#validate_cpf" do
    it "válido com formatação" do
      user = User.new(cpf: "078.892.300-52")

      user.valid?

      expect(user.errors.include?(:cpf)).to be false
    end

    it "válido sem formatação" do
      user = User.new(cpf: "07889230052")

      user.valid?

      expect(user.errors.include?(:cpf)).to be false
    end

    it "inválido com formatação" do
      user = User.new(cpf: "078.892.300-53")

      user.valid?

      expect(user.errors.include?(:cpf)).to be true
    end

    it "inválido sem formatação" do
      user = User.new(cpf: "07889230053")

      user.valid?

      expect(user.errors.include?(:cpf)).to be true
    end
  end
end
