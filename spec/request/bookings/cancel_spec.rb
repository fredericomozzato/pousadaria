require "rails_helper"

include ActiveSupport::Testing::TimeHelpers

describe "Cancelamento de reserva", type: :request do
  it "com sucesso pelo Proprietário" do
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

  it "sem sucesso pelo Proprietário em uma reserva não ativa" do
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

  it "sem sucesso pelo proprietário em uma reserva que não é de sua pousada" do
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
    inn_2 = Inn.create!(
      name: "Morro Azul",
      corporate_name: "Pousada Da Montanha/RS",
      registration_number: "59.457.495/0001-25",
      phone: "5499999-9999",
      email: "pousadamorroazul@gmail.com",
      description: "Pousada com vista pra montanha.",
      pay_methods: "Crédito, débito, dinheiro ou pix",
      user_policies: "A pousada conta com lei do silêncio das 22h às 8h",
      pet_friendly: true,
      check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
      check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
      owner: owner_2
    )
    Address.create!(
      street: "Rua da Cachoeira",
      number: 560,
      neighborhood: "Zona Rual",
      city: "Cambará do Sul",
      state: "RS",
      postal_code: "77000-000",
      inn: inn_2
    )

    login_as owner_2
    post cancel_room_booking_path(inn_1_room_1, booking_1)

    expect(response).to redirect_to root_path
    expect(flash[:alert]).to eq "Página não encontrada"
    expect(booking_1.canceled?).to be false
  end

  it "com sucesso pelo Usuário" do
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

  it "sem sucesso pelo Usuário com data de cancelamento ultrapassada" do
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
      start_date: 5.days.from_now,
      end_date: 10.days.from_now,
      number_of_guests: 2,
    )

    login_as user, scope: :user
    post cancel_room_booking_path(room_ocean, booking)

    expect(response).to redirect_to booking_path(booking)
    expect(flash[:alert]).to eq "Não foi possível cancelar a reserva"
    expect(booking.canceled?).to be false
  end


end
