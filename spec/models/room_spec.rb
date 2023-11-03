require "rails_helper"

RSpec.describe Room, type: :model do
  describe "#valid?" do
    it "inválido sem nome" do
      room = Room.new(name: "")

      expect(room.valid?).to be false
      expect(room.errors.include?(:name)).to be true
    end

    it "inválido sem tamanho" do
      room = Room.new(size: nil)

      expect(room.valid?).to be false
      expect(room.errors.include?(:size)).to be true
    end

    it "inválido com tamanho 0" do
      room = Room.new(size: 0)

      expect(room.valid?).to be false
      expect(room.errors.include?(:size)).to be true
    end

    it "inválido com tamanho menor que 0" do
      room = Room.new(size: -1)

      expect(room.valid?).to be false
      expect(room.errors.include?(:size)).to be true
    end

    it "inválido sem número máximo de hóspedes" do
      room = Room.new(max_guests: nil)

      expect(room.valid?).to be false
      expect(room.errors.include?(:max_guests)).to be true
    end

    it "inválido com número de hóspedes 0" do
      room = Room.new(max_guests: 0)

      expect(room.valid?).to be false
      expect(room.errors.include?(:max_guests)).to be true
    end

    it "inválido com número de hóspedes menor que 0" do
      room = Room.new(max_guests: -1)

      expect(room.valid?).to be false
      expect(room.errors.include?(:max_guests)).to be true
    end

    it "inválido sem preço" do
      room = Room.new(price: nil)

      expect(room.valid?).to be false
      expect(room.errors.include?(:price)).to be true
    end

    it "inválido com preço 0" do
      room = Room.new(price: 0)

      expect(room.valid?).to be false
    end
  end
end
