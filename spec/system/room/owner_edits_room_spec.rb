require "rails_helper"

describe "Proprietário acessa página de quartos" do
  it "e acessa o formulário de edição de um quarto" do
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

    login_as(owner)
    visit rooms_path
    click_on "Oceano"
    click_on "Editar Quarto"

    expect(page).to have_field "Nome", with: "Oceano"
    expect(page).to have_field "Descrição", with: "Quarto com vista para o mar"
    expect(page).to have_field "Tamanho (m²)", with: 30
    expect(page).to have_field "Número máximo de hóspedes", with: 2
    expect(page).to have_field "Valor da diária", with: 200.00
    expect(page).to have_unchecked_field "Banheiro privativo"
    expect(page).to have_unchecked_field "Varanda"
    expect(page).to have_unchecked_field "Ar-condicionado"
    expect(page).to have_unchecked_field "Guarda-roupas"
    expect(page).to have_unchecked_field "Acessibilidade"
    expect(page).to have_unchecked_field "Wi-fi"
    expect(page).to have_button "Salvar Quarto"
    expect(page).to have_button "Desativar Quarto"
  end

  it "e edita um quarto com sucesso" do
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

    login_as(owner)
    visit rooms_path
    click_on "Montanha"
    click_on "Editar Quarto"

    fill_in "Valor da diária", with: 300.00
    check "Ar-condicionado"
    check "Wi-fi"
    click_on "Salvar Quarto"

    expect(page).to have_content "Quarto atualizado com sucesso!"
    expect(page).to have_content "Valor da diária: R$ 300,00"
    expect(page).to have_content "Ar-condicionado: sim"
    expect(page).to have_content "Wi-fi: sim"
  end

  it "e não consegue editar um quarto com valores inválidos" do
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

    login_as owner
    visit rooms_path
    click_on "Oceano"
    click_on "Editar Quarto"
    fill_in "Nome", with: ""
    fill_in "Valor da diária", with: -50.00
    fill_in "Tamanho (m²)", with: ""
    fill_in "Número máximo de hóspedes", with: 0
    click_on "Salvar Quarto"

    expect(page).to have_content "Erro ao atualizar quarto!"
    expect(page).to have_content "Nome não pode ficar em branco"
    expect(page).to have_content "Valor da diária deve ser maior que 0"
    expect(page).to have_content "Tamanho (m²) não pode ficar em branco"
    expect(page).to have_content "Número máximo de hóspedes deve ser maior que 0"
  end

  it "e o indisponibiliza para reservas" do
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

    login_as owner
    visit rooms_path
    click_on "Oceano"
    click_on "Editar Quarto"
    uncheck "Disponível para reservas"
    click_on "Salvar Quarto"

    expect(page).to have_content "Quarto atualizado com sucesso!"
    expect(page).to have_content "Quarto: Oceano"
    expect(page).to have_content "Disponível para reservas: não"
  end

  it "e o disponibiliza para reservas" do
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
    room_mountain = Room.create!(
      name: "Montanha",
      description: "Quarto com vista para a montanha",
      size: 25,
      max_guests: 4,
      price: 250.00,
      inn_id: inn.id,
      active: false
    )

    login_as owner
    visit rooms_path
    click_on "Montanha"
    click_on "Editar Quarto"
    check "Disponível para reservas"
    click_on "Salvar Quarto"

    expect(page).to have_content "Quarto atualizado com sucesso!"
    expect(page).to have_content "Quarto: Montanha"
    expect(page).to have_content "Disponível para reservas: sim"
  end

  it "e não consegue editar um quarto de outro proprietário" do
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
    different_owner = Owner.create!(
      email: "differentowner@example.com",
      password: "123456"
    )
    different_inn = Inn.create!(
      name: "Parador da Montanha",
      corporate_name: "Pousada Montanha/RS",
      registration_number: "54.235.764/0001-84",
      phone: "5499999-9999",
      email: "paradordamontanha@gmail.com",
      description: "Pousada de frente para montanha.",
      pay_methods: "Crédito, débito, dinheiro ou pix",
      user_policies: "Proibido fumar nas dependências da pousada.",
      pet_friendly: false,
      check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
      check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
      owner_id: different_owner.id
    )
    Address.create!(
      street: "Estrada da montanha",
      number: nil,
      neighborhood: "Nova Petrópolis",
      city: "Canela",
      state: "RS",
      postal_code: "32000-000",
      inn_id: different_inn.id
    )

    login_as different_owner
    visit edit_room_path(room_ocean)

    expect(page).to have_content "Você não tem permissão para acessar essa página"
    expect(page).not_to have_field "Nome"
    expect(page).not_to have_field "Descrição"
    expect(page).not_to have_button "Salvar Quarto"
  end

end
