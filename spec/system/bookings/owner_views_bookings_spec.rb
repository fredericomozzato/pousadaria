require "rails_helper"
include ActiveSupport::Testing::TimeHelpers

describe "Proprietário acessa a página de reservas da pousada" do
  it "desautenticado e é redirecionado para log-in" do
    visit bookings_path

    expect(current_path).to eq new_owner_session_path
  end

  it "quando não tem reservas confirmadas" do
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

    expect(page).not_to have_content "Nenhuma reserva encontrada"
    within "section#bookings-list" do
      expect(page).to have_content "Reserva:"
      expect(page).to have_link booking.code
      expect(page).to have_content "Quarto: Oceano"
      expect(page).to have_content "Data de check-in: #{I18n.l(booking.start_date)}"
      expect(page).to have_content "Data de check-out: #{I18n.l(booking.end_date)}"
      expect(page).to have_content "Número de hóspedes: #{booking.number_of_guests}"
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
end
