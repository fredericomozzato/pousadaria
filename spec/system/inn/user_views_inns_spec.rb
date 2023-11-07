require "rails_helper"

describe "Usuário visita uma pousada" do
  it "na lista de pousadas recentes" do
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

      visit root_path
      within "#recent" do
        click_on "Mar Aberto"
      end

      expect(current_path).to eq inn_path(first_inn)
      expect(page).to have_content "Nome: Mar Aberto"
      expect(page).not_to have_content "Razão social: Pousada Mar Aberto/SC"
      expect(page).not_to have_content "CNPJ: 84.485.218/0001-73"
      expect(page).not_to have_content "Status na platafora: Ativa"
      expect(page).to have_content "Telefone: 4899999-9999"
      expect(page).to have_content "E-mail: pousadamaraberto@hotmail.com"
      expect(page).to have_content "Descrição: Pousada na beira do mar com suítes e café da manhã incluso."
      expect(page).to have_content "Métodos de pagamento: Crédito, débito, dinheiro ou pix"
      expect(page).to have_content "Aceita pets: sim"
      expect(page).to have_content "Políticas de uso: A pousada conta com lei do silêncio das 22h às 8h"
      expect(page).to have_content "Check-in: a partir das 9:00"
      expect(page).to have_content "Check-out: até as 15:30"
      expect(page).to have_content "Endereço: Rua das Flores, 300"
      expect(page).to have_content "Canasvieiras - Florianópolis, SC"
      expect(page).to have_content "CEP: 88000-000"
  end
end
