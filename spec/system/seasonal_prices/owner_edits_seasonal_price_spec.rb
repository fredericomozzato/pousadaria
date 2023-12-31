require "rails_helper"

describe "Proprietário acessa a página de um Preço Sazonal" do
  it "e vê o formulário" do
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
    seasonal_price = SeasonalPrice.create!(
      room_id: room_ocean.id,
      start: 1.week.from_now,
      end: 2.weeks.from_now,
      price: 450.00
    )

    login_as owner
    visit root_path
    click_on "Minha Pousada"
    click_on "Oceano"
    within "#seasonal-prices" do
      click_on seasonal_price.date_pretty_print
    end

    expect(page).to have_content "Editar Preço"
    expect(page).to have_field "Data de início", with: seasonal_price.start
    expect(page).to have_field "Data de término", with: seasonal_price.end
    expect(page).to have_field "Valor da diária", with: 450.0
  end

  it "e edita o Preço Sazonal com sucesso" do
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
    first_seasonal_price = SeasonalPrice.create!(
      room_id: room_ocean.id,
      start: 1.week.from_now,
      end: 2.weeks.from_now,
      price: 450.00
    )
    second_seasonal_price = SeasonalPrice.create!(
      room_id: room_ocean.id,
      start: 6.weeks.from_now,
      end: 8.weeks.from_now,
      price: 150.00
    )

    login_as owner
    visit edit_seasonal_price_path second_seasonal_price
    fill_in "Data de início", with: 5.weeks.from_now
    fill_in "Data de término", with: 7.weeks.from_now
    fill_in "Valor da diária", with: 250.00
    click_on "Atualizar Preço Sazonal"

    expect(page).to have_content "Preço Sazonal atualizado com sucesso"
    expect(page).to have_content "#{5.weeks.from_now.strftime("%d/%m/%Y")} - #{7.weeks.from_now.strftime("%d/%m/%Y")}"
    expect(page).to have_content "R$ 250,00"
  end

  it "e exclui um preço sazonal" do
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
    first_seasonal_price = SeasonalPrice.create!(
      room_id: room_ocean.id,
      start: 1.week.from_now,
      end: 2.weeks.from_now,
      price: 450.00
    )
    second_seasonal_price = SeasonalPrice.create!(
      room_id: room_ocean.id,
      start: 6.weeks.from_now,
      end: 8.weeks.from_now,
      price: 150.00
    )

    login_as owner
    visit edit_seasonal_price_path second_seasonal_price
    click_on "Excluir"

    expect(page).to have_content "Preço Sazonal excluído com sucesso"
    expect(page).to have_content first_seasonal_price.date_pretty_print
    expect(page).not_to have_content second_seasonal_price.date_pretty_print
  end

  it "que não pertence a um quarto de sua pousada" do
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
    seasonal_price = SeasonalPrice.create!(
      room_id: room_ocean.id,
      start: 1.week.from_now,
      end: 2.weeks.from_now,
      price: 450.00
    )
    second_owner = Owner.create!(
      email: "secondowner@email.com",
      password: "654321"
    )
    second_inn = Inn.create!(
      name: "Da Montanha",
      corporate_name: "Pousada Da Montanha/RS",
      registration_number: "59.457.495/0001-25",
      phone: "5499999-9999",
      email: "pousadadamontanha@gmail.com",
      description: "Pousada com vista pra monanha.",
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

    login_as second_owner
    visit edit_seasonal_price_path seasonal_price
    expect(page).to have_content "Página não encontrada"
    expect(current_path).to eq root_path
  end
end
