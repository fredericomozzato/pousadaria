require "rails_helper"

describe "Proprietário acessa formulário de cadastro de quarto" do
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
      click_on "Novo Quarto"

      expect(page).to have_content "Novo Quarto"
      expect(page).to have_field "Nome", type: "text"
      expect(page).to have_field "Descrição", type: "text"
      expect(page).to have_field "Tamanho (m²)", type: "number"
      expect(page).to have_field "Número máximo de hóspedes", type: "number"
      expect(page).to have_field "Valor da diária", type: "number"
      expect(page).to have_content "Comodidades"
      expect(page).to have_field "Banheiro privativo", type: "checkbox"
      expect(page).to have_field "Varanda", type: "checkbox"
      expect(page).to have_field "Ar-condicionado", type: "checkbox"
      expect(page).to have_field "Televisão", type: "checkbox"
      expect(page).to have_field "Guarda-roupas", type: "checkbox"
      expect(page).to have_field "Cofre", type: "checkbox"
      expect(page).to have_field "Acessibilidade", type: "checkbox"
      expect(page).to have_field "Wi-fi", type: "checkbox"
      expect(page).to have_field "Disponível para reservas", type: "checkbox"
      expect(page).to have_button "Salvar Quarto"
    end

    it "e cadastra um quarto com sucesso" do
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
      visit new_room_path
      fill_in "Nome", with: "Oceano Atlântico"
      fill_in "Descrição", with: "Quarto com vista para o oceano Atlântico"
      fill_in "Tamanho (m²)", with: 30
      fill_in "Número máximo de hóspedes", with: 2
      fill_in "Valor da diária", with: 200
      check "Banheiro privativo"
      check "Varanda"
      check "Ar-condicionado"
      check "Guarda-roupas"
      check "Acessibilidade"
      check "Wi-fi"
      click_on "Salvar Quarto"

      expect(page).to have_content "Quarto cadastrado com sucesso"
      expect(page).to have_content "Quarto: Oceano Atlântico"
      expect(page).to have_content "Descrição: Quarto com vista para o oceano Atlântico"
      expect(page).to have_content "Tamanho: 30 m²"
      expect(page).to have_content "Número máximo de hóspedes: 2"
      expect(page).to have_content "Valor da diária: R$ 200,00"
      expect(page).to have_content "Comodidades:"
      within ".ammenities" do
        expect(page).to have_content "Banheiro privativo: sim"
        expect(page).to have_content "Varanda: sim"
        expect(page).to have_content "Ar-condicionado: sim"
        expect(page).to have_content "Guarda-roupas: sim"
        expect(page).to have_content "Acessibilidade: sim"
        expect(page).to have_content "Wi-fi: sim"
      end
      expect(page).to have_content "Disponível para reservas: sim"
      expect(page).to have_link "Editar Quarto"
      expect(Room.last.inn).to eq(inn)
    end

    it "e não cadastra um quarto com campos vazios" do
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
      visit new_room_path
      fill_in "Nome", with: ""
      fill_in "Descrição", with: ""
      fill_in "Tamanho (m²)", with: ""
      fill_in "Número máximo de hóspedes", with: ""
      fill_in "Valor da diária", with: ""
      click_on "Salvar Quarto"

      expect(page).to have_content "Erro ao cadastrar quarto"
      expect(page).to have_content "Nome não pode ficar em branco"
      expect(page).to have_content "Tamanho (m²) não pode ficar em branco"
      expect(page).to have_content "Número máximo de hóspedes não pode ficar em branco"
      expect(page).to have_content "Valor da diária não pode ficar em branco"
      expect(page).to have_field "Nome", with: ""
      expect(page).to have_field "Descrição", with: ""
      expect(page).to have_field "Tamanho (m²)", with: ""
      expect(page).to have_field "Número máximo de hóspedes", with: ""
      expect(page).to have_field "Valor da diária", with: ""
      expect(page).not_to have_checked_field "Banheiro privativo"
      expect(page).not_to have_checked_field "Varanda"
      expect(page).not_to have_checked_field "Ar-condicionado"
      expect(page).not_to have_checked_field "Guarda-roupas"
      expect(page).not_to have_checked_field "Acessibilidade"
      expect(page).not_to have_checked_field "Wi-fi"
      expect(page).to have_button "Salvar Quarto"
    end
  end

  context "não autenticado" do
    it "e é redirecionado para a página de login" do
      visit new_room_path

      expect(current_path).to eq(new_owner_session_path)
    end
  end
end
