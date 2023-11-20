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
    click_on "Oceano"
    click_on "Novo Preço Sazonal"

    expect(page).to have_content "Detalhes de Preço Sazonal:"
    expect(page).to have_field "Data de início", type: "date"
    expect(page).to have_field "Data de término", type: "date"
    expect(page).to have_field "Valor da diária", type: "number"
    expect(page).to have_button "Criar Preço Sazonal"
  end

  it "e cria um preço sazonal com sucesso" do
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
    room_atlantico = Room.create!(
      name: "Atlântico",
      description: "Quarto com vista para o mar",
      size: 30,
      max_guests: 2,
      price: 200.00,
      inn_id: inn.id
    )
    room_pacific = Room.create!(
      name: "Pacífico",
      description: "Quarto com vista para o mar",
      size: 40,
      max_guests: 4,
      price: 300.00,
      inn_id: inn.id
    )

    login_as owner
    visit my_inn_path
    click_on "Pacífico"
    click_on "Novo Preço Sazonal"
    fill_in "Data de início", with: 1.week.from_now
    fill_in "Data de término", with: 2.weeks.from_now
    fill_in "Valor da diária", with: 500.00
    click_on "Criar Preço Sazonal"

    expect(page).to have_content "Preço Sazonal criado com sucesso"
    expect(page).to have_content "Quarto: Pacífico"
    expect(page).to have_content "Preços Sazonais"
    within "#seasonal-prices" do
      expect(page).to have_content "#{1.week.from_now.strftime("%d/%m/%Y")} - #{2.weeks.from_now.strftime("%d/%m/%Y")} | R$ 500,00"
    end
  end

  it "e não cria um preço sazonal com data de término antes da data de início" do
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
      street: "Rua Teste",
      number: "10",
      neighborhood: "Bairro Teste",
      city: "Teste",
      state: "SC",
      postal_code: "88888888",
      inn: inn
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
    visit my_inn_path
    click_on "Oceano"
    click_on "Novo Preço Sazonal"
    fill_in "Data de início", with: "2023-12-25"
    fill_in "Data de término", with: "2023-01-15"
    fill_in "Valor da diária", with: 500.00
    click_on "Criar Preço Sazonal"

    expect(page).to have_content "Erro ao criar Preço Sazonal"
    expect(page).to have_content "Data de início não pode ser antes da data de término"
    expect(page).to have_field "Data de início", with: "2023-12-25"
    expect(page).to have_field "Data de término", with: "2023-01-15"
    expect(page).to have_field "Valor da diária", with: "500.0"
  end

  it "e não cria um preço sazonal com data de término no passado" do
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
    visit my_inn_path
    click_on "Montanha"
    click_on "Novo Preço Sazonal"
    fill_in "Data de início", with: 1.week.ago
    fill_in "Data de término", with: 2.days.ago
    fill_in "Valor da diária", with: 300.99
    click_on "Criar Preço Sazonal"

    expect(page).to have_content "Erro ao criar Preço Sazonal"
    expect(page).to have_content "Data de término não pode estar no passado"
    expect(page).to have_field "Data de início", with: 1.week.ago.strftime("%Y-%m-%d")
    expect(page).to have_field "Data de término", with: 2.days.ago.strftime("%Y-%m-%d")
    expect(page).to have_field "Valor da diária", with: "300.99"
  end

  it "e não cria um preço sazonal com data de início sobreposta a outro" do
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
    )
    room_field = Room.create!(
      name: "Campo",
      description: "Quarto com vista para o campo",
      size: 20,
      max_guests: 3,
      price: 225.50,
      inn_id: inn.id
    )
    SeasonalPrice.create!(
      room_id: room_mountain.id,
      start: 1.week.from_now,
      end: 3.weeks.from_now,
      price: 200
    )
    SeasonalPrice.create!(
      room_id: room_mountain.id,
      start: 5.week.from_now,
      end: 6.weeks.from_now,
      price: 450
    )

    login_as owner
    visit my_inn_path
    click_on "Montanha"
    click_on "Novo Preço Sazonal"
    fill_in "Data de início", with: 2.weeks.from_now
    fill_in "Data de término", with: 4.weeks.from_now
    fill_in "Valor da diária", with: 250.50
    click_on "Criar Preço Sazonal"

    expect(page).to have_content "Erro ao criar Preço Sazonal"
    expect(page).to have_content "Data de início conflita com outro preço sazonal"
  end

  it "e não cria um Preço Sazonal com data de término sobreposta a outro" do
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
    )
    room_field = Room.create!(
      name: "Campo",
      description: "Quarto com vista para o campo",
      size: 20,
      max_guests: 3,
      price: 225.50,
      inn_id: inn.id
    )
    SeasonalPrice.create!(
      room_id: room_mountain.id,
      start: 1.week.from_now,
      end: 3.weeks.from_now,
      price: 200
    )
    SeasonalPrice.create!(
      room_id: room_mountain.id,
      start: 5.week.from_now,
      end: 6.weeks.from_now,
      price: 450
    )

    login_as owner
    visit my_inn_path
    click_on "Montanha"
    click_on "Novo Preço Sazonal"
    fill_in "Data de início", with: 1.day.from_now
    fill_in "Data de término", with: 1.week.from_now
    fill_in "Valor da diária", with: 150.00
    click_on "Criar Preço Sazonal"

    expect(page).to have_content "Erro ao criar Preço Sazonal"
    expect(page).to have_content "Data de término conflita com outro preço sazonal"
  end
end
