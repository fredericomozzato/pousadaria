require "rails_helper"

describe "Proprietário visita a página de criação de preços sazonais" do
  it "a partir da home" do
    owner = Owner.create!(
      email: "owner@email.com",
      password: "123456"
    )
    inn = Inn.create!(
      name: "Mar Aberto",
      corporate_name: "Pousada Mar Aberto/SC",
      registration_number: "84.485.218/0001-73",
      phone: "9999999994899999-9999",
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
      max_guests: 3,
      price: 225.50,
      inn_id: inn.id
    )

    login_as owner
    visit root_path
    click_on "Minha Pousada"
    click_on "Novo Período Sazonal"

    expect(page).to have_content "Detalhes de Período Sazonal"
    expect(page).to have_content "Quartos disponíveis"
    expect(page).to have_select "seasonal_price_room_id", options: [room_ocean.name, room_field.name]
    expect(page).to have_field "Data de início", type: "date"
    expect(page).to have_field "Data de término", type: "date"
    expect(page).to have_field "Valor da diária", type: "number"
    expect(page).to have_button "Salvar Período Sazonal"
  end

  it "e tem acesso somente a quartos de sua pousada" do
    first_owner = Owner.create!(
      email: "owner@email.com",
      password: "123456"
    )
    first_inn = Inn.create!(
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
    room_ocean = Room.create!(
      name: "Atlântico",
      description: "Quarto com vista para o mar",
      size: 30,
      max_guests: 2,
      price: 200.00,
      inn_id: first_inn.id
    )
    room_pacific = Room.create!(
      name: "Pacífico",
      description: "Quarto com vista para o mar",
      size: 40,
      max_guests: 4,
      price: 300.00,
      inn_id: first_inn.id
    )
    second_owner = Owner.create!(
      email: "secondowner@email.com",
      password: "abcdefg"
    )
    second_inn = Inn.create!(
      name: "Flor do Campo",
      corporate_name: "Pousada Flor do Campo/RS",
      registration_number: "78.745.823/0001-18",
      phone: "45498888-8888",
      email: "flordocampo@gmail.com",
      description: "Pousada campestre.",
      pay_methods: "Crédito, débito, dinheiro ou pix",
      user_policies: "A pousada conta com lei do silêncio das 22h às 8h",
      pet_friendly: true,
      check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
      check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
      owner_id: second_owner.id
    )
    Address.create!(
      street: "Rua do Campo",
      number: 1823,
      neighborhood: "Zona rural",
      city: "Bento Gonçalves",
      state: "RS",
      postal_code: "99000-000",
      inn_id: second_inn.id
    )
    room_mountain = Room.create!(
      name: "Montanha",
      description: "Quarto com vista para a montanha",
      size: 25,
      max_guests: 4,
      price: 250.00,
      inn_id: second_inn.id,
      active: false
    )

    login_as first_owner
    visit new_seasonal_price_path

    expect(page).to have_select "seasonal_price_room_id", options: ["Atlântico", "Pacífico"]
    expect(page).not_to have_select "seasonal_price_room_id", options: ["Montanha"]
  end

  it "e cria um preço sazonal com sucesso" do
    first_owner = Owner.create!(
      email: "owner@email.com",
      password: "123456"
    )
    first_inn = Inn.create!(
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
    room_ocean = Room.create!(
      name: "Atlântico",
      description: "Quarto com vista para o mar",
      size: 30,
      max_guests: 2,
      price: 200.00,
      inn_id: first_inn.id
    )
    room_pacific = Room.create!(
      name: "Pacífico",
      description: "Quarto com vista para o mar",
      size: 40,
      max_guests: 4,
      price: 300.00,
      inn_id: first_inn.id
    )
    second_owner = Owner.create!(
      email: "secondowner@email.com",
      password: "abcdefg"
    )
    second_inn = Inn.create!(
      name: "Flor do Campo",
      corporate_name: "Pousada Flor do Campo/RS",
      registration_number: "78.745.823/0001-18",
      phone: "45498888-8888",
      email: "flordocampo@gmail.com",
      description: "Pousada campestre.",
      pay_methods: "Crédito, débito, dinheiro ou pix",
      user_policies: "A pousada conta com lei do silêncio das 22h às 8h",
      pet_friendly: true,
      check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
      check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
      owner_id: second_owner.id
    )
    Address.create!(
      street: "Rua do Campo",
      number: 1823,
      neighborhood: "Zona rural",
      city: "Bento Gonçalves",
      state: "RS",
      postal_code: "99000-000",
      inn_id: second_inn.id
    )
    room_mountain = Room.create!(
      name: "Montanha",
      description: "Quarto com vista para a montanha",
      size: 25,
      max_guests: 4,
      price: 250.00,
      inn_id: second_inn.id,
      active: false
    )

    login_as first_owner
    visit new_seasonal_price_path
    select "Atlântico", from: "seasonal_price_room_id"
    fill_in "Data de início", with: "26/12/2023"
    fill_in "Data de término", with: "15/01/2024"
    fill_in "Valor da diária", with: 500.00
    click_on "Salvar Período Sazonal"

    expect(page).to have_content "Período Sazonal criado com sucesso"
    expect(page).to have_content "Quarto: Atlântico"
    expect(page).to have_content "Preços Sazonais"
    within "#seasonal-prices" do
      expect(page).to have_content "26/12/2023 - 15/01/2024: R$ 500,00"
    end
  end
end
