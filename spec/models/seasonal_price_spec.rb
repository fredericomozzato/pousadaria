require "rails_helper"

RSpec.describe SeasonalPrice, type: :model do
  describe "#valid?" do
    it "inválido sem data de início" do
      sp = SeasonalPrice.new(start: nil)

      expect(sp.valid?).to be false
      expect(sp.errors.include?(:start)).to be true
      expect(sp.errors[:start]).to include("não pode ficar em branco")
    end

    it "inválido sem data de término" do
      sp = SeasonalPrice.new(end: nil)

      expect(sp.valid?).to be false
      expect(sp.errors.include?(:end)).to be true
      expect(sp.errors[:end]).to include("não pode ficar em branco")
    end

    it "inválido com data de início maior que data de término" do
      sp = SeasonalPrice.new(start: Date.today, end: 2.days.ago)

      expect(sp.valid?).to be false
      expect(sp.errors.include?(:start)).to be true
      expect(sp.errors[:start]).to include("Data de início não pode ser antes da data de término")
    end

    it "inválido com data de término no passado" do
      sp = SeasonalPrice.new(end: 2.days.ago)

      expect(sp.valid?).to be false
      expect(sp.errors.include?(:end)).to be true
      expect(sp.errors[:end]).to include("Data de término não pode estar no passado")
    end

    it "inválido com data de início igual data de término" do
      sp = SeasonalPrice.new(start: 1.week.from_now, end: 1.week.from_now)

      expect(sp.valid?).to be false
      expect(sp.errors.include?(:start)).to be true
      expect(sp.errors[:start]).to include("Data de início não pode ser igual à data de término")
    end

    it "inválido com data de início entre datas de outro preço sazonal" do
      owner = Owner.create!(email: "owner@email.com", password: "123456")
      inn = Inn.create!(name: "Pousada", corporate_name: "Pousada S/A",
                    registration_number: "123445566799", phone: "999999999",
                    email: "pousada@email.com", pay_methods: "Dinheiro",
                    owner_id: owner.id)
      room = Room.create!(name: "Quarto", size: 20, max_guests: 2, inn_id: inn.id,
                          price: 200)
      valid_sp = SeasonalPrice.create!(start: 1.week.from_now, end: 3.weeks.from_now, price: 300, room_id: room.id)
      invalid_sp = SeasonalPrice.new(start: 2.weeks.from_now, end: 4.weeks.from_now, price: 400, room_id: room.id)

      expect(invalid_sp.valid?).to be false
      expect(invalid_sp.errors.include?(:start)).to be true
      expect(invalid_sp.errors[:start]).to include("Data de início conflita com outro preço sazonal")
    end

    it "inválido com data de término entre datas de outro preço sazonal" do
      owner = Owner.create!(email: "owner@email.com", password: "123456")
      inn = Inn.create!(name: "Pousada", corporate_name: "Pousada S/A",
                    registration_number: "123445566799", phone: "999999999",
                    email: "pousada@email.com", pay_methods: "Dinheiro",
                    owner_id: owner.id)
      room = Room.create!(name: "Quarto", size: 20, max_guests: 2, inn_id: inn.id,
                          price: 200)
      valid_sp = SeasonalPrice.create!(start: 1.week.from_now, end: 3.weeks.from_now, price: 300, room_id: room.id)
      invalid_sp = SeasonalPrice.new(start: 1.day.from_now, end: 2.weeks.from_now, price: 200, room_id: room.id)

      expect(invalid_sp.valid?).to be false
      expect(invalid_sp.errors.include?(:end)).to be true
      expect(invalid_sp.errors[:end]).to include("Data de término conflita com outro preço sazonal")
    end

    it "inválido com data de início igual a data de início de outro preço sazonal" do
      owner = Owner.create!(email: "owner@email.com", password: "123456")
      inn = Inn.create!(name: "Pousada", corporate_name: "Pousada S/A",
                    registration_number: "123445566799", phone: "999999999",
                    email: "pousada@email.com", pay_methods: "Dinheiro",
                    owner_id: owner.id)
      room = Room.create!(name: "Quarto", size: 20, max_guests: 2, inn_id: inn.id,
                          price: 200)
      valid_sp = SeasonalPrice.create!(start: 1.week.from_now, end: 3.weeks.from_now, price: 300, room_id: room.id)
      invalid_sp = SeasonalPrice.new(start: 1.week.from_now, end: 4.weeks.from_now, price: 200, room_id: room.id)

      expect(invalid_sp.valid?).to be false
      expect(invalid_sp.errors.include?(:start)).to be true
      expect(invalid_sp.errors[:start]).to include("Data de início conflita com outro preço sazonal")
    end

    it "inválido com data de início igual a data de término de outro preço sazonal" do
      owner = Owner.create!(email: "owner@email.com", password: "123456")
      inn = Inn.create!(name: "Pousada", corporate_name: "Pousada S/A",
                    registration_number: "123445566799", phone: "999999999",
                    email: "pousada@email.com", pay_methods: "Dinheiro",
                    owner_id: owner.id)
      room = Room.create!(name: "Quarto", size: 20, max_guests: 2, inn_id: inn.id,
                          price: 200)
      valid_sp = SeasonalPrice.create!(start: 1.week.from_now, end: 3.weeks.from_now, price: 300, room_id: room.id)
      invalid_sp = SeasonalPrice.new(start: 3.weeks.from_now, end: 4.weeks.from_now, price: 200, room_id: room.id)

      expect(invalid_sp.valid?).to be false
      expect(invalid_sp.errors.include?(:start)).to be true
      expect(invalid_sp.errors[:start]).to include("Data de início conflita com outro preço sazonal")
    end

    it "inválido com data de término igual a data de início de outro preço sazonal" do
      owner = Owner.create!(email: "owner@email.com", password: "123456")
      inn = Inn.create!(name: "Pousada", corporate_name: "Pousada S/A",
                    registration_number: "123445566799", phone: "999999999",
                    email: "pousada@email.com", pay_methods: "Dinheiro",
                    owner_id: owner.id)
      room = Room.create!(name: "Quarto", size: 20, max_guests: 2, inn_id: inn.id,
                          price: 200)
      valid_sp = SeasonalPrice.create!(start: 1.week.from_now, end: 3.weeks.from_now, price: 300, room_id: room.id)
      invalid_sp = SeasonalPrice.new(start: Date.today, end: 1.week.from_now, price: 100, room_id: room.id)

      expect(invalid_sp.valid?).to be false
      expect(invalid_sp.errors.include?(:end)).to be true
      expect(invalid_sp.errors[:end]).to include("Data de término conflita com outro preço sazonal")
    end

    it "inválido com data de término igual a data de término de outro preço sazonal" do
      owner = Owner.create!(email: "owner@email.com", password: "123456")
      inn = Inn.create!(name: "Pousada", corporate_name: "Pousada S/A",
                    registration_number: "123445566799", phone: "999999999",
                    email: "pousada@email.com", pay_methods: "Dinheiro",
                    owner_id: owner.id)
      room = Room.create!(name: "Quarto", size: 20, max_guests: 2, inn_id: inn.id,
                          price: 200)
      valid_sp = SeasonalPrice.create!(start: 1.week.from_now, end: 3.weeks.from_now, price: 300, room_id: room.id)
      invalid_sp = SeasonalPrice.new(start: Date.today, end: 3.weeks.from_now, price: 100, room_id: room.id)

      expect(invalid_sp.valid?).to be false
      expect(invalid_sp.errors.include?(:end)).to be true
      expect(invalid_sp.errors[:end]).to include("Data de término conflita com outro preço sazonal")
    end

    it "inválido sem preço" do
      sp = SeasonalPrice.new(price: nil)

      expect(sp.valid?).to be false
      expect(sp.errors.include?(:price)).to be true
      expect(sp.errors[:price]).to include("não pode ficar em branco")
    end

    it "inválido com preço menor ou igual a 0" do
      sp = SeasonalPrice.new(price: 0)

      expect(sp.valid?).to be false
      expect(sp.errors.include?(:price)).to be true
      expect(sp.errors[:price]).to include("deve ser maior que 0")
    end
  end
end
