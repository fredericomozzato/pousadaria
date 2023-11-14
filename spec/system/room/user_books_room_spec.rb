require "rails_helper"

describe "Usuário visita a página de uma pousada" do
  it "e vê a página de detalhes de reserva" do
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

    visit root_path
    click_on "Mar Aberto"
    click_on "Oceano"
    click_on "Reservar"

    expect(page).to have_content "Detalhes da reserva"
    expect(page).to have_content "Pousada: Mar Aberto"
    expect(page).to have_content "Quarto: Oceano"
    expect(page).to have_field "Data de Check-in", type: "date"
    expect(page).to have_field "Data de Check-out", type: "date"
    expect(page).to have_field "Número de hóspedes", type: "number"
    expect(page).to have_button "Avançar"
    expect(page).to have_link "Voltar"
  end
end
