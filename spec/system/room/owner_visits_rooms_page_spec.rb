require "rails_helper"

describe "Proprietário acessa página de quartos" do
  context "autenticado" do
    it "a partir da página inicial" do
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

      login_as(owner)
      visit root_path
      click_on "Minha Pousada"
      click_on "Quartos"

      expect(page).to have_content "Quartos: Mar Aberto"
      expect(page).to have_content "Nenhum quarto cadastrado"
      expect(page).to have_link "Novo Quarto"
    end

    it "vê uma lista de quartos cadastrados" do
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
        inn_id: inn.id
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

      expect(page).to have_content "Quartos: Mar Aberto"
      expect(page).to have_content "Quarto"
      expect(page).to have_content "Oceano"
      expect(page).to have_content "Quarto com vista para o mar"
      expect(page).to have_content "30 m²"
      expect(page).to have_content "Hóspedes: 2"
      expect(page).to have_content "Diária: R$ 200,00"
      expect(page).to have_content "Quarto"
      expect(page).to have_content "Montanha"
      expect(page).to have_content "Quarto com vista para a montanha"
      expect(page).to have_content "25 m²"
      expect(page).to have_content "Hóspedes: 4"
      expect(page).to have_content "Diária: R$ 250,00"
      expect(page).to have_content "Quarto"
      expect(page).to have_content "Campo"
      expect(page).to have_content "Quarto com vista para o campo"
      expect(page).to have_content "20 m²"
      expect(page).to have_content "Hóspedes: 3"
      expect(page).to have_content "Diária: R$ 225,50"
    end
  end
end
