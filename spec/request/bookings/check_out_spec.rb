require "rails_helper"

include ActiveSupport::Testing::TimeHelpers

describe "Proprietário faz check-out de uma reserva", type: :request do
  it "com sucesso" do
    owner_1 = Owner.create!(email: "dono_1@email.com", password: "123456")
    inn_1 = Inn.create!(
      name: "Mar Aberto",
      corporate_name: "Pousada Mar Aberto/SC",
      registration_number: "84.485.218/0001-73",
      phone: "4899999-9999",
      email: "pousadamaraberto@hotmail.com",
      description: "Pousada na beira do mar com suítes e café da manhã incluso.",
      pay_methods: "Crédito, débito, dinheiro ou pix",
      pet_friendly: true,
      user_policies: "A pousada conta com lei do silêncio das 22h às 8h",
      check_in_time: Time.new(2000, 1, 1, 9, 0, 0, "UTC"),
      check_out_time: Time.new(2000, 1, 1, 15, 30, 0, "UTC"),
      owner: owner_1
    )
    Address.create!(
      street: "Rua das Flores",
      number: 300,
      neighborhood: "Canasvieiras",
      city: "Florianópolis",
      state: "SC",
      postal_code: "88000-000",
      inn: inn_1
    )
    inn_1_room_1 = Room.create!(
      name: "Atlântico",
      description: "Quarto com vista para o mar",
      size: 30,
      max_guests: 2,
      price: 200.00,
      inn: inn_1,
      bathroom: true,
      wifi: true,
      wardrobe: true,
      accessibility: true
    )
    user_1 = User.create!(
      name: "João Silva",
      cpf: "899.924.320-63",
      email: "joao@email.com",
      password: "123456"
    )
    booking_1 = Booking.create!(
      room: inn_1_room_1,
      user: user_1,
      start_date: Date.today,
      end_date: 5.days.from_now,
      number_of_guests: 2,
      status: :active
    )

    login_as owner_1, scope: :owner
    post check_out_room_booking_path(inn_1_room_1, booking_1)
    booking_1.reload

    expect(response).to redirect_to booking_path(booking_1)
    expect(flash[:notice]).to eq "Check-out realizado com sucesso"
    expect(booking_1.closed?).to be true
  end

  it "sem sucesso em uma reserva não ativa" do
    owner_1 = Owner.create!(email: "dono_1@email.com", password: "123456")
    inn_1 = Inn.create!(
      name: "Mar Aberto",
      corporate_name: "Pousada Mar Aberto/SC",
      registration_number: "84.485.218/0001-73",
      phone: "4899999-9999",
      email: "pousadamaraberto@hotmail.com",
      description: "Pousada na beira do mar com suítes e café da manhã incluso.",
      pay_methods: "Crédito, débito, dinheiro ou pix",
      pet_friendly: true,
      user_policies: "A pousada conta com lei do silêncio das 22h às 8h",
      check_in_time: Time.new(2000, 1, 1, 9, 0, 0, "UTC"),
      check_out_time: Time.new(2000, 1, 1, 15, 30, 0, "UTC"),
      owner: owner_1
    )
    Address.create!(
      street: "Rua das Flores",
      number: 300,
      neighborhood: "Canasvieiras",
      city: "Florianópolis",
      state: "SC",
      postal_code: "88000-000",
      inn: inn_1
    )
    inn_1_room_1 = Room.create!(
      name: "Atlântico",
      description: "Quarto com vista para o mar",
      size: 30,
      max_guests: 2,
      price: 200.00,
      inn: inn_1,
      bathroom: true,
      wifi: true,
      wardrobe: true,
      accessibility: true
    )
    user_1 = User.create!(
      name: "João Silva",
      cpf: "899.924.320-63",
      email: "joao@email.com",
      password: "123456"
    )
    booking_1 = Booking.create!(
      room: inn_1_room_1,
      user: user_1,
      start_date: Date.today,
      end_date: 5.days.from_now,
      number_of_guests: 2,
      status: :confirmed
    )

    login_as owner_1, scope: :owner
    post check_out_room_booking_path(inn_1_room_1, booking_1)
    booking_1.reload

    expect(response).to redirect_to booking_path(booking_1)
    expect(flash[:alert]).to eq "Não foi possível realizar o check-out"
    expect(booking_1.closed?).to be false
  end

  it "sem sucesso em uma reserva que não é de sua pousada" do
    owner_1 = Owner.create!(email: "dono_1@email.com", password: "123456")
    inn_1 = Inn.create!(
      name: "Mar Aberto",
      corporate_name: "Pousada Mar Aberto/SC",
      registration_number: "84.485.218/0001-73",
      phone: "4899999-9999",
      email: "pousadamaraberto@hotmail.com",
      description: "Pousada na beira do mar com suítes e café da manhã incluso.",
      pay_methods: "Crédito, débito, dinheiro ou pix",
      pet_friendly: true,
      user_policies: "A pousada conta com lei do silêncio das 22h às 8h",
      check_in_time: Time.new(2000, 1, 1, 9, 0, 0, "UTC"),
      check_out_time: Time.new(2000, 1, 1, 15, 30, 0, "UTC"),
      owner: owner_1
    )
    Address.create!(
      street: "Rua das Flores",
      number: 300,
      neighborhood: "Canasvieiras",
      city: "Florianópolis",
      state: "SC",
      postal_code: "88000-000",
      inn: inn_1
    )
    inn_1_room_1 = Room.create!(
      name: "Atlântico",
      description: "Quarto com vista para o mar",
      size: 30,
      max_guests: 2,
      price: 200.00,
      inn: inn_1,
      bathroom: true,
      wifi: true,
      wardrobe: true,
      accessibility: true
    )
    user_1 = User.create!(
      name: "João Silva",
      cpf: "899.924.320-63",
      email: "joao@email.com",
      password: "123456"
    )
    booking_1 = Booking.create!(
      room: inn_1_room_1,
      user: user_1,
      start_date: Date.today,
      end_date: 5.days.from_now,
      number_of_guests: 2,
      status: :active
    )
    owner_2 = Owner.create!(email: "dono_2@email.com", password: "654321")

    login_as owner_2, scope: :owner
    post check_out_room_booking_path(inn_1_room_1, booking_1)
    booking_1.reload

    expect(response).to redirect_to root_path
    expect(flash[:alert]).to eq "Não foi possível completar a requisição"
    expect(booking_1.closed?).to be false
  end

  it "sem sucesso quando não autenticado" do
    owner_1 = Owner.create!(email: "dono_1@email.com", password: "123456")
    inn_1 = Inn.create!(
      name: "Mar Aberto",
      corporate_name: "Pousada Mar Aberto/SC",
      registration_number: "84.485.218/0001-73",
      phone: "4899999-9999",
      email: "pousadamaraberto@hotmail.com",
      description: "Pousada na beira do mar com suítes e café da manhã incluso.",
      pay_methods: "Crédito, débito, dinheiro ou pix",
      pet_friendly: true,
      user_policies: "A pousada conta com lei do silêncio das 22h às 8h",
      check_in_time: Time.new(2000, 1, 1, 9, 0, 0, "UTC"),
      check_out_time: Time.new(2000, 1, 1, 15, 30, 0, "UTC"),
      owner: owner_1
    )
    Address.create!(
      street: "Rua das Flores",
      number: 300,
      neighborhood: "Canasvieiras",
      city: "Florianópolis",
      state: "SC",
      postal_code: "88000-000",
      inn: inn_1
    )
    inn_1_room_1 = Room.create!(
      name: "Atlântico",
      description: "Quarto com vista para o mar",
      size: 30,
      max_guests: 2,
      price: 200.00,
      inn: inn_1,
      bathroom: true,
      wifi: true,
      wardrobe: true,
      accessibility: true
    )
    user_1 = User.create!(
      name: "João Silva",
      cpf: "899.924.320-63",
      email: "joao@email.com",
      password: "123456"
    )
    booking_1 = Booking.create!(
      room: inn_1_room_1,
      user: user_1,
      start_date: Date.today,
      end_date: 5.days.from_now,
      number_of_guests: 2,
      status: :active
    )

    post check_out_room_booking_path(inn_1_room_1, booking_1)
    booking_1.reload

    expect(response).to redirect_to new_owner_session_path
    expect(booking_1.closed?).to be false
  end
end
