require "rails_helper"

describe "Usuário acessa o formulário de busca avançada" do
  it "a partir da página inicial" do
    visit root_path
    within "#navigation-bar" do
      click_on "Busca avançada"
    end

    expect(current_path).to eq advanced_search_inns_path
    within "h1" do
      expect(page).to have_content "Busca avançada"
    end
    expect(page).to have_field "Nome"
    expect(page).to have_field "Cidade"
    expect(page).to have_field "Aceita pets", type:"checkbox"
    expect(page).to have_field "Acessível para PCD", type:"checkbox"
    expect(page).to have_field "Wi-fi", type:"checkbox"
    expect(page).to have_field "Banheiro privativo", type:"checkbox"
    expect(page).to have_field "Ar-condicionado", type:"checkbox"
    expect(page).to have_field "Guarda-roupas", type:"checkbox"
    expect(page).to have_field "TV", type:"checkbox"
    expect(page).to have_field "Varanda", type:"checkbox"
    expect(page).to have_field "Cofre", type:"checkbox"
    within "#advanced-search-form" do
      expect(page).to have_button "Buscar"
    end
  end

  it "e encontra uma pousada" do
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
      wifi: true,
      porch: true
    )
    second_owner = Owner.create!(
      email: "fourthowner@example.com",
      password: "xyzpqr"
    )
    second_inn = Inn.create!(
      name: "Lage da Pedra",
      corporate_name: "Pousada Lage da Pedra",
      registration_number: "09.167.769/0001-73",
      phone: "3499999-9999",
      email: "lagedapedra@gmail.com",
      description: "Pousada com cachoeiras.",
      pay_methods: "Crédito, débito, dinheiro ou pix",
      user_policies: "A pousada conta com lei do silêncio das 22h às 8h",
      pet_friendly: false,
      check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
      check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
      owner_id: second_owner.id
    )
    Address.create!(
      street: "Servidão da Cachoeira",
      number: 32,
      neighborhood: "Morro da Pedra",
      city: "Uberlândia",
      state: "MG",
      postal_code: "33000-000",
      inn_id: second_inn.id
    )
    room_cachoeira = Room.create!(
      name: "Cachoeira",
      description: "Quarto com vista para a cachoeira",
      size: 30,
      max_guests: 2,
      price: 200.00,
      inn_id: second_inn.id,
    )


    visit advanced_search_inns_path
    fill_in "Nome", with: ""
    fill_in "Cidade", with: ""
    check "Aceita pets"
    check "Wi-fi"
    check "Banheiro privativo"
    check "Varanda"
    within "#advanced-search-form" do
        click_on "Buscar"
    end

    expect(page).to have_content "Resultados: 1"
    expect(page).to have_link "Mar Aberto"
  end
end
