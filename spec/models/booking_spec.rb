require "rails_helper"

RSpec.describe Booking, type: :model do
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
  end

  describe "#dates_conflict?" do
    it "retorna true se a reserva conflita com outra reserva" do
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
      user_1 = User.create!(email: "user1@email.com", password: "123456")
      confirmed_booking = Booking.create!(
        room: room,
        user: user_1,
        start_date: 1.day.from_now,
        end_date: 3.days.from_now,
        number_of_guests: 2
      )
      user_2 = User.create!(email: "user2@email.com", password: "123456")
      new_booking = Booking.new(
        room: room,
        user: user_2,
        start_date: 2.days.from_now,
        end_date: 4.days.from_now,
        number_of_guests: 2
      )

      expect(new_booking.dates_conflict?).to eq true
    end

    it "retorna false se a reserva não conflita com outra reserva" do
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
      user_1 = User.create!(email: "user1@email.com", password: "123456")
      confirmed_booking = Booking.create!(
        room: room,
        user: user_1,
        start_date: 1.day.from_now,
        end_date: 3.days.from_now,
        number_of_guests: 2
      )
      user_2 = User.create!(email: "user2@email.com", password: "123456")
      new_booking = Booking.new(
        room: room,
        user: user_2,
        start_date: 5.days.from_now,
        end_date: 8.days.from_now,
        number_of_guests: 2
      )

      expect(new_booking.dates_conflict?).to eq false
    end
  end

  describe "#too_many_guests?" do
    it "retorna true se número de hóspedes é maior que o máximo permitido" do
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

      expect(booking.too_many_guests?).to eq true
    end
  end
end
