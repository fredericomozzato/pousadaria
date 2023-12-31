require "rails_helper"

RSpec.describe Inn, type: :model do
  describe "#valid?" do
    it "inválido com nome vazio" do
    inn = Inn.new(name: "")

    expect(inn.valid?).to be false
    expect(inn.errors.include?(:name)).to be true
    end

    it "inválido com Razão social vazia" do
      inn = Inn.new(corporate_name: "")

      expect(inn.valid?).to be false
      expect(inn.errors.include?(:corporate_name)).to be true
    end

    it "inválido com CNPJ vazio" do
      inn = Inn.new(registration_number: "")

      expect(inn.valid?).to be false
      expect(inn.errors.include?(:registration_number)).to be true
    end

    it "inválido com telefone vazio" do
      inn = Inn.new(phone: "")

      expect(inn.valid?).to be false
      expect(inn.errors.include?(:phone)).to be true
    end

    it "inválido com email vazio" do
      inn = Inn.new(email: "")

      expect(inn.valid?).to be false
      expect(inn.errors.include?(:email)).to be true
    end

    it "inválido com meios de pagamento vazios" do
      inn = Inn.new(pay_methods: "")

      expect(inn.valid?).to be false
      expect(inn.errors.include?(:pay_methods)).to be true
    end

    it "CNPJ inválido sem formatação" do
      inn = Inn.new(registration_number: "00000000000000")

      expect(inn.valid?).to be false
      expect(inn.errors.include?(:registration_number)).to be true
    end

    it "CNPJ inválido com formatação" do
    inn = Inn.new(registration_number: "00.000.000/0000-00")

    expect(inn.valid?).to be false
    expect(inn.errors.include?(:registration_number)).to be true
    end

    it "CNPJ válido com formatação" do
      inn = Inn.new(registration_number: "51.136.627/0001-05")
      inn.valid?

      expect(inn.errors.include?(:registration_number)).to be false
    end

    it "CNPJ válido sem formatação" do
      inn = Inn.new(registration_number: "51136627000105")
      inn.valid?

      expect(inn.errors.include?(:registration_number)).to be false
    end

    it "válido com arquivos de imagem jpeg/png" do
      inn = Inn.new()
      inn.photos.attach(
        [
          { io: File.open(Rails.root.join("spec/fixtures/images/png_img.png")), filename: "png_img.png" },
          { io: File.open(Rails.root.join("spec/fixtures/images/inn_img_1.jpg")), filename: "inn_img_1.jpg" }
        ]
      )

      inn.valid?

      expect(inn.errors.include?(:photos)).to be false
    end

    it "inválido com arquivo de imagem diferente de jpeg/png" do
      inn = Inn.new()
      inn.photos.attach(io: File.open(Rails.root.join("spec/fixtures/images/wrong_type_file.txt")), filename: "wrong_type_file.txt")

      expect(inn.valid?).to be false
      expect(inn.errors.include?(:photos)).to be true
      expect(inn.errors[:photos]).to include "somente nos formatos JPG, JPEG ou PNG"
    end

    it "inválido com mais de 5 fotos adicionadas" do
      inn = Inn.new()
      inn.photos.attach(
        [
          { io: File.open(Rails.root.join("spec/fixtures/images/inn_img_1.jpg")), filename: "inn_img_1.jpg" },
          { io: File.open(Rails.root.join("spec/fixtures/images/inn_img_2.jpg")), filename: "inn_img_2.jpg" },
          { io: File.open(Rails.root.join("spec/fixtures/images/inn_img_3.jpg")), filename: "inn_img_3.jpg" },
          { io: File.open(Rails.root.join("spec/fixtures/images/inn_img_4.jpg")), filename: "inn_img_4.jpg" },
          { io: File.open(Rails.root.join("spec/fixtures/images/inn_img_5.jpg")), filename: "inn_img_5.jpg" },
          { io: File.open(Rails.root.join("spec/fixtures/images/inn_img_6.jpg")), filename: "inn_img_6.jpg" }
        ]
      )

      expect(inn.valid?).to be false
      expect(inn.errors.include?(:photos)).to be true
      expect(inn.errors[:photos]).to include "Número máximo de fotos: 5"
    end

    it "inválido com arquivo maior que 5mb" do
      inn = Inn.new()
      inn.photos.attach(io: File.open(Rails.root.join("spec/fixtures/images/5_mb_img.jpg")), filename: "5_mb_img.jpg")

      expect(inn.valid?).to be false
      expect(inn.errors.include?(:photos)).to be true
      expect(inn.errors[:photos]).to include "não pode ser maior que 5 mb"
    end
  end

  describe ".search_inns" do
    it "encontra Pousada pelo nome" do
      owner = Owner.create!(
        email: "owner@email.com",
        password: "123456"
      )
      inn = Inn.create!(
        name: "Pousada",
        corporate_name: "Pousada Teste",
        registration_number: "62.958.428/0001-07",
        phone: "999999999",
        email: "teste@teste.com",
        description: "Descrição teste",
        pay_methods: "Teste",
        user_policies: "Teste",
        check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
        check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
        owner_id: owner.id
      )
      Address.create!(
        street: "Rua da Praia",
        number: "160",
        neighborhood: "Praia Brava",
        city: "Florianópolis",
        state: "SC",
        postal_code: "88888-888",
        inn_id: inn.id
      )

      result = Inn.search_inns("pousada")

      expect(result.count).to eq 1
      expect(result).to include inn
    end

    it "encontra Pousada pela cidade" do
      owner = Owner.create!(
        email: "owner@email.com",
        password: "123456"
      )
      inn = Inn.create!(
        name: "Pousada",
        corporate_name: "Pousada Teste",
        registration_number: "62.958.428/0001-07",
        phone: "999999999",
        email: "teste@teste.com",
        description: "Descrição teste",
        pay_methods: "Teste",
        user_policies: "Teste",
        check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
        check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
        owner_id: owner.id
      )
      Address.create!(
        street: "Rua da Praia",
        number: "160",
        neighborhood: "Praia Brava",
        city: "Florianópolis",
        state: "SC",
        postal_code: "88888-888",
        inn_id: inn.id
      )

      result = Inn.search_inns("Florianópolis")

      expect(result.count).to eq 1
      expect(result).to include inn
    end

    it "encontra pousada pelo bairro" do
      owner = Owner.create!(
        email: "owner@email.com",
        password: "123456"
      )
      inn = Inn.create!(
        name: "Pousada",
        corporate_name: "Pousada Teste",
        registration_number: "62.958.428/0001-07",
        phone: "999999999",
        email: "teste@teste.com",
        description: "Descrição teste",
        pay_methods: "Teste",
        user_policies: "Teste",
        check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
        check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
        owner_id: owner.id
      )
      Address.create!(
        street: "Rua da Praia",
        number: "160",
        neighborhood: "Praia Brava",
        city: "Florianópolis",
        state: "SC",
        postal_code: "88888-888",
        inn_id: inn.id
      )

      result = Inn.search_inns("Praia Brava")

      expect(result.count).to eq 1
      expect(result).to include inn
    end

    it "não encontra pousada pelo nome" do
      owner = Owner.create!(
        email: "owner@email.com",
        password: "123456"
      )
      inn = Inn.create!(
        name: "Pousada",
        corporate_name: "Pousada Teste",
        registration_number: "62.958.428/0001-07",
        phone: "999999999",
        email: "teste@teste.com",
        description: "Descrição teste",
        pay_methods: "Teste",
        user_policies: "Teste",
        check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
        check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
        owner_id: owner.id
      )
      Address.create!(
        street: "Rua da Praia",
        number: "160",
        neighborhood: "Praia Brava",
        city: "Florianópolis",
        state: "SC",
        postal_code: "88888-888",
        inn_id: inn.id
      )

      result = Inn.search_inns("Montanha")

      expect(result).to be_empty
    end

    it "não encontra pousada pela cidade" do
      owner = Owner.create!(
        email: "owner@email.com",
        password: "123456"
      )
      inn = Inn.create!(
        name: "Pousada",
        corporate_name: "Pousada Teste",
        registration_number: "62.958.428/0001-07",
        phone: "999999999",
        email: "teste@teste.com",
        description: "Descrição teste",
        pay_methods: "Teste",
        user_policies: "Teste",
        check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
        check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
        owner_id: owner.id
      )
      Address.create!(
        street: "Rua da Praia",
        number: "160",
        neighborhood: "Praia Brava",
        city: "Florianópolis",
        state: "SC",
        postal_code: "88888-888",
        inn_id: inn.id
      )

      result = Inn.search_inns("São Paulo")

      expect(result).to be_empty
    end

    it "não encontra pousada pelo bairro" do
      owner = Owner.create!(
        email: "owner@email.com",
        password: "123456"
      )
      inn = Inn.create!(
        name: "Pousada",
        corporate_name: "Pousada Teste",
        registration_number: "62.958.428/0001-07",
        phone: "999999999",
        email: "teste@teste.com",
        description: "Descrição teste",
        pay_methods: "Teste",
        user_policies: "Teste",
        check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
        check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
        owner_id: owner.id
      )
      Address.create!(
        street: "Rua da Praia",
        number: "160",
        neighborhood: "Praia Brava",
        city: "Florianópolis",
        state: "SC",
        postal_code: "88888-888",
        inn_id: inn.id
      )

      result = Inn.search_inns("Campeche")

      expect(result).to be_empty
    end
  end

  describe ".advanced_search" do
    it "encontra pousada por busca avançada" do
      owner_1 = Owner.create!(email: "dono_1@email.com", password: "123456")
      inn_1 = Inn.create!(
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
        owner: owner_1
      )
      Address.create!(
        street: "Rua das Flores",
        number: 300,
        neighborhood: "Canasvieiras",
        city: "Florianópolis",
        state: "SC",
        postal_code: "88000-000",
        inn: inn_1
      )
      inn_1_room_1 = Room.create!(
        name: "Atlântico",
        description: "Quarto com vista para o mar",
        size: 30,
        max_guests: 2,
        price: 200.00,
        inn: inn_1,
        bathroom: true
      )
      owner_2 = Owner.create!(email: "dono_2@email.com", password: "654321")
      inn_2 = Inn.create!(
        name: "Morro Azul",
        corporate_name: "Pousada Da Montanha/RS",
        registration_number: "59.457.495/0001-25",
        phone: "5499999-9999",
        email: "pousadamorroazul@gmail.com",
        description: "Pousada com vista pra montanha.",
        pay_methods: "Crédito, débito, dinheiro ou pix",
        user_policies: "A pousada conta com lei do silêncio das 22h às 8h",
        pet_friendly: false,
        check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
        check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
        owner: owner_2
      )
      Address.create!(
        street: "Rua da Cachoeira",
        number: 560,
        neighborhood: "Zona Rual",
        city: "Cambará do Sul",
        state: "RS",
        postal_code: "77000-000",
        inn: inn_2
      )
      inn_2_room_1 = Room.create!(
        name: "Canarinho",
        description: "Quarto com vista para a montanha",
        size: 30,
        max_guests: 2,
        price: 150.00,
        inn: inn_2
      )
      owner_3 = Owner.create!(email: "dono_3@email.com", password: "abcdef")
      inn_3 = Inn.create!(
        name: "Ilha da Magia",
        corporate_name: "Pousada Ilha da Magia Floripa",
        registration_number: "81.289.700/0001-40",
        phone: "48829999-9999",
        email: "pousadailhadamagia@gmail.com",
        description: "Pousada na Ilha da Magia.",
        pay_methods: "Crédito, débito, dinheiro ou pix",
        user_policies: "A pousada conta com lei do silêncio das 22h às 8h",
        pet_friendly: true,
        check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
        check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
        owner: owner_3
      )
      Address.create!(
        street: "Rua da Praia",
        number: 190,
        neighborhood: "Campeche",
        city: "Florianópolis",
        state: "SC",
        postal_code: "88800-000",
        inn: inn_3
      )
      inn_3_room_1 = Room.create!(
        name: "Canasvieiras",
        description: "Quarto com vista para a praia",
        size: 20,
        max_guests: 2,
        price: 200.00,
        inn: inn_3,
        wifi: true,
        accessibility: true
      )
      params = {
        name: "",
        city: "",
        pet_friendly: "1",
        accessibility: "1",
        wifi: "1",
        bathroom: "0",
        air_conditioner: "0",
        wardrobe: "0",
        tv: "0",
        porch: "0",
        safe: "0"
      }

      result = Inn.advanced_search(params)

      expect(result.count).to eq 1
      expect(result).to include inn_3
    end

    it "encontra uma pousada por nome" do
      owner = Owner.create!(
        email: "owner@email.com",
        password: "123456"
      )
      inn = Inn.create!(
        name: "Pousada",
        corporate_name: "Pousada Teste",
        registration_number: "62.958.428/0001-07",
        phone: "999999999",
        email: "teste@teste.com",
        description: "Descrição teste",
        pay_methods: "Teste",
        user_policies: "Teste",
        check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
        check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
        owner_id: owner.id
      )
      Address.create!(
        street: "Rua da Praia",
        number: "160",
        neighborhood: "Praia Brava",
        city: "Florianópolis",
        state: "SC",
        postal_code: "88888-888",
        inn_id: inn.id
      )
      room = Room.create!(
        name: "Quarto",
        size: 10,
        max_guests: 1,
        price: 150,
        bathroom: false,
        porch: false,
        air_conditioner: false,
        tv: false,
        wardrobe: false,
        safe: false,
        wifi: false,
        accessibility: false,
        inn: inn
      )
      params = {
        name: "Pousada",
        city: "",
        pet_friendly: "0",
        accessibility: "0",
        wifi: "0",
        bathroom: "0",
        air_conditioner: "0",
        wardrobe: "0",
        tv: "0",
        porch: "0",
        safe: "0"
      }

      result = Inn.advanced_search(params)

      expect(result.count).to eq 1
      expect(result).to include inn
    end

    it "e não encontra pousada por nome" do
      owner = Owner.create!(
        email: "owner@email.com",
        password: "123456"
      )
      inn = Inn.create!(
        name: "Pousada",
        corporate_name: "Pousada Teste",
        registration_number: "62.958.428/0001-07",
        phone: "999999999",
        email: "teste@teste.com",
        description: "Descrição teste",
        pay_methods: "Teste",
        user_policies: "Teste",
        check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
        check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
        owner_id: owner.id
      )
      Address.create!(
        street: "Rua da Praia",
        number: "160",
        neighborhood: "Praia Brava",
        city: "Florianópolis",
        state: "SC",
        postal_code: "88888-888",
        inn_id: inn.id
      )
      room = Room.create!(
        name: "Quarto",
        size: 10,
        max_guests: 1,
        price: 150,
        bathroom: false,
        porch: false,
        air_conditioner: false,
        tv: false,
        wardrobe: false,
        safe: false,
        wifi: false,
        accessibility: false,
        inn: inn
      )
      params = {
        name: "paradouro",
        city: "",
        pet_friendly: "0",
        accessibility: "0",
        wifi: "0",
        bathroom: "0",
        air_conditioner: "0",
        wardrobe: "0",
        tv: "0",
        porch: "0",
        safe: "0"
      }

      result = Inn.advanced_search(params)

      expect(result.count).to eq 0
    end

    it "encontra uma pousada por cidade" do
      owner = Owner.create!(
        email: "owner@email.com",
        password: "123456"
      )
      inn = Inn.create!(
        name: "Pousada",
        corporate_name: "Pousada Teste",
        registration_number: "62.958.428/0001-07",
        phone: "999999999",
        email: "teste@teste.com",
        description: "Descrição teste",
        pay_methods: "Teste",
        user_policies: "Teste",
        check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
        check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
        owner_id: owner.id
      )
      Address.create!(
        street: "Rua da Praia",
        number: "160",
        neighborhood: "Praia Brava",
        city: "Florianópolis",
        state: "SC",
        postal_code: "88888-888",
        inn_id: inn.id
      )
      room = Room.create!(
        name: "Quarto",
        size: 10,
        max_guests: 1,
        price: 150,
        inn: inn
      )
      params = {
        name: "",
        city: "Florianópolis",
        pet_friendly: "0",
        accessibility: "0",
        wifi: "0",
        bathroom: "0",
        air_conditioner: "0",
        wardrobe: "0",
        tv: "0",
        porch: "0",
        safe: "0"
      }

      result = Inn.advanced_search(params)

      expect(result.count).to eq 1
      expect(result).to include inn
    end

    it "e não encontra pousada por cidade" do
      owner = Owner.create!(
        email: "owner@email.com",
        password: "123456"
      )
      inn = Inn.create!(
        name: "Pousada",
        corporate_name: "Pousada Teste",
        registration_number: "62.958.428/0001-07",
        phone: "999999999",
        email: "teste@teste.com",
        description: "Descrição teste",
        pay_methods: "Teste",
        user_policies: "Teste",
        check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
        check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
        owner_id: owner.id
      )
      Address.create!(
        street: "Rua da Praia",
        number: "160",
        neighborhood: "Praia Brava",
        city: "Florianópolis",
        state: "SC",
        postal_code: "88888-888",
        inn_id: inn.id
      )
      room = Room.create!(
        name: "Quarto",
        size: 10,
        max_guests: 1,
        price: 150,
        inn: inn
      )
      params = {
        name: "",
        city: "Gramado",
        pet_friendly: "0",
        accessibility: "0",
        wifi: "0",
        bathroom: "0",
        air_conditioner: "0",
        wardrobe: "0",
        tv: "0",
        porch: "0",
        safe: "0"
      }

      result = Inn.advanced_search(params)

      expect(result.count).to eq 0
    end

    it "encontra uma pousada por aceita pets" do
      owner = Owner.create!(
        email: "owner@email.com",
        password: "123456"
      )
      inn = Inn.create!(
        name: "Pousada",
        corporate_name: "Pousada Teste",
        registration_number: "62.958.428/0001-07",
        phone: "999999999",
        email: "teste@teste.com",
        description: "Descrição teste",
        pay_methods: "Teste",
        user_policies: "Teste",
        pet_friendly: true,
        check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
        check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
        owner_id: owner.id
      )
      Address.create!(
        street: "Rua da Praia",
        number: "160",
        neighborhood: "Praia Brava",
        city: "Florianópolis",
        state: "SC",
        postal_code: "88888-888",
        inn_id: inn.id
      )
      room = Room.create!(
        name: "Quarto",
        size: 10,
        max_guests: 1,
        price: 150,
        inn: inn
      )
      params = {
        name: "",
        city: "",
        pet_friendly: "1",
        accessibility: "0",
        wifi: "0",
        bathroom: "0",
        air_conditioner: "0",
        wardrobe: "0",
        tv: "0",
        porch: "0",
        safe: "0"
      }

      result = Inn.advanced_search(params)

      expect(result.count).to eq 1
      expect(result).to include inn
    end

    it "e não encontra uma pousada por aceita pets" do
      owner = Owner.create!(
        email: "owner@email.com",
        password: "123456"
      )
      inn = Inn.create!(
        name: "Pousada",
        corporate_name: "Pousada Teste",
        registration_number: "62.958.428/0001-07",
        phone: "999999999",
        email: "teste@teste.com",
        description: "Descrição teste",
        pay_methods: "Teste",
        user_policies: "Teste",
        pet_friendly: false,
        check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
        check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
        owner_id: owner.id
      )
      Address.create!(
        street: "Rua da Praia",
        number: "160",
        neighborhood: "Praia Brava",
        city: "Florianópolis",
        state: "SC",
        postal_code: "88888-888",
        inn_id: inn.id
      )
      room = Room.create!(
        name: "Quarto",
        size: 10,
        max_guests: 1,
        price: 150,
        inn: inn
      )
      params = {
        name: "",
        city: "",
        pet_friendly: "1",
        accessibility: "0",
        wifi: "0",
        bathroom: "0",
        air_conditioner: "0",
        wardrobe: "0",
        tv: "0",
        porch: "0",
        safe: "0"
      }

      result = Inn.advanced_search(params)

      expect(result.count).to eq 0
    end

    it "encontra uma pousada por acessibilidade" do
      owner = Owner.create!(
        email: "owner@email.com",
        password: "123456"
      )
      inn = Inn.create!(
        name: "Pousada",
        corporate_name: "Pousada Teste",
        registration_number: "62.958.428/0001-07",
        phone: "999999999",
        email: "teste@teste.com",
        description: "Descrição teste",
        pay_methods: "Teste",
        user_policies: "Teste",
        check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
        check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
        owner_id: owner.id
      )
      Address.create!(
        street: "Rua da Praia",
        number: "160",
        neighborhood: "Praia Brava",
        city: "Florianópolis",
        state: "SC",
        postal_code: "88888-888",
        inn_id: inn.id
      )
      room = Room.create!(
        name: "Quarto",
        size: 10,
        max_guests: 1,
        price: 150,
        accessibility: true,
        inn: inn
      )
      params = {
        name: "",
        city: "",
        pet_friendly: "0",
        accessibility: "1",
        wifi: "0",
        bathroom: "0",
        air_conditioner: "0",
        wardrobe: "0",
        tv: "0",
        porch: "0",
        safe: "0"
      }

      result = Inn.advanced_search(params)

      expect(result.count).to eq 1
      expect(result).to include inn
    end

    it "e não encontra pousada por acessibilidade" do
      owner = Owner.create!(
        email: "owner@email.com",
        password: "123456"
      )
      inn = Inn.create!(
        name: "Pousada",
        corporate_name: "Pousada Teste",
        registration_number: "62.958.428/0001-07",
        phone: "999999999",
        email: "teste@teste.com",
        description: "Descrição teste",
        pay_methods: "Teste",
        user_policies: "Teste",
        check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
        check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
        owner_id: owner.id
      )
      Address.create!(
        street: "Rua da Praia",
        number: "160",
        neighborhood: "Praia Brava",
        city: "Florianópolis",
        state: "SC",
        postal_code: "88888-888",
        inn_id: inn.id
      )
      room = Room.create!(
        name: "Quarto",
        size: 10,
        max_guests: 1,
        price: 150,
        accessibility: false,
        inn: inn
      )
      params = {
        name: "",
        city: "",
        pet_friendly: "0",
        accessibility: "1",
        wifi: "0",
        bathroom: "0",
        air_conditioner: "0",
        wardrobe: "0",
        tv: "0",
        porch: "0",
        safe: "0"
      }

      result = Inn.advanced_search(params)

      expect(result.count).to eq 0
    end

    it "encontra uma pousada por wifi" do
      owner = Owner.create!(
        email: "owner@email.com",
        password: "123456"
      )
      inn = Inn.create!(
        name: "Pousada",
        corporate_name: "Pousada Teste",
        registration_number: "62.958.428/0001-07",
        phone: "999999999",
        email: "teste@teste.com",
        description: "Descrição teste",
        pay_methods: "Teste",
        user_policies: "Teste",
        check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
        check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
        owner_id: owner.id
      )
      Address.create!(
        street: "Rua da Praia",
        number: "160",
        neighborhood: "Praia Brava",
        city: "Florianópolis",
        state: "SC",
        postal_code: "88888-888",
        inn_id: inn.id
      )
      room = Room.create!(
        name: "Quarto",
        size: 10,
        max_guests: 1,
        price: 150,
        wifi: true,
        inn: inn
      )
      params = {
        name: "",
        city: "",
        pet_friendly: "0",
        accessibility: "0",
        wifi: "1",
        bathroom: "0",
        air_conditioner: "0",
        wardrobe: "0",
        tv: "0",
        porch: "0",
        safe: "0"
      }

      result = Inn.advanced_search(params)

      expect(result.count).to eq 1
      expect(result).to include inn
    end

    it "e não encontra pousada por wi-fi" do
      owner = Owner.create!(
        email: "owner@email.com",
        password: "123456"
      )
      inn = Inn.create!(
        name: "Pousada",
        corporate_name: "Pousada Teste",
        registration_number: "62.958.428/0001-07",
        phone: "999999999",
        email: "teste@teste.com",
        description: "Descrição teste",
        pay_methods: "Teste",
        user_policies: "Teste",
        check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
        check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
        owner_id: owner.id
      )
      Address.create!(
        street: "Rua da Praia",
        number: "160",
        neighborhood: "Praia Brava",
        city: "Florianópolis",
        state: "SC",
        postal_code: "88888-888",
        inn_id: inn.id
      )
      room = Room.create!(
        name: "Quarto",
        size: 10,
        max_guests: 1,
        price: 150,
        wifi: false,
        inn: inn
      )
      params = {
        name: "",
        city: "",
        pet_friendly: "0",
        accessibility: "0",
        wifi: "1",
        bathroom: "0",
        air_conditioner: "0",
        wardrobe: "0",
        tv: "0",
        porch: "0",
        safe: "0"
      }

      result = Inn.advanced_search(params)

      expect(result.count).to eq 0
    end

    it "encontra uma pousada por banheiro privativo" do
      owner = Owner.create!(
        email: "owner@email.com",
        password: "123456"
      )
      inn = Inn.create!(
        name: "Pousada",
        corporate_name: "Pousada Teste",
        registration_number: "62.958.428/0001-07",
        phone: "999999999",
        email: "teste@teste.com",
        description: "Descrição teste",
        pay_methods: "Teste",
        user_policies: "Teste",
        check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
        check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
        owner_id: owner.id
      )
      Address.create!(
        street: "Rua da Praia",
        number: "160",
        neighborhood: "Praia Brava",
        city: "Florianópolis",
        state: "SC",
        postal_code: "88888-888",
        inn_id: inn.id
      )
      room = Room.create!(
        name: "Quarto",
        size: 10,
        max_guests: 1,
        price: 150,
        bathroom: true,
        inn: inn
      )
      params = {
        name: "",
        city: "",
        pet_friendly: "0",
        accessibility: "0",
        wifi: "0",
        bathroom: "1",
        air_conditioner: "0",
        wardrobe: "0",
        tv: "0",
        porch: "0",
        safe: "0"
      }

      result = Inn.advanced_search(params)

      expect(result.count).to eq 1
      expect(result).to include inn
    end

    it "e não encontra pousada por banheiro privativo" do
      owner = Owner.create!(
        email: "owner@email.com",
        password: "123456"
      )
      inn = Inn.create!(
        name: "Pousada",
        corporate_name: "Pousada Teste",
        registration_number: "62.958.428/0001-07",
        phone: "999999999",
        email: "teste@teste.com",
        description: "Descrição teste",
        pay_methods: "Teste",
        user_policies: "Teste",
        check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
        check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
        owner_id: owner.id
      )
      Address.create!(
        street: "Rua da Praia",
        number: "160",
        neighborhood: "Praia Brava",
        city: "Florianópolis",
        state: "SC",
        postal_code: "88888-888",
        inn_id: inn.id
      )
      room = Room.create!(
        name: "Quarto",
        size: 10,
        max_guests: 1,
        price: 150,
        bathroom: false,
        inn: inn
      )
      params = {
        name: "",
        city: "",
        pet_friendly: "0",
        accessibility: "0",
        wifi: "0",
        bathroom: "1",
        air_conditioner: "0",
        wardrobe: "0",
        tv: "0",
        porch: "0",
        safe: "0"
      }

      result = Inn.advanced_search(params)

      expect(result.count).to eq 0
    end

    it "encontra uma pousada por ar condicionado" do
      owner = Owner.create!(
        email: "owner@email.com",
        password: "123456"
      )
      inn = Inn.create!(
        name: "Pousada",
        corporate_name: "Pousada Teste",
        registration_number: "62.958.428/0001-07",
        phone: "999999999",
        email: "teste@teste.com",
        description: "Descrição teste",
        pay_methods: "Teste",
        user_policies: "Teste",
        check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
        check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
        owner_id: owner.id
      )
      Address.create!(
        street: "Rua da Praia",
        number: "160",
        neighborhood: "Praia Brava",
        city: "Florianópolis",
        state: "SC",
        postal_code: "88888-888",
        inn_id: inn.id
      )
      room = Room.create!(
        name: "Quarto",
        size: 10,
        max_guests: 1,
        price: 150,
        air_conditioner: true,
        inn: inn
      )
      params = {
        name: "",
        city: "",
        pet_friendly: false,
        accessibility: false,
        wifi: false,
        bathroom: false,
        air_conditioner: true,
        wardrobe: false,
        tv: false,
        porch: false,
        safe: false
      }

      result = Inn.advanced_search(params)

      expect(result.count).to eq 1
      expect(result).to include inn
    end

    it "e não encontra pousada por ar-condicionado" do
      owner = Owner.create!(
        email: "owner@email.com",
        password: "123456"
      )
      inn = Inn.create!(
        name: "Pousada",
        corporate_name: "Pousada Teste",
        registration_number: "62.958.428/0001-07",
        phone: "999999999",
        email: "teste@teste.com",
        description: "Descrição teste",
        pay_methods: "Teste",
        user_policies: "Teste",
        check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
        check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
        owner_id: owner.id
      )
      Address.create!(
        street: "Rua da Praia",
        number: "160",
        neighborhood: "Praia Brava",
        city: "Florianópolis",
        state: "SC",
        postal_code: "88888-888",
        inn_id: inn.id
      )
      room = Room.create!(
        name: "Quarto",
        size: 10,
        max_guests: 1,
        price: 150,
        air_conditioner: false,
        inn: inn
      )
      params = {
        name: "",
        city: "",
        pet_friendly: "0",
        accessibility: "0",
        wifi: "0",
        bathroom: "0",
        air_conditioner: "1",
        wardrobe: "0",
        tv: "0",
        porch: "0",
        safe: "0"
      }

      result = Inn.advanced_search(params)

      expect(result.count).to eq 0
    end

    it "encontra uma pousada por guarda-roupas" do
      owner = Owner.create!(
        email: "owner@email.com",
        password: "123456"
      )
      inn = Inn.create!(
        name: "Pousada",
        corporate_name: "Pousada Teste",
        registration_number: "62.958.428/0001-07",
        phone: "999999999",
        email: "teste@teste.com",
        description: "Descrição teste",
        pay_methods: "Teste",
        user_policies: "Teste",
        check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
        check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
        owner_id: owner.id
      )
      Address.create!(
        street: "Rua da Praia",
        number: "160",
        neighborhood: "Praia Brava",
        city: "Florianópolis",
        state: "SC",
        postal_code: "88888-888",
        inn_id: inn.id
      )
      room = Room.create!(
        name: "Quarto",
        size: 10,
        max_guests: 1,
        price: 150,
        wardrobe: true,
        inn: inn
      )
      params = {
        name: "",
        city: "",
        pet_friendly: "0",
        accessibility: "0",
        wifi: "0",
        bathroom: "0",
        air_conditioner: "0",
        wardrobe: "1",
        tv: "0",
        porch: "0",
        safe: "0"
      }

      result = Inn.advanced_search(params)

      expect(result.count).to eq 1
      expect(result).to include inn
    end

    it "e não encontra pousada por guarda-roupas" do
      owner = Owner.create!(
        email: "owner@email.com",
        password: "123456"
      )
      inn = Inn.create!(
        name: "Pousada",
        corporate_name: "Pousada Teste",
        registration_number: "62.958.428/0001-07",
        phone: "999999999",
        email: "teste@teste.com",
        description: "Descrição teste",
        pay_methods: "Teste",
        user_policies: "Teste",
        check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
        check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
        owner_id: owner.id
      )
      Address.create!(
        street: "Rua da Praia",
        number: "160",
        neighborhood: "Praia Brava",
        city: "Florianópolis",
        state: "SC",
        postal_code: "88888-888",
        inn_id: inn.id
      )
      room = Room.create!(
        name: "Quarto",
        size: 10,
        max_guests: 1,
        price: 150,
        wardrobe: false,
        inn: inn
      )
      params = {
        name: "",
        city: "",
        pet_friendly: "0",
        accessibility: "0",
        wifi: "0",
        bathroom: "0",
        air_conditioner: "0",
        wardrobe: "1",
        tv: "0",
        porch: "0",
        safe: "0"
      }

      result = Inn.advanced_search(params)

      expect(result.count).to eq 0
    end

    it "encontra uma pousada por tv" do
      owner = Owner.create!(
        email: "owner@email.com",
        password: "123456"
      )
      inn = Inn.create!(
        name: "Pousada",
        corporate_name: "Pousada Teste",
        registration_number: "62.958.428/0001-07",
        phone: "999999999",
        email: "teste@teste.com",
        description: "Descrição teste",
        pay_methods: "Teste",
        user_policies: "Teste",
        check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
        check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
        owner_id: owner.id
      )
      Address.create!(
        street: "Rua da Praia",
        number: "160",
        neighborhood: "Praia Brava",
        city: "Florianópolis",
        state: "SC",
        postal_code: "88888-888",
        inn_id: inn.id
      )
      room = Room.create!(
        name: "Quarto",
        size: 10,
        max_guests: 1,
        price: 150,
        tv: true,
        inn: inn
      )
      params = {
        name: "",
        city: "",
        pet_friendly: "0",
        accessibility: "0",
        wifi: "0",
        bathroom: "0",
        air_conditioner: "0",
        wardrobe: "0",
        tv: "1",
        porch: "0",
        safe: "0"
      }

      result = Inn.advanced_search(params)

      expect(result.count).to eq 1
      expect(result).to include inn
    end

    it "e não encontra pousada por tv" do
      owner = Owner.create!(
        email: "owner@email.com",
        password: "123456"
      )
      inn = Inn.create!(
        name: "Pousada",
        corporate_name: "Pousada Teste",
        registration_number: "62.958.428/0001-07",
        phone: "999999999",
        email: "teste@teste.com",
        description: "Descrição teste",
        pay_methods: "Teste",
        user_policies: "Teste",
        check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
        check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
        owner_id: owner.id
      )
      Address.create!(
        street: "Rua da Praia",
        number: "160",
        neighborhood: "Praia Brava",
        city: "Florianópolis",
        state: "SC",
        postal_code: "88888-888",
        inn_id: inn.id
      )
      room = Room.create!(
        name: "Quarto",
        size: 10,
        max_guests: 1,
        price: 150,
        tv: false,
        inn: inn
      )
      params = {
        name: "",
        city: "",
        pet_friendly: "0",
        accessibility: "0",
        wifi: "0",
        bathroom: "0",
        air_conditioner: "0",
        wardrobe: "0",
        tv: "1",
        porch: "0",
        safe: "0"
      }

      result = Inn.advanced_search(params)

      expect(result.count).to eq 0
    end

    it "encontra uma pousada por varanda" do
      owner = Owner.create!(
        email: "owner@email.com",
        password: "123456"
      )
      inn = Inn.create!(
        name: "Pousada",
        corporate_name: "Pousada Teste",
        registration_number: "62.958.428/0001-07",
        phone: "999999999",
        email: "teste@teste.com",
        description: "Descrição teste",
        pay_methods: "Teste",
        user_policies: "Teste",
        check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
        check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
        owner_id: owner.id
      )
      Address.create!(
        street: "Rua da Praia",
        number: "160",
        neighborhood: "Praia Brava",
        city: "Florianópolis",
        state: "SC",
        postal_code: "88888-888",
        inn_id: inn.id
      )
      room = Room.create!(
        name: "Quarto",
        size: 10,
        max_guests: 1,
        price: 150,
        porch: true,
        inn: inn
      )
      params = {
        name: "",
        city: "",
        pet_friendly: "0",
        accessibility: "0",
        wifi: "0",
        bathroom: "0",
        air_conditioner: "0",
        wardrobe: "0",
        tv: "0",
        porch: "1",
        safe: "0"
      }

      result = Inn.advanced_search(params)

      expect(result.count).to eq 1
      expect(result).to include inn
    end

    it "e não encontra pousada por varanda" do
      owner = Owner.create!(
        email: "owner@email.com",
        password: "123456"
      )
      inn = Inn.create!(
        name: "Pousada",
        corporate_name: "Pousada Teste",
        registration_number: "62.958.428/0001-07",
        phone: "999999999",
        email: "teste@teste.com",
        description: "Descrição teste",
        pay_methods: "Teste",
        user_policies: "Teste",
        check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
        check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
        owner_id: owner.id
      )
      Address.create!(
        street: "Rua da Praia",
        number: "160",
        neighborhood: "Praia Brava",
        city: "Florianópolis",
        state: "SC",
        postal_code: "88888-888",
        inn_id: inn.id
      )
      room = Room.create!(
        name: "Quarto",
        size: 10,
        max_guests: 1,
        price: 150,
        porch: false,
        inn: inn
      )
      params = {
        name: "",
        city: "",
        pet_friendly: "0",
        accessibility: "0",
        wifi: "0",
        bathroom: "0",
        air_conditioner: "0",
        wardrobe: "0",
        tv: "0",
        porch: "1",
        safe: "0"
      }

      result = Inn.advanced_search(params)

      expect(result.count).to eq 0
    end

    it "encontra uma pousada por cofre" do
      owner = Owner.create!(
        email: "owner@email.com",
        password: "123456"
      )
      inn = Inn.create!(
        name: "Pousada",
        corporate_name: "Pousada Teste",
        registration_number: "62.958.428/0001-07",
        phone: "999999999",
        email: "teste@teste.com",
        description: "Descrição teste",
        pay_methods: "Teste",
        user_policies: "Teste",
        check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
        check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
        owner_id: owner.id
      )
      Address.create!(
        street: "Rua da Praia",
        number: "160",
        neighborhood: "Praia Brava",
        city: "Florianópolis",
        state: "SC",
        postal_code: "88888-888",
        inn_id: inn.id
      )
      room = Room.create!(
        name: "Quarto",
        size: 10,
        max_guests: 1,
        price: 150,
        safe: true,
        inn: inn
      )
      params = {
        name: "",
        city: "",
        pet_friendly: "0",
        accessibility: "0",
        wifi: "0",
        bathroom: "0",
        air_conditioner: "0",
        wardrobe: "0",
        tv: "0",
        porch: "0",
        safe: "1"
      }

      result = Inn.advanced_search(params)

      expect(result.count).to eq 1
      expect(result).to include inn
    end

    it "e não encontra pousada por cofre" do
      owner = Owner.create!(
        email: "owner@email.com",
        password: "123456"
      )
      inn = Inn.create!(
        name: "Pousada",
        corporate_name: "Pousada Teste",
        registration_number: "62.958.428/0001-07",
        phone: "999999999",
        email: "teste@teste.com",
        description: "Descrição teste",
        pay_methods: "Teste",
        user_policies: "Teste",
        check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
        check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
        owner_id: owner.id
      )
      Address.create!(
        street: "Rua da Praia",
        number: "160",
        neighborhood: "Praia Brava",
        city: "Florianópolis",
        state: "SC",
        postal_code: "88888-888",
        inn_id: inn.id
      )
      room = Room.create!(
        name: "Quarto",
        size: 10,
        max_guests: 1,
        price: 150,
        safe: false,
        inn: inn
      )
      params = {
        name: "",
        city: "",
        pet_friendly: "0",
        accessibility: "0",
        wifi: "0",
        bathroom: "0",
        air_conditioner: "0",
        wardrobe: "0",
        tv: "0",
        porch: "0",
        safe: "1"
      }

      result = Inn.advanced_search(params)

      expect(result.count).to eq 0
    end

    it "e encontra uma pousada por múltiplos parâmetros" do
      first_owner = Owner.create!(
        email: "owner@email.com",
        password: "123456"
      )
      first_inn = Inn.create!(
        name: "Pousada",
        corporate_name: "Pousada Teste",
        registration_number: "62.958.428/0001-07",
        phone: "999999999",
        email: "teste@teste.com",
        description: "Descrição teste",
        pay_methods: "Teste",
        user_policies: "Teste",
        check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
        check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
        owner_id: first_owner.id
      )
      Address.create!(
        street: "Rua da Praia",
        number: "160",
        neighborhood: "Praia Brava",
        city: "Florianópolis",
        state: "SC",
        postal_code: "88888-888",
        inn_id: first_inn.id
      )
      first_room = Room.create!(
        name: "Quarto",
        size: 10,
        max_guests: 1,
        price: 150,
        inn: first_inn,
        bathroom: true,
        safe: true,
        wifi: true
      )
      second_owner = Owner.create!(
        email: "secondowner@email.com",
        password: "654321"
      )
      second_inn = Inn.create!(
        name: "Paradouro",
        corporate_name: "Paradouro Teste",
        registration_number: "27.054.751/0001-47",
        phone: "888888888",
        email: "email@email.com",
        description: "Descrição teste",
        pay_methods: "Teste",
        user_policies: "Teste",
        check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
        check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
        owner_id: second_owner.id
      )
      Address.create!(
        street: "Rua da Montanha",
        number: "200",
        neighborhood: "Mata Verde",
        city: "Gramado",
        state: "SC",
        postal_code: "33333-333",
        inn_id: second_inn.id
      )
      second_room = Room.create!(
        name: "Segundo Quarto",
        size: 20,
        max_guests: 2,
        price: 200,
        inn: second_inn
      )

      params = {
        name: "",
        city: "",
        pet_friendly: "0",
        accessibility: "0",
        wifi: "1",
        bathroom: "1",
        air_conditioner: "0",
        wardrobe: "0",
        tv: "0",
        porch: "0",
        safe: "1"
      }

      expect(Inn.advanced_search(params).count).to eq 1
      expect(Inn.advanced_search(params)).to include first_inn
    end

    it "e não encontra pousada por múltiplos parâmetros" do
      first_owner = Owner.create!(
        email: "owner@email.com",
        password: "123456"
      )
      first_inn = Inn.create!(
        name: "Pousada",
        corporate_name: "Pousada Teste",
        registration_number: "62.958.428/0001-07",
        phone: "999999999",
        email: "teste@teste.com",
        description: "Descrição teste",
        pay_methods: "Teste",
        user_policies: "Teste",
        check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
        check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
        owner_id: first_owner.id
      )
      Address.create!(
        street: "Rua da Praia",
        number: "160",
        neighborhood: "Praia Brava",
        city: "Florianópolis",
        state: "SC",
        postal_code: "88888-888",
        inn_id: first_inn.id
      )
      first_room = Room.create!(
        name: "Quarto",
        size: 10,
        max_guests: 1,
        price: 150,
        inn: first_inn,
        wardrobe: true,
        wifi: true
      )
      second_owner = Owner.create!(
        email: "secondowner@email.com",
        password: "654321"
      )
      second_inn = Inn.create!(
        name: "Paradouro",
        corporate_name: "Paradouro Teste",
        registration_number: "27.054.751/0001-47",
        phone: "888888888",
        email: "email@email.com",
        description: "Descrição teste",
        pay_methods: "Teste",
        user_policies: "Teste",
        check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
        check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
        owner_id: second_owner.id
      )
      Address.create!(
        street: "Rua da Montanha",
        number: "200",
        neighborhood: "Mata Verde",
        city: "Gramado",
        state: "SC",
        postal_code: "33333-333",
        inn_id: second_inn.id
      )
      second_room = Room.create!(
        name: "Segundo Quarto",
        size: 20,
        max_guests: 2,
        price: 200,
        inn: second_inn,
        safe: true
      )

      params = {
        name: "",
        city: "",
        pet_friendly: "0",
        accessibility: "0",
        wifi: "1",
        bathroom: "1",
        air_conditioner: "0",
        wardrobe: "0",
        tv: "0",
        porch: "0",
        safe: "1"
      }

      expect(Inn.advanced_search(params).count).to eq 0
    end
  end

  describe "#average_score" do
    it "retorna string vazia se não existem quartos" do
      owner = Owner.create!(email: "dono_1@email.com", password: "123456")
      inn = Inn.create!(
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
        owner: owner
      )
      Address.create!(
        street: "Rua das Flores",
        number: 300,
        neighborhood: "Canasvieiras",
        city: "Florianópolis",
        state: "SC",
        postal_code: "88000-000",
        inn: inn
      )

      expect(inn.average_score).to be_empty
    end

    it "retorna nil se não existem reservas" do
      owner = Owner.create!(email: "dono_1@email.com", password: "123456")
      inn = Inn.create!(
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
        owner: owner
      )
      Address.create!(
        street: "Rua das Flores",
        number: 300,
        neighborhood: "Canasvieiras",
        city: "Florianópolis",
        state: "SC",
        postal_code: "88000-000",
        inn: inn
      )
      room = Room.create!(
        name: "Atlântico",
        description: "Quarto com vista para o mar",
        size: 30,
        max_guests: 2,
        price: 200.00,
        inn: inn
      )

      expect(inn.average_score).to be_empty
    end

    it "retorna nil se não existem avaliações" do
      owner = Owner.create!(email: "dono_1@email.com", password: "123456")
      inn = Inn.create!(
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
        owner: owner
      )
      Address.create!(
        street: "Rua das Flores",
        number: 300,
        neighborhood: "Canasvieiras",
        city: "Florianópolis",
        state: "SC",
        postal_code: "88000-000",
        inn: inn
      )
      room = Room.create!(
        name: "Atlântico",
        description: "Quarto com vista para o mar",
        size: 30,
        max_guests: 2,
        price: 200.00,
        inn: inn
      )
      user = User.create!(
        name: "João Silva",
        cpf: "899.924.320-63",
        email: "joao@email.com",
        password: "123456"
      )
      booking = Booking.create!(
        room: room,
        user: user,
        start_date: Date.today,
        end_date: 5.days.from_now,
        number_of_guests: 2,
        status: :closed
      )

      expect(inn.average_score).to be_empty
    end

    it "retorna a média das avaliações" do
      owner = Owner.create!(email: "dono_1@email.com", password: "123456")
      inn = Inn.create!(
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
        owner: owner
      )
      Address.create!(
        street: "Rua das Flores",
        number: 300,
        neighborhood: "Canasvieiras",
        city: "Florianópolis",
        state: "SC",
        postal_code: "88000-000",
        inn: inn
      )
      room = Room.create!(
        name: "Atlântico",
        description: "Quarto com vista para o mar",
        size: 30,
        max_guests: 2,
        price: 200.00,
        inn: inn
      )
      user = User.create!(
        name: "João Silva",
        cpf: "899.924.320-63",
        email: "joao@email.com",
        password: "123456"
      )
      booking_1 = Booking.create!(
        room: room,
        user: user,
        start_date: Date.today,
        end_date: 5.days.from_now,
        number_of_guests: 2,
        status: :closed
      )
      booking_2 = Booking.create!(
        room: room,
        user: user,
        start_date: Date.today,
        end_date: 5.days.from_now,
        number_of_guests: 2,
        status: :closed
      )
      booking_3 = Booking.create!(
        room: room,
        user: user,
        start_date: Date.today,
        end_date: 5.days.from_now,
        number_of_guests: 2,
        status: :closed
      )
      Review.create!(
        booking: booking_1,
        score: 5
      )
      Review.create!(
        booking: booking_2,
        score: 4
      )

      expect(inn.average_score).to eq 4.5
    end

  end
end
