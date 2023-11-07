require "rails_helper"

describe "Usuário visita a página inicial" do
  context "desautenticado" do
    it "e vê o menu" do
      visit root_path

      within "nav" do
        expect(page).to have_content "Pousadaria"
        expect(page).to have_link "Entrar"
      end
    end

    it "e vê a lista de pousadas" do
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
        name: "Ilha Bela",
        corporate_name: "Pousada Ilha Bela/RJ",
        registration_number: "81.289.700/0001-40",
        phone: "2199999-9999",
        email: "pousadailhabela@gmail.com",
        description: "Pousada na Ilha Bela.",
        pay_methods: "Crédito, débito, dinheiro ou pix",
        user_policies: "A pousada conta com lei do silêncio das 22h às 8h",
        pet_friendly: false,
        check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
        check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
        owner_id: third_owner.id
      )
      Address.create!(
        street: "Rua Bela",
        number: 190,
        neighborhood: "Praia Grande",
        city: "Ilha Bela",
        state: "RJ",
        postal_code: "01000-000",
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
        registration_number: "00000000000",
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
        number: 0,
        neighborhood: "Sem bairro",
        city: "Sem cidade",
        state: "XX",
        postal_code: "00000-000",
        inn_id: fifth_inn.id
      )

      visit root_path
      within "#recent" do
      expect(page).not_to have_content "Inativa"
      expect(page).not_to have_content "Sem cidade - XX"
        expect(page).to have_content "Lage da Pedra"
        expect(page).to have_content "Uberlândia - MG"
        expect(page).to have_content "Ilha Bela"
        expect(page).to have_content "Ilha Bela - RJ"
        expect(page).to have_content "Morro Azul"
        expect(page).to have_content "Cambará do Sul - RS"
      end
      within "#inns-list" do
        expect(page).to have_content "Mar Aberto"
        expect(page).to have_content "Florianópolis - SC"
        expect(page).not_to have_content "Lage da Pedra"
        expect(page).not_to have_content "Ilha Bela"
        expect(page).not_to have_content "Morro Azul"
        expect(page).not_to have_content "Inativa"
        expect(page).not_to have_content "Sem cidade - XX"
      end
    end

    it "e faz login como Proprietário" do
      Owner.create!(email: "owner@example.com", password: "123456")

      visit root_path
      click_on "Entrar"
      click_on "Proprietário"
      fill_in "E-mail", with: "owner@example.com"
      fill_in "Senha", with: "123456"
      within "form" do
        click_on "Entrar"
      end

      within "nav" do
        expect(page).to have_link "Minha Pousada"
        expect(page).to have_link "Sair"
        expect(page).to have_content "owner@example.com"
      end
      expect(current_path).to eq new_inn_path
      expect(page).to have_content "Cadastre sua Pousada!"
    end
  end

  context "autenticado como Proprietário" do
    it "e vê o menu" do
      owner = Owner.create!(email: "owner@example.com", password: "123456")

      login_as owner
      visit root_path

      within "nav" do
        expect(page).to have_content "owner@example.com"
        expect(page).to have_link "Minha Pousada"
        expect(page).to have_link "Sair"
        expect(page).not_to have_link "Entrar"
      end
    end

    it "e faz logout" do
      owner = Owner.create!(email: "owner@example.com", password: "123456")

      login_as owner
      visit root_path
      within "nav" do
        click_on "Sair"
      end

      expect(page).to have_link "Entrar"
      expect(page).not_to have_link "Sair"
      expect(page).not_to have_link "Minha Pousada"
      expect(page).not_to have_content "owner@example.com"
    end
  end
end
