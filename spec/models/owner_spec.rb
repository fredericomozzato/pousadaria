require "rails_helper"

RSpec.describe Owner, type: :model do
  describe "#valid" do
    it "inválido com e-mail vazio" do
      owner = Owner.new(email: "")

      expect(owner.valid?).to be false
      expect(owner.errors.include?(:email)).to be true
    end

    it "inválido com e-mail duplicado" do
      owner = Owner.create!(email: "owner@email.com", password: "123456")
      invalid_owner = Owner.new(email: owner.email)

      expect(invalid_owner.valid?).to be false
      expect(invalid_owner.errors.include?(:email)).to be true
    end

    it "inválido com e-mail inválido" do
      owner = Owner.new(email: "owneremail.com")

      expect(owner.valid?).to be false
      expect(owner.errors.include?(:email)).to be true
    end

    it "inválido com senha vazia" do
      owner = Owner.new(password: "")

      expect(owner.valid?).to be false
      expect(owner.errors.include?(:password)).to be true
    end

    it "inválido com senha menor que 6 caracteres" do
      owner = Owner.new(password: "12345")

      expect(owner.valid?).to be false
      expect(owner.errors.include?(:password)).to be true
    end
  end
end
