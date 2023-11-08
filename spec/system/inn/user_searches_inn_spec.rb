require "rails_helper"

describe "Usuário usa o campo de buscas" do
  it "e pesquisa pousadas por cidade" do
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
    third_owner = Owner.create!(
      email: "thirdowner@example.com",
      password: "abcdefg"
    )
    third_inn = Inn.create!(
      name: "Ilha da Magia",
      corporate_name: "Pousada Ilha da Magia Floripa",
      registration_number: "81.289.700/0001-40",
      phone: "48829999-9999",
      email: "pousadailhadamagia@gmail.com",
      description: "Pousada na Ilha da Magia.",
      pay_methods: "Crédito, débito, dinheiro ou pix",
      user_policies: "A pousada conta com lei do silêncio das 22h às 8h",
      pet_friendly: false,
      check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
      check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
      owner_id: third_owner.id
    )
    Address.create!(
      street: "Rua da Praia",
      number: 190,
      neighborhood: "Campeche",
      city: "Florianópolis",
      state: "SC",
      postal_code: "88800-000",
      inn_id: third_inn.id
    )
    fourth_owner = Owner.create!(
      email: "fourthowner@example.com",
      password: "xyzpqr"
    )
    fourth_inn = Inn.create!(
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
      owner_id: fourth_owner.id
    )
    Address.create!(
      street: "Servidão da Cachoeira",
      number: 32,
      neighborhood: "Morro da Pedra",
      city: "Uberlândia",
      state: "MG",
      postal_code: "33000-000",
      inn_id: fourth_inn.id
    )
    fifth_owner = Owner.create!(
      email: "fifthowner@example.com",
      password: "ghijklm"
    )
    fifth_inn = Inn.create!(
      name: "Pousada da Mata",
      corporate_name: "Paradouro Silva e Compania",
      registration_number: "70.816.898/0001-56",
      phone: "349899999999",
      email: "pousadasilva@example.com",
      description: "Pousada na zona da mata.",
      pay_methods: "Somente dinheiro",
      user_policies: "Proíbida a entrada de animais de estimação",
      pet_friendly: false,
      check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
      check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
      owner_id: fifth_owner.id,
      active: false
    )
    Address.create!(
      street: "Rua da Mata",
      number: 18,
      neighborhood: "Cachoeirinha",
      city: "Uberlândia",
      state: "MG",
      postal_code: "00330-000",
      inn_id: fifth_inn.id
    )

    visit root_path
    within "#navigation-bar" do
      fill_in "Buscar Pousada", with: "Florianópolis"
      click_on "Buscar"
    end

    expect(page).to have_content "Busca por: Florianópolis"
    expect(page).to have_content "Resultados: 2"
    expect(page).to have_link "Ilha da Magia"
    expect(page).to have_link "Mar Aberto"
    expect(page).not_to have_link "Morro Azul"
    expect(page).not_to have_link "Pousada da Mata"
    expect("Ilha da Magia").to appear_before "Mar Aberto"
  end

  it "e pesquisa pousadas por nome a partir da tela de uma pousada" do
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
    third_owner = Owner.create!(
      email: "thirdowner@example.com",
      password: "abcdefg"
    )
    third_inn = Inn.create!(
      name: "Ilha da Magia",
      corporate_name: "Pousada Ilha da Magia Floripa",
      registration_number: "81.289.700/0001-40",
      phone: "48829999-9999",
      email: "pousadailhadamagia@gmail.com",
      description: "Pousada na Ilha da Magia.",
      pay_methods: "Crédito, débito, dinheiro ou pix",
      user_policies: "A pousada conta com lei do silêncio das 22h às 8h",
      pet_friendly: false,
      check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
      check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
      owner_id: third_owner.id
    )
    Address.create!(
      street: "Rua da Praia",
      number: 190,
      neighborhood: "Campeche",
      city: "Florianópolis",
      state: "SC",
      postal_code: "88800-000",
      inn_id: third_inn.id
    )
    fourth_owner = Owner.create!(
      email: "fourthowner@example.com",
      password: "xyzpqr"
    )
    fourth_inn = Inn.create!(
      name: "Ilha da Pedra",
      corporate_name: "Pousada Ilha da Pedra",
      registration_number: "09.167.769/0001-73",
      phone: "3499999-9999",
      email: "ilhadapedra@gmail.com",
      description: "Pousada com cachoeiras.",
      pay_methods: "Crédito, débito, dinheiro ou pix",
      user_policies: "A pousada conta com lei do silêncio das 22h às 8h",
      pet_friendly: false,
      check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
      check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
      owner_id: fourth_owner.id
    )
    Address.create!(
      street: "Servidão da Cachoeira",
      number: 32,
      neighborhood: "Morro da Pedra",
      city: "Uberlândia",
      state: "MG",
      postal_code: "33000-000",
      inn_id: fourth_inn.id
    )
    fifth_owner = Owner.create!(
      email: "fifthowner@example.com",
      password: "ghijklm"
    )
    fifth_inn = Inn.create!(
      name: "Pousada da Mata",
      corporate_name: "Paradouro Silva e Compania",
      registration_number: "70.816.898/0001-56",
      phone: "349899999999",
      email: "pousadasilva@example.com",
      description: "Pousada na zona da mata.",
      pay_methods: "Somente dinheiro",
      user_policies: "Proíbida a entrada de animais de estimação",
      pet_friendly: false,
      check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
      check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
      owner_id: fifth_owner.id,
      active: false
    )
    Address.create!(
      street: "Rua da Mata",
      number: 18,
      neighborhood: "Cachoeirinha",
      city: "Uberlândia",
      state: "MG",
      postal_code: "00330-000",
      inn_id: fifth_inn.id
    )

    visit inn_path(second_inn)
    within "#navigation-bar" do
        fill_in "Buscar Pousada", with: "ilha"
        click_on "Buscar"
    end

    expect(page).to have_link "Ilha da Magia"
    expect(page).to have_link "Ilha da Pedra"
    expect("Ilha da Magia").to appear_before("Ilha da Pedra")
  end

  it "e não encontra uma pousada inativa" do
    active_owner = Owner.create!(
      email: "activeowner@example.com",
      password: "abcdefg"
    )
    active_inn = Inn.create!(
      name: "Ilha da Magia",
      corporate_name: "Pousada Ilha da Magia Floripa",
      registration_number: "81.289.700/0001-40",
      phone: "48829999-9999",
      email: "pousadailhadamagia@gmail.com",
      description: "Pousada na Ilha da Magia.",
      pay_methods: "Crédito, débito, dinheiro ou pix",
      user_policies: "A pousada conta com lei do silêncio das 22h às 8h",
      pet_friendly: false,
      check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
      check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
      owner_id: active_owner.id,
    )
    Address.create!(
      street: "Rua da Praia",
      number: 190,
      neighborhood: "Campeche",
      city: "Florianópolis",
      state: "SC",
      postal_code: "88800-000",
      inn_id: active_inn.id
    )
    inactive_owner = Owner.create!(
      email: "fourthowner@example.com",
      password: "xyzpqr"
    )
    inactive_inn = Inn.create!(
      name: "Ilha da Pedra",
      corporate_name: "Pousada Ilha da Pedra",
      registration_number: "09.167.769/0001-73",
      phone: "3499999-9999",
      email: "ilhadapedra@gmail.com",
      description: "Pousada com cachoeiras.",
      pay_methods: "Crédito, débito, dinheiro ou pix",
      user_policies: "A pousada conta com lei do silêncio das 22h às 8h",
      pet_friendly: false,
      check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
      check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
      owner_id: inactive_owner.id,
      active: false
    )
    Address.create!(
      street: "Servidão da Cachoeira",
      number: 32,
      neighborhood: "Morro da Pedra",
      city: "Uberlândia",
      state: "MG",
      postal_code: "33000-000",
      inn_id: inactive_inn.id
    )

    visit root_path
    within "#navigation-bar" do
        fill_in "Buscar Pousada", with: "ilha"
        click_on "Buscar"
    end

    expect(page).to have_link "Ilha da Magia"
    expect(page).not_to have_link "Ilha da Pedra"
  end
end
