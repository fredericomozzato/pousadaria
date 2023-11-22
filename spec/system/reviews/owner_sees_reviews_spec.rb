require "rails_helper"

describe "Proprietário acessa página de avaliações de sua pousada" do
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
      status: :closed
    )
    review = Review.create!(
      score: 5,
      message: "Ótima pousada",
      booking: booking
    )

    login_as owner, scope: :owner
    visit root_path
    click_on "Avaliações"

    expect(page).to have_content "Avaliações - Mar Aberto"
    within "section#reviews-list" do
      expect(page).to have_content "Reserva:"
      expect(page).to have_link booking.code
      expect(page).to have_content "Hóspede: João Silva"
      expect(page).to have_content "Nota: 5"
      expect(page).to have_content "Mensagem: Ótima pousada"
      expect(page).to have_content "Sem resposta"
    end
    expect(page).to have_link "Voltar"
  end

  it ", acessa uma reserva com avaliação e vê o formulário de resposta" do
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
      status: :closed
    )
    review = Review.create!(
      score: 5,
      message: "Ótima pousada",
      booking: booking
    )

    login_as owner, scope: :owner
    visit root_path
    click_on "Avaliações"
    click_on booking.code

    expect(page).not_to have_content "Nenhuma resposta"
    expect(page).to have_content "Deixe uma resposta para a avaliação"
    within "div#answer-form" do
      expect(page).to have_field "Resposta"
      expect(page).to have_button "Enviar"
    end
  end

  it "e responde a avaliação" do
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
      status: :closed
    )
    review = Review.create!(
      score: 5,
      message: "Ótima pousada",
      booking: booking
    )

    login_as owner, scope: :owner
    visit reviews_path
    click_on booking.code
    within "div#answer-form" do
      fill_in "Resposta", with: "Obrigado João, serão sempre bem vindos! Um abraço"
      click_on "Enviar"
    end


    expect(page).to have_content "Resposta salva com sucesso"
    expect(page).to have_content "Resposta: Obrigado João, serão sempre bem vindos! Um abraço"
    expect(page).not_to have_content "Deixe uma resposta para a avaliação"
    expect(page).not_to have_field "Resposta"
    expect(page).not_to have_button "Enviar"
  end
end
