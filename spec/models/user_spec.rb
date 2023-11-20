require "rails_helper"

RSpec.describe User, type: :model do
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
