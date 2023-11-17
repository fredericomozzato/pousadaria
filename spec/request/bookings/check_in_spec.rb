require "rails_helper"

include ActiveSupport::Testing::TimeHelpers

describe "Proprietário faz check-in de uma reserva", type: :request do
  it "com sucesso" do
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
    freeze_time do
      post check_in_room_booking_path(room_ocean, booking)
      booking.reload

      expect(response).to redirect_to(booking_path(booking))
      expect(flash[:notice]).to eq("Check-in realizado com sucesso")
      expect(booking.active?).to be true
      expect(booking.check_in).not_to be_nil
      expect(booking.check_in).to eq Time.current
    end
  end

  it "antes da data permitida" do
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
      start_date: 2.days.from_now,
      end_date: 5.days.from_now,
      number_of_guests: 2,
    )

    login_as owner
    freeze_time do
      post check_in_room_booking_path(room_ocean, booking)
      booking.reload

      expect(response).to redirect_to(booking_path(booking))
      expect(flash[:alert]).to eq("Não foi possível realizar o check-in")
      expect(booking.active?).to be false
      expect(booking.check_in).to be_nil
    end
  end

  it "desautenticado" do
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
      start_date: 2.days.from_now,
      end_date: 5.days.from_now,
      number_of_guests: 2,
    )

    post check_in_room_booking_path(room_ocean, booking)

    expect(response).to redirect_to new_owner_session_path
  end
end
