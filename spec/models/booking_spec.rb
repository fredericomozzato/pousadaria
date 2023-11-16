require "rails_helper"

RSpec.describe Booking, type: :model do
  describe "#valid" do
    it "inválido sem data de check-in" do
      booking = Booking.new(
        start_date: nil,
      )

      expect(booking.valid?).to be false
      expect(booking.errors.include?(:start_date)).to be true
    end

    it "inválido sem data de check-out" do
      booking = Booking.new(
        end_date: nil,
      )

      expect(booking.valid?).to be false
      expect(booking.errors.include?(:end_date)).to be true
    end

    it "inválido sem número de hóspedes" do
      booking = Booking.new(
        number_of_guests: nil,
      )

      expect(booking.valid?).to be false
      expect(booking.errors.include?(:number_of_guests)).to be true
    end

    it "inválido com número de hóspedes menor que zero" do
      owner = Owner.create!(
        email: "owner@email.com",
        password: "123456"
      )
      inn = Inn.create!(
        name: "Mar Aberto",
        corporate_name: "Pousada Mar Aberto/SC",
        registration_number: "84.485.218/0001-73",
        phone: "4899999-9999",
        email: "maraberto@email.com",
        description: "Pousada na beira do mar com suítes e café da manhã incluso.",
        pay_methods: "Crédito, débito, dinheiro ou pix",
        owner: owner
      )
      room = Room.create!(
        name: "Quarto",
        size: 30,
        max_guests: 2,
        price: 100.00,
        inn: inn
      )
      booking = Booking.new(
        room: room,
        start_date: 1.week.ago,
        end_date: 3.days.from_now,
        number_of_guests: -1
      )

      expect(booking.valid?).to be false
      expect(booking.errors.include?(:number_of_guests)).to be true
    end

    it "inválido se data de check-in no passado" do
      owner = Owner.create!(
        email: "owner@email.com",
        password: "123456"
      )
      inn = Inn.create!(
        name: "Mar Aberto",
        corporate_name: "Pousada Mar Aberto/SC",
        registration_number: "84.485.218/0001-73",
        phone: "4899999-9999",
        email: "maraberto@email.com",
        description: "Pousada na beira do mar com suítes e café da manhã incluso.",
        pay_methods: "Crédito, débito, dinheiro ou pix",
        owner: owner
      )
      room = Room.create!(
        name: "Quarto",
        size: 30,
        max_guests: 2,
        price: 100.00,
        inn: inn
      )
      booking = Booking.new(
        room: room,
        start_date: 1.week.ago,
        end_date: 3.days.from_now,
        number_of_guests: 2
      )

      expect(booking.valid?).to be false
      expect(booking.errors.include?(:start_date)).to be true
    end

    it "inválido se data de check-out antes do check-in" do
      owner = Owner.create!(
        email: "owner@email.com",
        password: "123456"
      )
      inn = Inn.create!(
        name: "Mar Aberto",
        corporate_name: "Pousada Mar Aberto/SC",
        registration_number: "84.485.218/0001-73",
        phone: "4899999-9999",
        email: "maraberto@email.com",
        description: "Pousada na beira do mar com suítes e café da manhã incluso.",
        pay_methods: "Crédito, débito, dinheiro ou pix",
        owner: owner
      )
      room = Room.create!(
        name: "Quarto",
        size: 30,
        max_guests: 2,
        price: 100.00,
        inn: inn
      )
      booking = Booking.new(
        room: room,
        start_date: 1.week.from_now,
        end_date: 2.days.from_now,
        number_of_guests: 2
      )

      expect(booking.valid?).to be false
      expect(booking.errors.include?(:end_date)).to be true
    end

    it "inválido se data de check-out no passado" do
      owner = Owner.create!(
        email: "owner@email.com",
        password: "123456"
      )
      inn = Inn.create!(
        name: "Mar Aberto",
        corporate_name: "Pousada Mar Aberto/SC",
        registration_number: "84.485.218/0001-73",
        phone: "4899999-9999",
        email: "maraberto@email.com",
        description: "Pousada na beira do mar com suítes e café da manhã incluso.",
        pay_methods: "Crédito, débito, dinheiro ou pix",
        owner: owner
      )
      room = Room.create!(
        name: "Quarto",
        size: 30,
        max_guests: 2,
        price: 100.00,
        inn: inn
      )
      booking = Booking.new(
        room: room,
        start_date: 1.week.from_now,
        end_date: 3.days.ago,
        number_of_guests: 2
      )

      expect(booking.valid?).to be false
      expect(booking.errors.include?(:end_date)).to be true
    end

    it "inválido se reserva conflita com outra reserva" do
      owner = Owner.create!(
        email: "owner@email.com",
        password: "123456"
      )
      inn = Inn.create!(
        name: "Mar Aberto",
        corporate_name: "Pousada Mar Aberto/SC",
        registration_number: "84.485.218/0001-73",
        phone: "4899999-9999",
        email: "maraberto@email.com",
        description: "Pousada na beira do mar com suítes e café da manhã incluso.",
        pay_methods: "Crédito, débito, dinheiro ou pix",
        owner: owner
      )
      room = Room.create!(
        name: "Quarto",
        size: 30,
        max_guests: 2,
        price: 100.00,
        inn: inn
      )
      user_1 = User.create!(
        email: "user1@email.com",
        password: "123456",
        name: "User 1",
        cpf: "859.125.819-34"
      )
      confirmed_booking = Booking.create!(
        room: room,
        user: user_1,
        start_date: 1.day.from_now,
        end_date: 3.days.from_now,
        number_of_guests: 2
      )
      user_2 = User.create!(
        email: "user2@email.com",
        password: "123456",
        name: "User 2",
        cpf: "353.940.620-48"
      )
      new_booking = Booking.new(
        room: room,
        user: user_2,
        start_date: 2.days.from_now,
        end_date: 4.days.from_now,
        number_of_guests: 2
      )

      expect(new_booking.valid?).to eq false
      expect(new_booking.errors.include?(:start_date)).to be true
    end

    it "válido se reserva não conflita com outra reserva" do
      owner = Owner.create!(
        email: "owner@email.com",
        password: "123456"
      )
      inn = Inn.create!(
        name: "Mar Aberto",
        corporate_name: "Pousada Mar Aberto/SC",
        registration_number: "84.485.218/0001-73",
        phone: "4899999-9999",
        email: "maraberto@email.com",
        description: "Pousada na beira do mar com suítes e café da manhã incluso.",
        pay_methods: "Crédito, débito, dinheiro ou pix",
        owner: owner
      )
      room = Room.create!(
        name: "Quarto",
        size: 30,
        max_guests: 2,
        price: 100.00,
        inn: inn
      )
      user_1 = User.create!(
        email: "user1@email.com",
        password: "123456",
        name: "User 1",
        cpf: "709.508.180-89"
        )
      confirmed_booking = Booking.create!(
        room: room,
        user: user_1,
        start_date: 1.day.from_now,
        end_date: 3.days.from_now,
        number_of_guests: 2
      )
      user_2 = User.create!(
        email: "user2@email.com",
        password: "123456",
        name: "User 2",
        cpf: "623.099.110-11"
      )
      new_booking = Booking.new(
        room: room,
        user: user_2,
        start_date: 5.days.from_now,
        end_date: 8.days.from_now,
        number_of_guests: 2
      )

      new_booking.valid?

      expect(new_booking.errors.include?(:start_date)).to be false
    end

    it "inválido se número de hóspedes maior que permitido no quarto" do
      owner = Owner.create!(
        email: "owner@email.com",
        password: "123456"
      )
      inn = Inn.create!(
        name: "Mar Aberto",
        corporate_name: "Pousada Mar Aberto/SC",
        registration_number: "84.485.218/0001-73",
        phone: "4899999-9999",
        email: "maraberto@email.com",
        description: "Pousada na beira do mar com suítes e café da manhã incluso.",
        pay_methods: "Crédito, débito, dinheiro ou pix",
        owner: owner
      )
      room = Room.create!(
        name: "Quarto",
        size: 30,
        max_guests: 2,
        price: 100.00,
        inn: inn
      )
      booking = Booking.new(
        room: room,
        start_date: 1.day.from_now,
        end_date: 3.days.from_now,
        number_of_guests: 3
      )

      expect(booking.valid?).to be false
      expect(booking.errors.include?(:number_of_guests)).to be true
    end


  end

  describe "#calculate_bill" do
    it "calcula o valor total das diárias" do
      room = Room.new(price: 100.00)
      booking = Booking.new(
        start_date: 1.day.from_now,
        end_date: 3.days.from_now
      )
      allow(Room).to receive(:find).with(booking.room_id).and_return(room)

      expect(booking.calculate_bill).to eq 200.00
    end

    it "com inicio antes e fim dentro de um preço sazonal" do
      owner = Owner.create!(
        email: "owner@email.com",
        password: "123456"
      )
      inn = Inn.create!(
        name: "Mar Aberto",
        corporate_name: "Pousada Mar Aberto/SC",
        registration_number: "84.485.218/0001-73",
        phone: "4899999-9999",
        email: "maraberto@email.com",
        description: "Pousada na beira do mar com suítes e café da manhã incluso.",
        pay_methods: "Crédito, débito, dinheiro ou pix",
        owner: owner
      )
      room = Room.create!(
        name: "Quarto",
        size: 30,
        max_guests: 2,
        price: 100.00,
        inn: inn
      )
      SeasonalPrice.create!(
        start: 2.days.from_now,
        end: 5.days.from_now,
        price: 200.00,
        room: room
      )
      booking = Booking.new(
        start_date: 1.day.from_now,
        end_date: 3.days.from_now
      )
      allow(Room).to receive(:find).with(booking.room_id).and_return(room)

      expect(booking.calculate_bill).to eq 300.00
    end

    it "com início entre e fim depois de um preço sazonal" do
      owner = Owner.create!(
        email: "owner@email.com",
        password: "123456"
      )
      inn = Inn.create!(
        name: "Mar Aberto",
        corporate_name: "Pousada Mar Aberto/SC",
        registration_number: "84.485.218/0001-73",
        phone: "4899999-9999",
        email: "maraberto@email.com",
        description: "Pousada na beira do mar com suítes e café da manhã incluso.",
        pay_methods: "Crédito, débito, dinheiro ou pix",
        owner: owner
      )
      room = Room.create!(
        name: "Quarto",
        size: 30,
        max_guests: 2,
        price: 100.00,
        inn: inn
      )
      SeasonalPrice.create!(
        start: 2.days.from_now,
        end: 5.days.from_now,
        price: 200.00,
        room: room
      )
      booking = Booking.new(
        start_date: 3.day.from_now,
        end_date: 6.days.from_now
      )
      allow(Room).to receive(:find).with(booking.room_id).and_return(room)

      expect(booking.calculate_bill).to eq 500.00
    end

    it "com início antes e fim depois de um preço sazonal" do
      owner = Owner.create!(
        email: "owner@email.com",
        password: "123456"
      )
      inn = Inn.create!(
        name: "Mar Aberto",
        corporate_name: "Pousada Mar Aberto/SC",
        registration_number: "84.485.218/0001-73",
        phone: "4899999-9999",
        email: "maraberto@email.com",
        description: "Pousada na beira do mar com suítes e café da manhã incluso.",
        pay_methods: "Crédito, débito, dinheiro ou pix",
        owner: owner
      )
      room = Room.create!(
        name: "Quarto",
        size: 30,
        max_guests: 2,
        price: 100.00,
        inn: inn
      )
      SeasonalPrice.create!(
        start: 2.days.from_now,
        end: 5.days.from_now,
        price: 200.00,
        room: room
      )
      booking = Booking.new(
        start_date: 1.day.from_now,
        end_date: 7.days.from_now
      )
      allow(Room).to receive(:find).with(booking.room_id).and_return(room)

      expect(booking.calculate_bill).to eq 1000
    end

    it "com início e fim entre um preço sazonal" do
      owner = Owner.create!(
        email: "owner@email.com",
        password: "123456"
      )
      inn = Inn.create!(
        name: "Mar Aberto",
        corporate_name: "Pousada Mar Aberto/SC",
        registration_number: "84.485.218/0001-73",
        phone: "4899999-9999",
        email: "maraberto@email.com",
        description: "Pousada na beira do mar com suítes e café da manhã incluso.",
        pay_methods: "Crédito, débito, dinheiro ou pix",
        owner: owner
      )
      room = Room.create!(
        name: "Quarto",
        size: 30,
        max_guests: 2,
        price: 100.00,
        inn: inn
      )
      SeasonalPrice.create!(
        start: 1.days.from_now,
        end: 7.days.from_now,
        price: 200.00,
        room: room
      )
      booking = Booking.new(
        start_date: 2.day.from_now,
        end_date: 5.days.from_now
      )
      allow(Room).to receive(:find).with(booking.room_id).and_return(room)

      expect(booking.calculate_bill).to eq 600.00
    end

    it "englobando 2 períodos de preços sazonais" do
      owner = Owner.create!(
        email: "owner@email.com",
        password: "123456"
      )
      inn = Inn.create!(
        name: "Mar Aberto",
        corporate_name: "Pousada Mar Aberto/SC",
        registration_number: "84.485.218/0001-73",
        phone: "4899999-9999",
        email: "maraberto@email.com",
        description: "Pousada na beira do mar com suítes e café da manhã incluso.",
        pay_methods: "Crédito, débito, dinheiro ou pix",
        owner: owner
      )
      room = Room.create!(
        name: "Quarto",
        size: 30,
        max_guests: 2,
        price: 200.00,
        inn: inn
      )
      seasonal_price_1 = SeasonalPrice.create!(
        start: 3.days.from_now,
        end: 5.days.from_now,
        price: 300.00,
        room: room
      )
      seasonal_price_1 = SeasonalPrice.create!(
        start: 7.days.from_now,
        end: 10.days.from_now,
        price: 100.00,
        room: room
      )
      booking = Booking.new(
        start_date: 4.days.from_now,
        end_date: 8.days.from_now
      )
      allow(Room).to receive(:find).with(booking.room_id).and_return(room)

      expect(booking.calculate_bill).to eq 900.00
    end
  end
end
