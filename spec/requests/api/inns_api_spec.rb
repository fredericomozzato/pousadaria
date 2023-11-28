require "rails_helper"

RSpec.describe "Inns API", type: :request do
  context "GET /api/v1/inns" do
    it "retorna 200 e array vazio se não houverem pousadas cadastradas" do
      get "/api/v1/inns"

      expect(response).to have_http_status 200
      expect(response.body).to eq "[]"
    end

    it "retorna todas as pousadas ativas" do
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
        pet_friendly: true,
        check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
        check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
        owner: owner_2,
        active: false
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
        pet_friendly: false,
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

      get api_v1_inns_path
      json_response = JSON.parse(response.body)

      expect(response).to have_http_status 200
      expect(response.content_type).to include "application/json"
      expect(json_response.count).to eq 2
      expect(json_response.first["id"]).to eq inn_1.id
      expect(json_response.first["name"]).to eq inn_1.name
      expect(json_response.first["phone"]).to eq inn_1.phone
      expect(json_response.first["email"]).to eq inn_1.email
      expect(json_response.first["description"]).to eq inn_1.description
      expect(json_response.first["pay_methods"]).to eq inn_1.pay_methods
      expect(json_response.first["pet_friendly"]).to eq inn_1.pet_friendly
      expect(json_response.first["user_policies"]).to eq inn_1.user_policies
      expect(json_response.first["formatted_check_in_time"]).to eq inn_1.check_in_time.strftime("%H:%M")
      expect(json_response.first["formatted_check_out_time"]).to eq inn_1.check_out_time.strftime("%H:%M")
      expect(json_response.first["average_score"]).to eq ""
      expect(json_response.first["address"]["street"]).to eq inn_1.address.street
      expect(json_response.first["address"]["number"]).to eq inn_1.address.number
      expect(json_response.first["address"]["neighborhood"]).to eq inn_1.address.neighborhood
      expect(json_response.first["address"]["city"]).to eq inn_1.address.city
      expect(json_response.first["address"]["state"]).to eq inn_1.address.state
      expect(json_response.first["address"]["postal_code"]).to eq inn_1.address.postal_code
      expect(json_response.first).not_to include "corporate_name"
      expect(json_response.first).not_to include "registration_number"
      expect(json_response.second["id"]).to eq inn_3.id
      expect(json_response.second["name"]).to eq inn_3.name
      expect(json_response.second["phone"]).to eq inn_3.phone
      expect(json_response.second["email"]).to eq inn_3.email
      expect(json_response.second["description"]).to eq inn_3.description
      expect(json_response.second["pay_methods"]).to eq inn_3.pay_methods
      expect(json_response.second["pet_friendly"]).to eq inn_3.pet_friendly
      expect(json_response.second["user_policies"]).to eq inn_3.user_policies
      expect(json_response.second["formatted_check_in_time"]).to eq inn_3.check_in_time.strftime("%H:%M")
      expect(json_response.second["formatted_check_out_time"]).to eq inn_3.check_out_time.strftime("%H:%M")
      expect(json_response.second["address"]["street"]).to eq inn_3.address.street
      expect(json_response.second["address"]["number"]).to eq inn_3.address.number
      expect(json_response.second["address"]["neighborhood"]).to eq inn_3.address.neighborhood
      expect(json_response.second["address"]["city"]).to eq inn_3.address.city
      expect(json_response.second["address"]["state"]).to eq inn_3.address.state
      expect(json_response.second["address"]["postal_code"]).to eq inn_3.address.postal_code
      expect(json_response.second).not_to include "corporate_name"
      expect(json_response.second).not_to include "registration_number"
    end

    it "e retorna uma pousada específica com parâmetro de busca" do
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
        pet_friendly: true,
        check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
        check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
        owner: owner_2,
        active: false
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
        pet_friendly: false,
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
      query = "mar"

      # /api/v1/inns?name=mar
      get api_v1_inns_path(name: query)
      json_response = JSON.parse(response.body)

      expect(response).to have_http_status 200
      expect(response.content_type).to include "application/json"
      expect(json_response.count).to eq 1
      expect(json_response.first["id"]).to eq inn_1.id
      expect(json_response.first["name"]).to eq inn_1.name
      expect(json_response).not_to include "Morro Azul"
      expect(json_response).not_to include "Ilha da Magia"
    end

    it "retorna 200 e um array vazio se não encontrar pousadas com o parâmetro de busca" do
      query = "mar"
      get api_v1_inns_path(name: query)

      expect(response).to have_http_status 200
      expect(response.content_type).to include "application/json"
      expect(response.body).to eq "[]"
    end
  end

  context "GET /api/v1/inns/:id" do
    it "retorna uma pousada específica por id" do
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
        pet_friendly: true,
        check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
        check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
        owner: owner_2,
        active: false
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
      user = User.create!(
        name: "João Silva",
        cpf: "899.924.320-63",
        email: "joao@email.com",
        password: "123456"
      )
      room = Room.create!(
        name: "Atlântico",
        description: "Quarto com vista para o mar",
        size: 30,
        max_guests: 2,
        price: 200.00,
        inn: inn_1,
        bathroom: true,
        wifi: true,
        wardrobe: true,
        accessibility: true
      )
      booking_1 = Booking.create!(
        room: room,
        user: user,
        start_date: Date.today,
        end_date: 5.days.from_now,
        number_of_guests: 2,
        status: :closed
      )
      review_1 = Review.create!(
        score: 3,
        booking: booking_1
      )
      booking_2 = Booking.create!(
        room: room,
        user: user,
        start_date: Date.today,
        end_date: 5.days.from_now,
        number_of_guests: 2,
        status: :closed
      )
      review_2 = Review.create!(
        score: 4,
        booking: booking_2
      )
      booking_3 = Booking.create!(
        room: room,
        user: user,
        start_date: Date.today,
        end_date: 5.days.from_now,
        number_of_guests: 2,
        status: :closed
      )
      review_3 = Review.create!(
        score: 4,
        booking: booking_3
      )

      get api_v1_inn_path(inn_1.id)
      json_response = JSON.parse(response.body)

      expect(response).to have_http_status 200
      expect(response.content_type).to include "application/json"
      expect(json_response["name"]).to eq inn_1.name
      expect(json_response["phone"]).to eq inn_1.phone
      expect(json_response["email"]).to eq inn_1.email
      expect(json_response["description"]).to eq inn_1.description
      expect(json_response["pay_methods"]).to eq inn_1.pay_methods
      expect(json_response["pet_friendly"]).to eq inn_1.pet_friendly
      expect(json_response["user_policies"]).to eq inn_1.user_policies
      expect(json_response["formatted_check_in_time"]).to eq inn_1.check_in_time.strftime("%H:%M")
      expect(json_response["formatted_check_out_time"]).to eq inn_1.check_out_time.strftime("%H:%M")
      expect(json_response["average_score"]).to eq "3.7"
      expect(json_response["address"]["street"]).to eq inn_1.address.street
      expect(json_response["address"]["number"]).to eq inn_1.address.number
      expect(json_response["address"]["neighborhood"]).to eq inn_1.address.neighborhood
      expect(json_response["address"]["city"]).to eq inn_1.address.city
      expect(json_response["address"]["state"]).to eq inn_1.address.state
      expect(json_response["address"]["postal_code"]).to eq inn_1.address.postal_code
      expect(json_response).not_to include "corporate_name"
      expect(json_response).not_to include "registration_number"
      expect(json_response).not_to include "owner_id"
      expect(response.body).not_to include inn_2.name
    end

    it "retorna 404 se id não existe" do
      get api_v1_inn_path(999)

      expect(response).to have_http_status 404
      expect(response.content_type).to include "application/json"
      expect(response.body).to include "Pousada não encontrada"
    end

    it "retorna 404 se pousada está inativa" do
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
        owner: owner,
        active: false
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

      get api_v1_inn_path(inn.id)
      json_response = JSON.parse(response.body)

      expect(response).to have_http_status 404
      expect(response.content_type).to include "application/json"
      expect(json_response["erro"]).to eq "Pousada não encontrada"
    end

    it "retorna 500 em caso de erros internos" do
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

      allow(Inn).to receive(:find_by).and_raise(ActiveRecord::ActiveRecordError)
      get api_v1_inn_path(inn.id)

      expect(response).to have_http_status 500
      expect(response.body).to include "Tente novamente mais tarde"
    end
  end

  context "GET /api/v1/inn/:inns_id/rooms" do
    it "retorna lista vazia e status 200 se não existem quartos" do
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

      get api_v1_inn_rooms_path(inn.id)
      json_response = JSON.parse(response.body)

      expect(response).to have_http_status 200
      expect(response.content_type).to include "application/json"
      expect(json_response).to be_empty
    end

    it "retorna lista com todos os quartos ativos de uma pousada" do
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
      room_1 = Room.create!(
        name: "Atlântico",
        description: "Quarto com vista para o mar",
        size: 30,
        max_guests: 2,
        price: 200.00,
        inn: inn,
        bathroom: true,
        wifi: true,
        wardrobe: true,
        accessibility: true
      )
      room_2 = Room.create!(
        name: "Pacífico",
        description: "Quarto com vista para o mar",
        size: 50,
        max_guests: 4,
        price: 350.00,
        inn: inn,
        bathroom: true,
        wifi: true,
        wardrobe: true,
        accessibility: true
      )
      inactive_room = Room.create!(
        name: "Índico",
        description: "Quarto com vista para o mar",
        size: 40,
        max_guests: 3,
        price: 250.00,
        inn: inn,
        bathroom: true,
        wifi: true,
        wardrobe: true,
        accessibility: true,
        active: false
      )

      get api_v1_inn_rooms_path(inn.id)
      json_response = JSON.parse(response.body)

      expect(response).to have_http_status 200
      expect(response.content_type).to include "application/json"
      expect(json_response.count).to eq 2
      expect(json_response.first["id"]).to eq room_1.id
      expect(json_response.first["name"]).to eq room_1.name
      expect(json_response.first["description"]).to eq room_1.description
      expect(json_response.first["size"]).to eq room_1.size
      expect(json_response.first["max_guests"]).to eq room_1.max_guests
      expect(json_response.first["price"]).to eq room_1.price.to_s
      expect(json_response.first["bathroom"]).to eq room_1.bathroom
      expect(json_response.first["porch"]).to eq room_1.porch
      expect(json_response.first["air_conditioner"]).to eq room_1.air_conditioner
      expect(json_response.first["tv"]).to eq room_1.tv
      expect(json_response.first["wardrobe"]).to eq room_1.wardrobe
      expect(json_response.first["safe"]).to eq room_1.safe
      expect(json_response.first["wifi"]).to eq room_1.wifi
      expect(json_response.first["accessibility"]).to eq room_1.accessibility
      expect(json_response.first).not_to include room_1.created_at
      expect(json_response.first).not_to include room_1.updated_at
      expect(json_response.first).not_to include room_1.inn_id
      expect(json_response.second["id"]).to eq room_2.id
      expect(json_response.second["name"]).to eq room_2.name
      expect(json_response.second["description"]).to eq room_2.description
      expect(json_response.second["size"]).to eq room_2.size
      expect(json_response.second["max_guests"]).to eq room_2.max_guests
      expect(json_response.second["price"]).to eq room_2.price.to_s
      expect(json_response.second["bathroom"]).to eq room_2.bathroom
      expect(json_response.second["porch"]).to eq room_2.porch
      expect(json_response.second["air_conditioner"]).to eq room_2.air_conditioner
      expect(json_response.second["tv"]).to eq room_2.tv
      expect(json_response.second["wardrobe"]).to eq room_2.wardrobe
      expect(json_response.second["safe"]).to eq room_2.safe
      expect(json_response.second["wifi"]).to eq room_2.wifi
      expect(json_response.second["accessibility"]).to eq room_2.accessibility
      expect(json_response.second).not_to include room_2.created_at
      expect(json_response.second).not_to include room_2.updated_at
      expect(json_response.second).not_to include room_2.inn_id
      expect(response.body).not_to include inactive_room.name
    end

    it "retorna 404 NOT FOUND se pousada não existe ou está inativa" do
      get api_v1_inn_rooms_path(999)

      expect(response).to have_http_status 404
      expect(response.content_type).to include "application/json"
      expect(response.body).to include "Pousada não encontrada"
    end
  end

  context "GET /api/v1/bookings/pre-booking" do
    it "retorna valor da reserva se período disponível" do
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
        inn: inn,
        bathroom: true,
        wifi: true,
        wardrobe: true,
        accessibility: true
      )

      # get "/api/v1/bookings/pre-booking?room_id=#{room.id}&start_date=#{1.day.from_now}
      #                                  &end_date=#{5.days.from_now}&number_of_guests=2"
      get pre_booking_api_v1_bookings_path(
        room_id: room.id,
        start_date: 1.day.from_now,
        end_date: 5.days.from_now,
        number_of_guests: 2
      )
      json_response = JSON.parse(response.body)

      expect(response).to have_http_status 200
      expect(response.content_type).to include "application/json"
      expect(json_response["valor"]).to eq 800.0
    end

    it "retorna 409 CONFLICT se período indisponível" do
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
        inn: inn,
        bathroom: true,
        wifi: true,
        wardrobe: true,
        accessibility: true
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
        start_date: 1.day.from_now,
        end_date: 5.days.from_now,
        number_of_guests: 2
      )

      get pre_booking_api_v1_bookings_path(
        room_id: room.id,
        start_date: 2.days.from_now,
        end_date: 5.days.from_now,
        number_of_guests: 3
      )
      json_response = JSON.parse(response.body)

      expect(response).to have_http_status 409
      expect(response.content_type).to include "application/json"
      expect(json_response["erro"]).to include "Já existe uma reserva para este quarto no período selecionado"
      expect(json_response["erro"]).to include "Número de hóspedes maior que o permitido para o quarto"
    end

    it "retorna 404 NOT FOUND se quarto não existe" do
      get pre_booking_api_v1_bookings_path(
        room_id: 999,
        start_date: 1.day.from_now,
        end_date: 5.days.from_now,
        number_of_guests: 2
      )

      expect(response).to have_http_status 404
    end

    it "retorna 409 CONFLICT se quarto está inativo" do
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
        inn: inn,
        active: false
      )

      get pre_booking_api_v1_bookings_path(
        room_id: room.id,
        start_date: 1.day.from_now,
        end_date: 5.days.from_now,
        number_of_guests: 2
      )
      json_response = JSON.parse(response.body)

      expect(response).to have_http_status 409
      expect(json_response["erro"]).to include "Quarto indisponível"
    end
  end

  context "GET /api/v1/inns/cities" do
    it "retorna lista de cidades com pousadas ativas" do
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
        pet_friendly: true,
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
      owner_3 = Owner.create!(email: "dono_3@email.com", password: "fedcba")
      inn_3 = Inn.create!(
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
        owner: owner_3
      )
      Address.create!(
        street: "Servidão da Cachoeira",
        number: 32,
        neighborhood: "Morro da Pedra",
        city: "Uberlândia",
        state: "MG",
        postal_code: "33000-000",
        inn: inn_3
      )
      owner_4 = Owner.create!(email: "dono_4@email.com", password: "zyxwvu")
      inn_4 = Inn.create!(
        name: "Chalés da Roça",
        corporate_name: "Pousada Chalés",
        registration_number: "06.849.772/0001-89",
        phone: "1999987656",
        email: "chalésdaroça@email.com",
        description: "Pousada de campo com café colonial.",
        pay_methods: "Dinheiro, cartão e pix",
        user_policies: "",
        pet_friendly: false,
        check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
        check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
        owner: owner_4,
        active: false
      )
      Address.create!(
        street: "Estrada da Roça",
        number: 1800,
        neighborhood: "São Luiz",
        city: "Campinas",
        state: "SP",
        postal_code: "11000-900",
        inn: inn_4,
      )

      get cities_api_v1_inns_path
      json_response = JSON.parse(response.body)

      expect(response).to have_http_status 200
      expect(response.content_type).to include "application/json"
      expect(json_response["cidades"]).to eq ["Cambará do Sul", "Florianópolis", "Uberlândia"]
    end

    it "retorna status 200 e array vazio se não existem pousadas" do
      get cities_api_v1_inns_path
      json_response = JSON.parse(response.body)

      expect(response).to have_http_status 200
      expect(response.content_type).to include "application/json"
      expect(json_response["cidades"].count).to eq 0
    end
  end

  context "GET /api/v1/inns/cities?name=" do
    it "retorna pousadas cadastradas e ativas na cidade passada como parâmetro" do
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
        pet_friendly: true,
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
        pet_friendly: false,
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
      owner_4 = Owner.create!(email: "dono_4@email.com", password: "zyxwvu")
      inn_4 = Inn.create!(
        name: "Vento Sul",
        corporate_name: "PVS Pousada",
        registration_number: "72.153.926/0001-28",
        phone: "48989998998",
        email: "pousadaventosul@email.com",
        description: "Pousada na beira da praia.",
        pay_methods: "Dinheiro, cartão e pix",
        user_policies: "",
        pet_friendly: false,
        check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
        check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
        owner: owner_4,
        active: false
      )
      Address.create!(
        street: "Servidão Ventania",
        number: 100,
        neighborhood: "Pântano do Sul",
        city: "Florianópolis",
        state: "SC",
        postal_code: "88000-800",
        inn: inn_4
      )
      param = "florianopolis"

      get cities_api_v1_inns_path(city: param)
      json_response = JSON.parse(response.body)

      expect(response).to have_http_status 200
      expect(json_response.count).to eq 2
      expect(json_response.first["name"]).to eq inn_1.name
      expect(json_response.last["name"]).to eq inn_3.name
    end

    it "retorna status 200 e array vazio se não existem pousadas na cidade" do
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
      param = "sao paulo"

      get cities_api_v1_inns_path(city: param)

      expect(response).to have_http_status 200
      expect(response.body).to eq "[]"
    end
  end
end
