require "rails_helper"

describe "Usuário visita uma pousada" do
  it "na lista de pousadas recentes" do
    first_owner = Owner.create!(
        email: "owner@example.com",
        password: "123456"
      )
    first_inn = Inn.create!(
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
      owner_id: first_owner.id
    )
    Address.create!(
      street: "Rua das Flores",
      number: 300,
      neighborhood: "Canasvieiras",
      city: "Florianópolis",
      state: "SC",
      postal_code: "88000-000",
      inn_id: first_inn.id
    )
    second_owner = Owner.create!(
      email: "secondowner@example.com",
      password: "654321"
    )
    second_inn = Inn.create!(
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
      owner_id: second_owner.id
    )
    Address.create!(
      street: "Rua da Cachoeira",
      number: 560,
      neighborhood: "Zona Rual",
      city: "Cambará do Sul",
      state: "RS",
      postal_code: "77000-000",
      inn_id: second_inn.id
    )

    visit root_path
    within "#recent" do
      click_on "Mar Aberto"
    end

    expect(current_path).to eq inn_path(first_inn)
    expect(page).to have_content "Avaliação: Nenhuma avaliação até o momento"
    expect(page).to have_content "Nome: Mar Aberto"
    expect(page).not_to have_content "Razão social: Pousada Mar Aberto/SC"
    expect(page).not_to have_content "CNPJ: 84.485.218/0001-73"
    expect(page).not_to have_content "Status na platafora: Ativa"
    expect(page).to have_content "Telefone: 4899999-9999"
    expect(page).to have_content "E-mail: pousadamaraberto@hotmail.com"
    expect(page).to have_content "Descrição: Pousada na beira do mar com suítes e café da manhã incluso."
    expect(page).to have_content "Métodos de pagamento: Crédito, débito, dinheiro ou pix"
    expect(page).to have_content "Aceita pets: sim"
    expect(page).to have_content "Políticas de uso: A pousada conta com lei do silêncio das 22h às 8h"
    expect(page).to have_content "Horário de check-in: a partir das 9:00"
    expect(page).to have_content "Horário de check-out: até as 15:30"
    expect(page).to have_content "Endereço: Rua das Flores, 300"
    expect(page).to have_content "Canasvieiras - Florianópolis, SC"
    expect(page).to have_content "CEP: 88000-000"
  end

  it "e vê a nota média de avaliações" do
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
    user_1 = User.create!(
      name: "João Silva",
      cpf: "899.924.320-63",
      email: "joao@email.com",
      password: "123456"
    )
    user_2 = User.create!(
      name: "Leila Mattos",
      cpf: "627.201.780-47",
      email: "leila@email.com",
      password: "123456"
    )
    user_3 = User.create!(
      name: "Frederico Mozzato",
      cpf: "890.619.700-40",
      email: "frederico@email.com",
      password: "123456"
    )
    booking_1 = Booking.create!(
      room: room,
      user: user_1,
      start_date: Date.today,
      end_date: 5.days.from_now,
      number_of_guests: 2,
      status: :closed
    )
    booking_2 = Booking.create!(
      room: room,
      user: user_2,
      start_date: Date.today,
      end_date: 2.weeks.from_now,
      number_of_guests: 2,
      status: :closed
    )
    booking_3 = Booking.create!(
      room: room,
      user: user_3,
      start_date: Date.today,
      end_date: 5.days.from_now,
      number_of_guests: 2,
      status: :closed
    )
    review_1 = Review.create!(
      score: 5,
      booking: booking_1
    )
    review_2 = Review.create!(
      score: 2,
      booking: booking_2
    )
    review_3 = Review.create!(
      score: 3,
      booking: booking_3
    )

    visit inn_path(inn)

    expect(page).to have_content "Avaliação: 3.3"
  end

  it "e vê as três últimas avaliações" do
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
    user_1 = User.create!(
      name: "João Silva",
      cpf: "899.924.320-63",
      email: "joao@email.com",
      password: "123456"
    )
    user_2 = User.create!(
      name: "Leila Mattos",
      cpf: "627.201.780-47",
      email: "leila@email.com",
      password: "123456"
    )
    user_3 = User.create!(
      name: "Celso Carvalho",
      cpf: "890.619.700-40",
      email: "frederico@email.com",
      password: "123456"
    )
    booking_1 = Booking.create!(
      room: room,
      user: user_1,
      start_date: Date.today,
      end_date: 5.days.from_now,
      number_of_guests: 2,
      status: :closed
    )
    booking_2 = Booking.create!(
      room: room,
      user: user_2,
      start_date: Date.today,
      end_date: 2.weeks.from_now,
      number_of_guests: 2,
      status: :closed
    )
    booking_3 = Booking.create!(
      room: room,
      user: user_3,
      start_date: Date.today,
      end_date: 5.days.from_now,
      number_of_guests: 2,
      status: :closed
    )
    review_1 = Review.create!(
      score: 5,
      booking: booking_1,
      message: "Ótima pousada, recomendo",
      answer: "Obrigado pela avaliação"
    )
    review_2 = Review.create!(
      score: 2,
      booking: booking_2,
      message: "Péssima pousada, não recomendo",
      answer: "Lamentamos que não tenha gostado"
    )
    review_3 = Review.create!(
      score: 3,
      booking: booking_3,
      message: "Pousada mediana",
      answer: "Obrigado pela avaliação"
    )

    visit inn_path(inn)

    expect(page).to have_content "Avaliação: 3.3"
    expect(page).to have_content "Avaliações recentes"
    expect(page).to have_content "Hóspede: João Silva"
    expect(page).to have_content "Nota: 5"
    expect(page).to have_content "Mensagem: Ótima pousada, recomendo"
    expect(page).to have_content "Resposta do proprietário: Obrigado pela avaliação"
    expect(page).to have_content "Hóspede: Leila Mattos"
    expect(page).to have_content "Nota: 2"
    expect(page).to have_content "Mensagem: Péssima pousada, não recomendo"
    expect(page).to have_content "Resposta do proprietário: Lamentamos que não tenha gostado"
    expect(page).to have_content "Hóspede: Celso Carvalho"
    expect(page).to have_content "Nota: 3"
    expect(page).to have_content "Mensagem: Pousada mediana"
    expect(page).to have_content "Resposta do proprietário: Obrigado pela avaliação"
  end
end
