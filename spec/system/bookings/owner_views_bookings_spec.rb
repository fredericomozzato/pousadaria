require "rails_helper"

include ActiveSupport::Testing::TimeHelpers

describe "Proprietário acessa a página de reservas da pousada" do
  it "desautenticado e é redirecionado para log-in" do
    visit bookings_path

    expect(current_path).to eq new_owner_session_path
  end

  it "e não tem reservas confirmadas" do
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

    login_as owner
    visit root_path
    click_on "Reservas"

    expect(current_path).to eq bookings_path
    expect(page).to have_content "Reservas - Mar Aberto"
    expect(page).to have_content "Nenhuma reserva encontrada"
  end

  it "e vê reservas confirmadas de sua pousada" do
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
    room_mar = Room.create!(
      name: "Mar",
      description: "Quarto com vista para o mar",
      size: 40,
      max_guests: 3,
      price: 300.00,
      inn_id: inn.id
    )
    user_1 = User.create!(
        name: "User 1",
        cpf: "820.628.780-95",
        email: "user1@email.com",
        password: "123456"
      )
    user_2 = User.create!(
      name: "User 2",
        cpf: "432.065.910-40",
        email: "user2@email.com",
        password: "654321"
    )
    booking_1 = Booking.create!(
      room: room_ocean,
      user: user_1,
      start_date: 1.week.from_now,
      end_date: 2.weeks.from_now,
      number_of_guests: 2
    )
    booking_2 = Booking.create!(
      room: room_mar,
      user: user_2,
      start_date: Date.today,
      end_date: 3.days.from_now,
      number_of_guests: 3,
      status: :active
    )

    login_as owner
    visit bookings_path

    expect(page).not_to have_content "Nenhuma reserva encontrada"
    within "section#bookings-list" do
      expect(page).to have_content "Reserva:"
      expect(page).to have_link booking_1.code
      expect(page).to have_content "Quarto: Oceano"
      expect(page).to have_content "Data de check-in: #{I18n.l(booking_1.start_date)}"
      expect(page).to have_content "Data de check-out: #{I18n.l(booking_1.end_date)}"
      expect(page).to have_content "Número de hóspedes: #{booking_1.number_of_guests}"
      expect(page).to have_content "Status: Confirmada"
      expect(page).to have_link booking_2.code
      expect(page).to have_content "Quarto: Mar"
      expect(page).to have_content "Data de check-in: #{I18n.l(booking_2.start_date)}"
      expect(page).to have_content "Data de check-out: #{I18n.l(booking_2.end_date)}"
      expect(page).to have_content "Número de hóspedes: #{booking_2.number_of_guests}"
      expect(page).to have_content "Status: Ativa"
    end
  end

  it "e vê detalhes de uma reserva com check-in desabilitado" do
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
      start_date: 1.week.from_now,
      end_date: 2.weeks.from_now,
      number_of_guests: 2,
    )

    login_as owner
    visit bookings_path
    click_on booking.code

    expect(current_path).to eq booking_path(booking)
    expect(page).to have_content "Detalhes da Reserva"
    expect(page).to have_content "Código: #{booking.code}"
    expect(page).to have_content "Status: Confirmada"
    expect(page).to have_content "Check-in disponível a partir de #{I18n.l(booking.start_date)}"
    expect(page).not_to have_button "REALIZAR CHECK-IN"
    expect(page).not_to have_button "CANCELAR RESERVA"
  end

  it "e vê reserva com check-in habilitado" do
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
    visit bookings_path
    click_on booking.code

    expect(page).not_to have_content "Check-in disponível a partir de #{I18n.l(booking.start_date)}"
    expect(page).to have_button "REALIZAR CHECK-IN"
    expect(page).not_to have_button "CANCELAR RESERVA"
  end

  it "e vê reserva com check-out habilitado" do
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
      status: :active
    )

    login_as owner
    visit active_bookings_path
    click_on booking.code

    expect(page).to have_button "REALIZAR CHECK-OUT"
    expect(page).to have_field "Método de pagamento"
    expect(page).not_to have_button "REALIZAR CHECK-IN"
    expect(page).not_to have_button "CANCELAR RESERVA"
  end

  it "e vê reserva com opção de cancelamento" do
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
      visit bookings_path
      click_on booking.code

      expect(page).to have_button "REALIZAR CHECK-IN"
      expect(page).to have_button "CANCELAR RESERVA"
    end
  end

  it "e não tem estadias ativas" do
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
    visit root_path
    within "#navigation-bar" do
      click_on "Estadias ativas"
    end

    expect(page).to have_content "Nenhuma estadia ativa no momento"
    expect(page).not_to have_link booking.code
  end

  it "e vê lista de estadias ativas" do
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
    user_1 = User.create!(
      name: "User",
      cpf: "820.628.780-95",
      email: "user@email.com",
      password: "123456"
    )
    user_2 = User.create!(
      name: "User 2",
      cpf: "432.065.910-40",
      email: "user_2@email.com",
      password: "123456"
    )
    active_booking = Booking.create!(
      room: room_ocean,
      user: user_1,
      start_date: Date.today,
      end_date: 5.days.from_now,
      number_of_guests: 2,
      status: :active
    )
    confirmed_booking = Booking.create!(
      room: room_ocean,
      user: user_2,
      start_date: 1.week.from_now,
      end_date: 2.weeks.from_now,
      number_of_guests: 1
    )

    login_as owner
    visit root_path
    within "#navigation-bar" do
      click_on "Estadias ativas"
    end

    expect(page).not_to have_content "Nenhuma estadia ativa no momento"
    within "section#active-bookings-list" do
      expect(page).to have_content "Reserva:"
      expect(page).to have_link active_booking.code
      expect(page).to have_content "Quarto: Oceano"
      expect(page).to have_content "Data de check-in: #{I18n.l(Date.today)}"
      expect(page).to have_content "Data de check-out: #{I18n.l(5.days.from_now.to_date)}"
      expect(page).to have_content "Número de hóspedes: 2"
      expect(page).not_to have_link confirmed_booking.code
    end
    expect(page).to have_link "Voltar"
  end

  it "e não vê reserva de outra pousada" do
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
    visit booking_path(booking_1)

    expect(current_path).to eq root_path
    expect(page).to have_content "Não foi possível completar a requisição"
  end
end
