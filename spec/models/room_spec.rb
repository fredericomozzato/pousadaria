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

    it "inválido com arquivo de imagem diferente de jpeg/png" do
      room = Room.new()
      room.photos.attach(
        io: File.open(Rails.root.join("spec/fixtures/images/wrong_type_file.txt")),
        filename: "wrong_type_file.txt")

      expect(room.valid?).to be false
      expect(room.errors.include?(:photos)).to be true
      expect(room.errors[:photos]).to include "somente nos formatos JPG, JPEG ou PNG"
    end

    it "inválido com mais de 5 fotos adicionadas" do
      room = Room.new()
      room.photos.attach(
        {io: File.open(Rails.root.join("spec/fixtures/images/room_img_1.jpg")), filename: "room_img_1.jpg"},
        {io: File.open(Rails.root.join("spec/fixtures/images/room_img_2.jpg")), filename: "room_img_2.jpg"},
        {io: File.open(Rails.root.join("spec/fixtures/images/room_img_3.jpg")), filename: "room_img_3.jpg"},
        {io: File.open(Rails.root.join("spec/fixtures/images/room_img_4.jpg")), filename: "room_img_4.jpg"},
        {io: File.open(Rails.root.join("spec/fixtures/images/room_img_5.jpg")), filename: "room_img_5.jpg"},
        {io: File.open(Rails.root.join("spec/fixtures/images/room_img_6.jpg")), filename: "room_img_6.jpg"},
      )

      expect(room.valid?).to be false
      expect(room.errors.include?(:photos)).to be true
      expect(room.errors[:photos]).to include "Número máximo de fotos: 5"
    end

    it "inválido com arquivo maior que 5 mb" do
      room = Room.new()
      room.photos.attach(
        io: File.open(Rails.root.join("spec/fixtures/images/5_mb_img.jpg")), filename: "5_mb_img.jpg"
      )

      expect(room.valid?).to be false
      expect(room.errors.include?(:photos)).to be true
      expect(room.errors[:photos]).to include "não pode ser maior que 5 mb"
    end
  end
end
