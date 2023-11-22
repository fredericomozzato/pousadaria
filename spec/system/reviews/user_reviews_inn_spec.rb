require "rails_helper"

include ActiveSupport::Testing::TimeHelpers

describe "Usuário acessa a página de avaliação" do
  it "a partir da página inicial" do
    owner = Owner.create!(email: "dono_1@email.com", password: "123456")
    inn = Inn.create!(
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
      owner: owner
    )
    Address.create!(
      street: "Rua das Flores",
      number: 300,
      neighborhood: "Canasvieiras",
      city: "Florianópolis",
      state: "SC",
      postal_code: "88000-000",
      inn: inn
    )
    room = Room.create!(
      name: "Atlântico",
      description: "Quarto com vista para o mar",
      size: 30,
      max_guests: 2,
      price: 200.00,
      inn: inn,
      bathroom: true,
      wifi: true,
      wardrobe: true,
      accessibility: true
    )
    user = User.create!(
      name: "João Silva",
      cpf: "899.924.320-63",
      email: "joao@email.com",
      password: "123456"
    )
    booking = Booking.create!(
      room: room,
      user: user,
      start_date: Date.today,
      end_date: 5.days.from_now,
      number_of_guests: 2,
      status: :active
    )
    booking.closed!
    booking.reload

    login_as user, scope: :user
    visit root_path
    click_on "Minhas Reservas"
    within "#closed-bookings" do
      click_on booking.code
    end
    click_on "Avaliar"

    expect(page).to have_content "Avalie sua estadia"
    expect(page).to have_content "Mar Aberto"
    expect(page).to have_content "Nota"
    expect(page).to have_content "0"
    expect(page).to have_content "1"
    expect(page).to have_content "2"
    expect(page).to have_content "3"
    expect(page).to have_content "4"
    expect(page).to have_content "5"
    expect(page).to have_field "Mensagem"
    expect(page).to have_button "Enviar"
    expect(page).to have_link "Voltar"
  end

  it "e cria uma avaliação" do
    owner = Owner.create!(email: "dono_1@email.com", password: "123456")
    inn = Inn.create!(
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
      owner: owner
    )
    Address.create!(
      street: "Rua das Flores",
      number: 300,
      neighborhood: "Canasvieiras",
      city: "Florianópolis",
      state: "SC",
      postal_code: "88000-000",
      inn: inn
    )
    room = Room.create!(
      name: "Atlântico",
      description: "Quarto com vista para o mar",
      size: 30,
      max_guests: 2,
      price: 200.00,
      inn: inn,
      bathroom: true,
      wifi: true,
      wardrobe: true,
      accessibility: true
    )
    user = User.create!(
      name: "João Silva",
      cpf: "899.924.320-63",
      email: "joao@email.com",
      password: "123456"
    )
    booking = Booking.create!(
      room: room,
      user: user,
      start_date: Date.today,
      end_date: 5.days.from_now,
      number_of_guests: 2,
      status: :active
    )
    booking.closed!
    booking.reload

    login_as user, scope: :user
    visit root_path
    click_on "Minhas Reservas"
    within "#closed-bookings" do
      click_on booking.code
    end
    click_on "Avaliar"
    choose "review_score_5"
    fill_in "Mensagem", with: "Excelente estadia, muito aconchegante"
    click_on "Enviar"

    expect(current_path).to eq booking_path(booking)
    expect(page).to have_content "Avaliação"
    expect(page).to have_content "Nota: 5"
    expect(page).to have_content "Mensagem: Excelente estadia, muito aconchegante"
    expect(page).to have_content "Nenhuma resposta"
  end

end
