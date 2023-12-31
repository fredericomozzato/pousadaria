require "rails_helper"

describe "Usuário visita a página inicial" do
  context "desautenticado" do
    it "e vê o menu" do
      visit root_path

      within "#navigation-bar" do
        expect(page).to have_content "Pousadaria"
        expect(page).to have_field "query"
        expect(page).to have_button "Buscar"
        expect(page).to have_link "Busca avançada"
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
      first_inn.photos.attach(
        io: File.open(Rails.root.join("spec/fixtures/images/inn_img_1.jpg")),
        filename: "inn_img_1.jpg"
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
      second_inn.photos.attach(
        io: File.open(Rails.root.join("spec/fixtures/images/inn_img_2.jpg")),
        filename: "inn_img_2.jpg"
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
      third_inn.photos.attach(
        io: File.open(Rails.root.join("spec/fixtures/images/inn_img_3.jpg")),
        filename: "inn_img_3.jpg"
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
      fourth_inn.photos.attach(
        io: File.open(Rails.root.join("spec/fixtures/images/inn_img_4.jpg")),
        filename: "inn_img_4.jpg"
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
        registration_number: "72.153.926/0001-28",
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
      fifth_inn.photos.attach(
        io: File.open(Rails.root.join("spec/fixtures/images/inn_img_5.jpg")),
        filename: "inn_img_5.jpg"
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
      expect(page).not_to have_content "Nenhuma pousada cadastrada"
      expect(page).to have_content "Novidades"
      expect(page).to have_content "Pousadas"
      within "#recent" do
        expect(page).not_to have_content "Inativa"
        expect(page).not_to have_content "Sem cidade - XX"
        expect(page).not_to have_selector "img[src$='inn_img_5.jpg']"
        expect(page).to have_content "Lage da Pedra"
        expect(page).to have_content "Uberlândia - MG"
        expect(page).to have_selector "img[src$='inn_img_4.jpg']"
        expect(page).to have_content "Ilha Bela"
        expect(page).to have_content "Ilha Bela - RJ"
        expect(page).to have_selector "img[src$='inn_img_3.jpg']"
        expect(page).to have_content "Morro Azul"
        expect(page).to have_content "Cambará do Sul - RS"
        expect(page).to have_selector "img[src$='inn_img_2.jpg']"
      end
      within "#inns-list" do
        expect(page).to have_content "Mar Aberto"
        expect(page).to have_content "Florianópolis - SC"
        expect(page).to have_selector "img[src$='inn_img_1.jpg']"
        expect(page).not_to have_content "Lage da Pedra"
        expect(page).not_to have_content "Ilha Bela"
        expect(page).not_to have_content "Morro Azul"
        expect(page).not_to have_content "Inativa"
        expect(page).not_to have_content "Sem cidade - XX"
      end
    end

    it "e vê o menu de cidades" do
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
        registration_number: "72.153.926/0001-28",
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
        expect(page).to have_link "Florianópolis", count: 1
        expect(page).to have_link "Cambará do Sul", count: 1
        expect(page).to have_link "Uberlândia", count: 1
        expect(page).not_to have_link "Inativa"
      end
    end

    it "e vê a tela de redirecionamento para login" do
      visit root_path
      click_on "Entrar"

      expect(page).to have_content "Entrar como"
      expect(page).to have_link "Proprietário"
      expect(page).to have_link "Hóspede"
    end

    it "e vê a tela de login de Proprietário" do
      visit root_path
      click_on "Entrar"
      click_on "Proprietário"

      expect(page).to have_content "Entrar - Proprietário"
      expect(page).to have_field "E-mail"
      expect(page).to have_field "Senha"
      expect(page).to have_button "Entrar"
    end

    it "e vê a tela de login de Hóspede" do
      visit root_path
      click_on "Entrar"
      click_on "Hóspede"

      expect(page).to have_content "Entrar - Hóspede"
      expect(page).to have_field "E-mail"
      expect(page).to have_field "Senha"
      expect(page).to have_button "Entrar"
    end

    it "e faz login como Proprietário" do
      Owner.create!(email: "owner@example.com", password: "123456")

      visit root_path
      click_on "Entrar"
      click_on "Proprietário"
      fill_in "E-mail", with: "owner@example.com"
      fill_in "Senha", with: "123456"
      within "#new_owner" do
        click_on "Entrar"
      end

      within "#navigation-bar" do
        expect(page).to have_link "Minha Pousada"
        expect(page).to have_button "Sair"
        expect(page).to have_content "owner@example.com"
      end
      expect(current_path).to eq new_inn_path
      expect(page).to have_content "Cadastre sua Pousada!"
    end

    it "e faz login como usuário" do
      User.create!(
        name: "User",
        email: "user@email.com",
        cpf: "906.111.800-06",
        password: "123456"
      )

      visit root_path
      click_on "Entrar"
      click_on "Hóspede"
      fill_in "E-mail", with: "user@email.com"
      fill_in "Senha", with: "123456"
      within "#new_user" do
        click_on "Entrar"
      end

      within "#navigation-bar" do
        expect(page).to have_content "user@email.com"
        expect(page).to have_button "Sair"
      end
    end
  end

  context "autenticado como Proprietário" do
    it "e vê o menu" do
      owner = Owner.create!(email: "owner@example.com", password: "123456")

      login_as owner
      visit root_path

      within "#navigation-bar" do
        expect(page).to have_content "owner@example.com"
        expect(page).to have_link "Minha Pousada"
        expect(page).to have_link "Reservas"
        expect(page).to have_link "Estadias ativas"
        expect(page).to have_link "Avaliações"
        expect(page).to have_button "Sair"
        expect(page).not_to have_link "Entrar"
      end
    end

    it "e faz logout" do
      owner = Owner.create!(email: "owner@example.com", password: "123456")

      login_as owner
      visit root_path
      within "#navigation-bar" do
        click_on "Sair"
      end

      expect(page).to have_link "Entrar"
      expect(page).not_to have_button "Sair"
      expect(page).not_to have_link "Minha Pousada"
      expect(page).not_to have_content "owner@example.com"
    end
  end

  context "autenticado como Usuário" do
    it "e vê o menu" do
      user = User.create!(
        name: "João Silva",
        cpf: "899.924.320-63",
        email: "joao@email.com",
        password: "123456"
      )

      login_as user, scope: :user
      visit root_path

      within "#navigation-bar" do
        expect(page).to have_content "joao@email.com"
        expect(page).to have_link "Minhas Reservas"
        expect(page).to have_button "Sair"
        expect(page).not_to have_link "Entrar"
        expect(page).not_to have_link "Minha Pousada"
        expect(page).not_to have_link "Reservas", exact: true
        expect(page).not_to have_link "Estadias ativas"
      end

    end

    it "e faz logout" do
      user = User.create!(
        name: "João Silva",
        cpf: "899.924.320-63",
        email: "joao@email.com",
        password: "123456"
      )

      login_as user, scope: :user
      visit root_path
      within "#navigation-bar" do
        click_on "Sair"
      end

      within "#navigation-bar" do
        expect(page).to have_link "Entrar"
        expect(page).not_to have_button "Sair"
        expect(page).not_to have_link "Minhas Reservas"
        expect(page).not_to have_content "joao@email.com"
      end
    end
  end
end
