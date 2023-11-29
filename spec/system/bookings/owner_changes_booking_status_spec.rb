require "rails_helper"

include ActiveSupport::Testing::TimeHelpers

describe "Proprietário acessa uma reserva" do
  it "e cancela a reserva com sucesso" do
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
      click_on "CANCELAR RESERVA"
      booking.reload
    end

    expect(current_path).to eq booking_path(booking)
    expect(page).to have_content "Reserva cancelada"
    expect(booking.canceled?).to be true
  end

  it "e faz o check-in com sucesso" do
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
    el = find(:css, "input[id$='_guests_guest_0__name']")
    el.set("Fulano de Tal")
    el = find(:css, "input[id$='_guests_guest_0__document']")
    el.set("214.163.580-21")
    el = find(:css, "input[id$='_guests_guest_1__name']")
    el.set("Ciclano de Tal")
    el = find(:css, "input[id$='_guests_guest_1__document']")
    el.set("886.917.530-80")
    click_on "REALIZAR CHECK-IN"
    booking.reload

    expect(page).to have_content "Check-in realizado com sucesso"
    expect(page).to have_content "Status: Ativa"
    expect(page).not_to have_button "REALIZAR CHECK-IN"
    expect(booking.check_in).not_to be nil
  end

  it "e faz o check-out com sucesso" do
    travel_to Time.now.beginning_of_day + 12.hours
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
      check_in_time: Time.new(2000, 1, 1, 14, 0, 0, 'UTC'),
      check_out_time: Time.new(2000, 1, 1, 12, 0, 0, 'UTC'),
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

    travel 5.days do
      login_as owner
      visit bookings_path
      click_on booking.code
      fill_in "Método de pagamento", with: "Cartão de crédito"
      click_on "REALIZAR CHECK-OUT"
    end
    booking.reload

    expect(page).to have_content "Check-out realizado com sucesso"
    expect(page).to have_content "Status: Finalizada"
    expect(page).not_to have_button "REALIZAR CHECK-OUT"
    expect(booking.check_out).not_to be nil
    expect(booking.closed?).to be true
    expect(booking.pay_method).to eq "Cartão de crédito"
    expect(booking.bill).to eq 1000.00
    travel_back
  end
end
