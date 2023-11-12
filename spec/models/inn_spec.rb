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
        pet_friendly: false,
        accessibility: false,
        wifi: false,
        bathroom: false,
        air_conditioner: false,
        wardrobe: false,
        tv: false,
        porch: false,
        safe: false
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
        pet_friendly: false,
        accessibility: false,
        wifi: false,
        bathroom: false,
        air_conditioner: false,
        wardrobe: false,
        tv: false,
        porch: false,
        safe: false
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
        pet_friendly: false,
        accessibility: false,
        wifi: false,
        bathroom: false,
        air_conditioner: false,
        wardrobe: false,
        tv: false,
        porch: false,
        safe: false
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
        pet_friendly: false,
        accessibility: false,
        wifi: false,
        bathroom: false,
        air_conditioner: false,
        wardrobe: false,
        tv: false,
        porch: false,
        safe: false
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
        pet_friendly: true,
        accessibility: false,
        wifi: false,
        bathroom: false,
        air_conditioner: false,
        wardrobe: false,
        tv: false,
        porch: false,
        safe: false
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
        pet_friendly: true,
        accessibility: false,
        wifi: false,
        bathroom: false,
        air_conditioner: false,
        wardrobe: false,
        tv: false,
        porch: false,
        safe: false
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
        pet_friendly: false,
        accessibility: true,
        wifi: false,
        bathroom: false,
        air_conditioner: false,
        wardrobe: false,
        tv: false,
        porch: false,
        safe: false
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
        pet_friendly: false,
        accessibility: true,
        wifi: false,
        bathroom: false,
        air_conditioner: false,
        wardrobe: false,
        tv: false,
        porch: false,
        safe: false
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
        pet_friendly: false,
        accessibility: false,
        wifi: true,
        bathroom: false,
        air_conditioner: false,
        wardrobe: false,
        tv: false,
        porch: false,
        safe: false
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
        pet_friendly: false,
        accessibility: false,
        wifi: true,
        bathroom: false,
        air_conditioner: false,
        wardrobe: false,
        tv: false,
        porch: false,
        safe: false
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
        pet_friendly: false,
        accessibility: false,
        wifi: false,
        bathroom: true,
        air_conditioner: false,
        wardrobe: false,
        tv: false,
        porch: false,
        safe: false
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
        pet_friendly: false,
        accessibility: false,
        wifi: false,
        bathroom: true,
        air_conditioner: false,
        wardrobe: false,
        tv: false,
        porch: false,
        safe: false
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
        pet_friendly: false,
        accessibility: false,
        wifi: false,
        bathroom: false,
        air_conditioner: false,
        wardrobe: true,
        tv: false,
        porch: false,
        safe: false
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
        pet_friendly: false,
        accessibility: false,
        wifi: false,
        bathroom: false,
        air_conditioner: false,
        wardrobe: true,
        tv: false,
        porch: false,
        safe: false
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
        pet_friendly: false,
        accessibility: false,
        wifi: false,
        bathroom: false,
        air_conditioner: false,
        wardrobe: false,
        tv: true,
        porch: false,
        safe: false
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
        pet_friendly: false,
        accessibility: false,
        wifi: false,
        bathroom: false,
        air_conditioner: false,
        wardrobe: false,
        tv: true,
        porch: false,
        safe: false
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
        pet_friendly: false,
        accessibility: false,
        wifi: false,
        bathroom: false,
        air_conditioner: false,
        wardrobe: false,
        tv: false,
        porch: true,
        safe: false
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
        pet_friendly: false,
        accessibility: false,
        wifi: false,
        bathroom: false,
        air_conditioner: false,
        wardrobe: false,
        tv: false,
        porch: true,
        safe: false
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
        pet_friendly: false,
        accessibility: false,
        wifi: false,
        bathroom: false,
        air_conditioner: false,
        wardrobe: false,
        tv: false,
        porch: false,
        safe: true
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
        pet_friendly: false,
        accessibility: false,
        wifi: false,
        bathroom: false,
        air_conditioner: false,
        wardrobe: false,
        tv: false,
        porch: false,
        safe: true
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
        pet_friendly: false,
        accessibility: false,
        wifi: true,
        bathroom: true,
        air_conditioner: false,
        wardrobe: false,
        tv: false,
        porch: false,
        safe: true
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
        pet_friendly: false,
        accessibility: false,
        wifi: true,
        bathroom: true,
        air_conditioner: false,
        wardrobe: false,
        tv: false,
        porch: false,
        safe: true
      }

      expect(Inn.advanced_search(params).count).to eq 0
    end
  end
end
