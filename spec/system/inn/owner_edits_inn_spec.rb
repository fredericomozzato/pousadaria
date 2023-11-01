require "rails_helper"

describe "Proprietário acessa a página de sua pousada" do
  it "entra no formulário de edição" do
    owner = Owner.create!(
      email: "owner@example.com",
      password: "123456"
    )
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

    login_as owner
    visit root_path
    click_on "Minha Pousada"
    click_on "Editar"

    expect(page).to have_field "Nome", with: "Mar Aberto"
    expect(page).to have_field "Razão social", with: "Pousada Mar Aberto/SC"
    expect(page).to have_field "Telefone", with: "4899999-9999"
    expect(page).to have_field "E-mail", with: "pousadamaraberto@hotmail.com"
    expect(page).to have_field "Descrição", with: "Pousada na beira do mar com suítes e café da manhã incluso."
    expect(page).to have_field "Métodos de pagamento", with: "Crédito, débito, dinheiro ou pix"
    expect(page).to have_field "inn_pet_friendly", type: "checkbox"
    expect(page).to have_field "Políticas de uso", with: "A pousada conta com lei do silêncio das 22h às 8h"
    expect(page).to have_select "date_checkin_hour"
    expect(page).to have_select "date_checkin_minute"
    expect(page).to have_select "date_checkout_hour"
    expect(page).to have_select "date_checkout_minute"
    expect(page).to have_field "Rua", with: "Rua das Flores"
    expect(page).to have_field "Número", with: 300
    expect(page).to have_field "Bairro", with: "Canasvieiras"
    expect(page).to have_field "Cidade", with: "Florianópolis"
    expect(page).to have_field "Estado", with: "SC"
    expect(page).to have_field "CEP", with: "88000-000"
    expect(page).to have_button "Atualizar Pousada"
  end
end
