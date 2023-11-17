require "rails_helper"

include ActiveSupport::Testing::TimeHelpers

describe "Tentativa de cancelamento de reserva", type: :request do
  it "é feita com sucesso pelo Proprietário" do
    owner = Owner.create!(
          email: "owner@email.com",
          password: "123456"
      )
    inn = Inn.create!(
      name: "Mar Aberto",
      corporate_name: "Pousada Mar Aberto/SC",
      registration_number: "84.485.218/0001-73",
      phone: "4899999-9999",
      email: "pousadamaraberto@gmail.com",
      description: "Pousada na beira do mar com suítes e café da manhã incluso.",
      pay_methods: "Crédito, débito, dinheiro ou pix",
      user_policies: "A pousada conta com lei do silêncio das 22h às 8h",
      pet_friendly: true,
      check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
      check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
      owner_id: owner.id
    )
    Address.create!(
      street: "Rua das Flores",
      number: 300,
      neighborhood: "Canasvieiras",
      city: "Florianópolis",
      state: "SC",
      postal_code: "88000-000",
      inn_id: inn.id
    )
    room_ocean = Room.create!(
      name: "Oceano",
      description: "Quarto com vista para o mar",
      size: 30,
      max_guests: 2,
      price: 200.00,
      inn_id: inn.id
    )
    user = User.create!(
        name: "User",
        cpf: "820.628.780-95",
        email: "user@email.com",
        password: "123456"
      )
    booking = Booking.create!(
      room: room_ocean,
      user: user,
      start_date: Date.today,
      end_date: 5.days.from_now,
      number_of_guests: 2,
    )

    travel 2.days do
      login_as owner
      post cancel_room_booking_path(room_ocean, booking)
      booking.reload
    end

    expect(response).to redirect_to booking_path(booking)
    expect(flash[:notice]).to eq "Reserva cancelada"
    expect(booking.canceled?).to be true
  end

  it "sem sucesso pelo Proprietário" do
    owner = Owner.create!(
          email: "owner@email.com",
          password: "123456"
      )
    inn = Inn.create!(
      name: "Mar Aberto",
      corporate_name: "Pousada Mar Aberto/SC",
      registration_number: "84.485.218/0001-73",
      phone: "4899999-9999",
      email: "pousadamaraberto@gmail.com",
      description: "Pousada na beira do mar com suítes e café da manhã incluso.",
      pay_methods: "Crédito, débito, dinheiro ou pix",
      user_policies: "A pousada conta com lei do silêncio das 22h às 8h",
      pet_friendly: true,
      check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
      check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
      owner_id: owner.id
    )
    Address.create!(
      street: "Rua das Flores",
      number: 300,
      neighborhood: "Canasvieiras",
      city: "Florianópolis",
      state: "SC",
      postal_code: "88000-000",
      inn_id: inn.id
    )
    room_ocean = Room.create!(
      name: "Oceano",
      description: "Quarto com vista para o mar",
      size: 30,
      max_guests: 2,
      price: 200.00,
      inn_id: inn.id
    )
    user = User.create!(
        name: "User",
        cpf: "820.628.780-95",
        email: "user@email.com",
        password: "123456"
      )
    booking = Booking.create!(
      room: room_ocean,
      user: user,
      start_date: Date.today,
      end_date: 5.days.from_now,
      number_of_guests: 2,
    )

    login_as owner
    post cancel_room_booking_path(room_ocean, booking)
    booking.reload

    expect(response).to redirect_to booking_path(booking)
    expect(flash[:alert]).to eq "Não foi possível cancelar a reserva"
    expect(booking.confirmed?).to be true
    expect(booking.canceled?).to be false
  end

  it "é feita com sucesso pelo Usuário" do
    owner = Owner.create!(
          email: "owner@email.com",
          password: "123456"
      )
    inn = Inn.create!(
      name: "Mar Aberto",
      corporate_name: "Pousada Mar Aberto/SC",
      registration_number: "84.485.218/0001-73",
      phone: "4899999-9999",
      email: "pousadamaraberto@gmail.com",
      description: "Pousada na beira do mar com suítes e café da manhã incluso.",
      pay_methods: "Crédito, débito, dinheiro ou pix",
      user_policies: "A pousada conta com lei do silêncio das 22h às 8h",
      pet_friendly: true,
      check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
      check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
      owner_id: owner.id
    )
    Address.create!(
      street: "Rua das Flores",
      number: 300,
      neighborhood: "Canasvieiras",
      city: "Florianópolis",
      state: "SC",
      postal_code: "88000-000",
      inn_id: inn.id
    )
    room_ocean = Room.create!(
      name: "Oceano",
      description: "Quarto com vista para o mar",
      size: 30,
      max_guests: 2,
      price: 200.00,
      inn_id: inn.id
    )
    user = User.create!(
        name: "User",
        cpf: "820.628.780-95",
        email: "user@email.com",
        password: "123456"
      )
    booking = Booking.create!(
      room: room_ocean,
      user: user,
      start_date: 8.days.from_now,
      end_date: 10.days.from_now,
      number_of_guests: 2,
    )

    login_as user, scope: :user
    post cancel_room_booking_path(room_ocean, booking)
    booking.reload

    expect(response).to redirect_to booking_path(booking)
    expect(flash[:notice]).to eq "Reserva cancelada"
    expect(booking.canceled?).to be true
  end
end
