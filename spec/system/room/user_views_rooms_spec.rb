require "rails_helper"

describe "Usuário visita a página de uma pousada" do
  it "e vê os quartos" do
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
      inn_id: inn.id,
      bathroom: true,
      porch: true,
      air_conditioner: true,
      wardrobe: true,
      accessibility: true,
      safe: false,
      wifi: true
    )
    room_mountain = Room.create!(
      name: "Montanha",
      description: "Quarto com vista para a montanha",
      size: 25,
      max_guests: 4,
      price: 250.00,
      inn_id: inn.id,
      active: false
    )
    room_field = Room.create!(
      name: "Campo",
      description: "Quarto com vista para o campo",
      size: 20,
      max_guests: 2,
      price: 225.50,
      inn_id: inn.id,
      bathroom: true,
      porch: true,
      air_conditioner: true
    )

    visit root_path
    click_on "Mar Aberto"
    expect(current_path).to eq inn_path(inn)
    expect(page).to have_content "Mar Aberto"
    expect(page).to have_content "Telefone: 4899999-9999"
    expect(page).to have_content "E-mail: pousadamaraberto@gmail.com"
    expect(page).to have_content "Descrição: Pousada na beira do mar com suítes e café da manhã incluso."
    expect(page).to have_content "Métodos de pagamento: Crédito, débito, dinheiro ou pix"
    expect(page).to have_content "Aceita pets: sim"
    expect(page).to have_content "Políticas de uso: A pousada conta com lei do silêncio das 22h às 8h"
    expect(page).to have_content "Horário de check-in: a partir das 9:00"
    expect(page).to have_content "Horário de check-out: até as 15:00"
    expect(page).to have_content "Rua das Flores, 300"
    expect(page).to have_content "Canasvieiras - Florianópolis, SC"
    expect(page).to have_content "CEP: 88000-000"

    expect(page).to have_content "Quartos disponíveis:"
    within "#rooms-list" do
      expect(page).to have_content "Oceano"
      expect(page).to have_content "Quarto com vista para o mar"
      expect(page).to have_content "Valor da diária: R$ 200,00"

      expect(page).not_to have_content "Montanha"

      expect(page).to have_content "Campo"
      expect(page).to have_content "Quarto com vista para o campo"
      expect(page).to have_content "Valor da diária: R$ 225,50"
    end
  end
end
