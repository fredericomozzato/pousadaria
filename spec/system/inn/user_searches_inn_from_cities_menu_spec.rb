require "rails_helper"

describe "Usuário clica em um link no menu de cidades" do
  it "e vê uma lista de pousadas daquela cidade" do
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
      email: "fifthownr@example.com",
      password: "ghijklm"
    )
    fifth_inn = Inn.create!(
      name: "Inativa",
      corporate_name: "Inativa",
      registration_number: "02.752.145/0001-74",
      phone: "000000000000",
      email: "inativa@inativa.com",
      description: "Pousada inativa.",
      pay_methods: "Inativo",
      user_policies: "A pousada está inativa na plataforma",
      pet_friendly: false,
      check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
      check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
      owner_id: fifth_owner.id,
      active: false
    )
    Address.create!(
      street: "Enderço Inativo",
      number: 10,
      neighborhood: "Sem bairro",
      city: "Sem cidade",
      state: "XX",
      postal_code: "00000-000",
      inn_id: fifth_inn.id
    )

    visit root_path
    within "#cities-menu" do
      click_on "Florianópolis"
    end

    expect(page).to have_content "Pousadas em: Florianópolis"
    expect(page).to have_link "Ilha da Magia"
    expect(page).to have_link "Mar Aberto"
    expect("Ilha da Magia").to appear_before "Mar Aberto"
    expect(page).not_to have_link "Morro Azul"
    expect(page).not_to have_link "Lage da Pedra"
  end

  it "e acessa a página de detalhes de uma pousada encotnrada na busca" do
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
      email: "fifthownr@example.com",
      password: "ghijklm"
    )
    fifth_inn = Inn.create!(
      name: "Inativa",
      corporate_name: "Inativa",
      registration_number: "02.752.145/0001-74",
      phone: "000000000000",
      email: "inativa@inativa.com",
      description: "Pousada inativa.",
      pay_methods: "Inativo",
      user_policies: "A pousada está inativa na plataforma",
      pet_friendly: false,
      check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
      check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
      owner_id: fifth_owner.id,
      active: false
    )
    Address.create!(
      street: "Enderço Inativo",
      number: 10,
      neighborhood: "Sem bairro",
      city: "Sem cidade",
      state: "XX",
      postal_code: "00000-000",
      inn_id: fifth_inn.id
    )

    visit root_path
    within "#cities-menu" do
      click_on "Florianópolis"
    end
    click_on "Mar Aberto"

    expect(current_path).to eq inn_path first_inn
    expect(page).to have_content "Nome: Mar Aberto"
    expect(page).to have_content "Telefone: 4899999-9999"
    expect(page).to have_content "E-mail: pousadamaraberto@hotmail.com"
    expect(page).to have_content "Descrição: Pousada na beira do mar com suítes e café da manhã incluso."
    expect(page).to have_content "Métodos de pagamento: Crédito, débito, dinheiro ou pix"
    expect(page).to have_content "Políticas de uso: A pousada conta com lei do silêncio das 22h às 8h"
    expect(page).to have_content "Aceita pets: sim"
    expect(page).to have_content "Horário de check-in: a partir das 9:00"
    expect(page).to have_content "Horário de check-out: até as 15:30"
    expect(page).to have_content "Rua das Flores, 300 Canasvieiras - Florianópolis, SC"
    expect(page).to have_content "CEP: 88000-000"
  end
end
