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

  it "e edita a pousada com sucesso" do
    owner = Owner.create!(
      email: "owner@email.com",
      password: "123456"
    )
    inn = Inn.create!(
      name: "Pousada",
      corporate_name: "Pousada Teste",
      registration_number: "1234567890",
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
      street: "Teste",
      number: 0,
      neighborhood: "Teste",
      city: "Teste",
      state: "Teste",
      postal_code: "0123456789",
      inn_id: inn.id
    )

    login_as(owner)
    visit minha_pousada_path
    click_on "Editar"

    fill_in "Nome", with: "Mar Aberto"
    fill_in "Razão social", with: "Pousada Mar Aberto/SC"
    fill_in "CNPJ", with: "84.485.218/0001-73"
    fill_in "Telefone", with: "4899999-9999"
    fill_in "E-mail", with: "pousadamaraberto@hotmail.com"
    fill_in "Descrição", with: "Pousada na beira do mar com suítes e café da manhã incluso."
    fill_in "Métodos de pagamento", with: "Crédito, débito, dinheiro ou pix"
    check "Aceita pets"
    fill_in "Políticas de uso", with: "A pousada conta com lei do silêncio das 22h às 8h"
    select "10", from: "date_checkin_hour"
    select "00", from: "date_checkin_minute"
    select "17", from: "date_checkout_hour"
    select "45", from: "date_checkout_minute"
    fill_in "Rua", with: "Rua das Flores"
    fill_in "Número", with: 300
    fill_in "Bairro", with: "Canasvieiras"
    fill_in "Cidade", with: "Florianópolis"
    fill_in "Estado", with: "SC"
    fill_in "CEP", with: "88000-000"
    click_on "Atualizar Pousada"

    expect(page).to have_content "Pousada atualizada com sucesso"
    expect(page).to have_content "Nome público: Mar Aberto"
    expect(page).to have_content "Razão social: Pousada Mar Aberto/SC"
    expect(page).to have_content "CNPJ: 84.485.218/0001-73"
    expect(page).to have_content "Telefone: 4899999-9999"
    expect(page).to have_content "E-mail: pousadamaraberto@hotmail.com"
    expect(page).to have_content "Descrição: Pousada na beira do mar com suítes e café da manhã incluso."
    expect(page).to have_content "Métodos de pagamento: Crédito, débito, dinheiro ou pix"
    expect(page).to have_content "Aceita pets: sim"
    expect(page).to have_content "Políticas de uso: A pousada conta com lei do silêncio das 22h às 8h"
    expect(page).to have_content "Check-in: a partir das 10:00"
    expect(page).to have_content "Check-out: até as 17:45"
    expect(page).to have_content "Endereço: Rua das Flores, 300"
    expect(page).to have_content "Canasvieiras - Florianópolis, SC"
    expect(page).to have_content "CEP: 88000-000"
    expect(page).to have_content "Status na plataforma: Ativa"
  end

  it "e deixa campos obrigatórios vazios" do
    owner = Owner.create!(
      email: "owner@email.com",
      password: "123456"
    )
    inn = Inn.create!(
      name: "Pousada",
      corporate_name: "Pousada Teste",
      registration_number: "1234567890",
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
      street: "Teste",
      number: 0,
      neighborhood: "Teste",
      city: "Teste",
      state: "Teste",
      postal_code: "0123456789",
      inn_id: inn.id
    )

    login_as(owner)
    visit minha_pousada_path
    click_on "Editar"

    fill_in "Nome", with: "Mar Aberto"
    fill_in "Razão social", with: "Pousada Mar Aberto/SC"
    fill_in "CNPJ", with: ""
    fill_in "Telefone", with: "4899999-9999"
    fill_in "E-mail", with: "pousadamaraberto@hotmail.com"
    fill_in "Descrição", with: "Pousada na beira do mar com suítes e café da manhã incluso."
    fill_in "Métodos de pagamento", with: "Crédito, débito, dinheiro ou pix"
    check "Aceita pets"
    fill_in "Políticas de uso", with: "A pousada conta com lei do silêncio das 22h às 8h"
    select "10", from: "date_checkin_hour"
    select "00", from: "date_checkin_minute"
    select "17", from: "date_checkout_hour"
    select "45", from: "date_checkout_minute"
    fill_in "Rua", with: "Rua das Flores"
    fill_in "Número", with: 300
    fill_in "Bairro", with: ""
    fill_in "Cidade", with: "Florianópolis"
    fill_in "Estado", with: "SC"
    fill_in "CEP", with: "88000-000"
    click_on "Atualizar Pousada"

    expect(page).to have_content "Erro ao atualizar Pousada"
    expect(page).to have_content "CNPJ não pode ficar em branco"
    expect(page).to have_content "Bairro não pode ficar em branco"
    expect(page).to have_field "Nome", with: "Mar Aberto"
    expect(page).to have_field "Rua", with: "Rua das Flores"
  end
end
