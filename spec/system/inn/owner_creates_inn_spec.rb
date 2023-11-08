require "rails_helper"

describe "Proprietário visita a página de cadastro de pousada" do
  it "e vê o formulário" do
    owner = Owner.create!(email: "owner@email.com", password: "123456")

    login_as(owner)
    visit new_inn_path

    expect(page).to have_content "Cadastro de Pousada"
    expect(page).to have_field "Nome"
    expect(page).to have_field "Razão social"
    expect(page).to have_field "CNPJ"
    expect(page).to have_field "Telefone"
    expect(page).to have_field "E-mail"
    expect(page).to have_field "Descrição"
    expect(page).to have_field "Métodos de pagamento"
    expect(page).to have_field "Aceita pets"
    expect(page).to have_field "Políticas de uso"
    expect(page).to have_content "Horário de check-in"
    expect(page).to have_select "date_checkin_hour"
    expect(page).to have_select "date_checkin_minute"
    expect(page).to have_content "Horário de check-out"
    expect(page).to have_select "date_checkout_hour"
    expect(page).to have_select "date_checkout_minute"
    expect(page).to have_field "Logradouro"
    expect(page).to have_field "Número"
    expect(page).to have_field "Bairro"
    expect(page).to have_field "Cidade"
    expect(page).to have_select "Estado"
    expect(page).to have_field "CEP"
    expect(page).to have_button "Criar Pousada"
  end

  it "e cadastra uma nova pousada com sucesso" do
    owner = Owner.create!(email: "owner@email.com", password: "123456")

    login_as(owner)
    visit new_inn_path

    fill_in "Nome", with: "Mar Aberto"
    fill_in "Razão social", with: "Pousada Mar Aberto/SC"
    fill_in "CNPJ", with: "84.485.218/0001-73"
    fill_in "Telefone", with: "4899999-9999"
    fill_in "E-mail", with: "pousadamaraberto@hotmail.com"
    fill_in "Descrição", with: "Pousada na beira do mar com suítes e café da manhã incluso."
    fill_in "Métodos de pagamento", with: "Crédito, débito, dinheiro ou pix"
    check "Aceita pets"
    fill_in "Políticas de uso", with: "A pousada conta com lei do silêncio das 22h às 8h"
    select "09", from: "date_checkin_hour"
    select "00", from: "date_checkin_minute"
    select "15", from: "date_checkout_hour"
    select "30", from: "date_checkout_minute"
    fill_in "Logradouro", with: "Rua das Flores"
    fill_in "Número", with: "300"
    fill_in "Bairro", with: "Canasvieiras"
    fill_in "Cidade", with: "Florianópolis"
    select "SC", from: "inn_address_attributes_state"
    fill_in "CEP", with: "88000-000"
    click_on "Criar Pousada"

    expect(page).to have_content "Pousada criada com sucesso"
    expect(page).to have_content "Nome público: Mar Aberto"
    expect(page).to have_content "Razão social: Pousada Mar Aberto/SC"
    expect(page).to have_content "CNPJ: 84.485.218/0001-73"
    expect(page).to have_content "Telefone: 4899999-9999"
    expect(page).to have_content "E-mail: pousadamaraberto@hotmail.com"
    expect(page).to have_content "Descrição: Pousada na beira do mar com suítes e café da manhã incluso."
    expect(page).to have_content "Métodos de pagamento: Crédito, débito, dinheiro ou pix"
    expect(page).to have_content "Aceita pets: sim"
    expect(page).to have_content "Políticas de uso: A pousada conta com lei do silêncio das 22h às 8h"
    expect(page).to have_content "Horário de check-in: a partir das 9:00"
    expect(page).to have_content "Horário de check-out: até as 15:30"
    expect(page).to have_content "Endereço: Rua das Flores, 300"
    expect(page).to have_content "Canasvieiras - Florianópolis, SC"
    expect(page).to have_content "CEP: 88000-000"
    expect(page).to have_content "Status na plataforma: Ativa"
    expect(page).to have_link "Editar"
    expect(Inn.last.owner_id).to eq(owner.id)
  end

  it "quando já tem uma pousada cadastrada" do
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
    visit new_inn_path

    expect(page).to have_content "Você já tem uma pousada cadastrada"
    expect(current_path).to eq inn_path(inn)
  end

  it "e tenta cadastrar pousada com dados incompletos" do
    owner = Owner.create!(email: "owner@email.com", password: "123456")

    login_as(owner)
    visit new_inn_path
    fill_in "Nome", with: "Mar Aberto"
    fill_in "Razão social", with: ""
    fill_in "CNPJ", with: "84.485.218/0001-73"
    fill_in "Telefone", with: "4899999-9999"
    fill_in "E-mail", with: ""
    fill_in "Descrição", with: ""
    fill_in "Métodos de pagamento", with: "Crédito, débito, dinheiro ou pix"
    check "Aceita pets"
    fill_in "Políticas de uso", with: ""
    select "09", from: "date_checkin_hour"
    select "00", from: "date_checkin_minute"
    select "15", from: "date_checkout_hour"
    select "30", from: "date_checkout_minute"
    fill_in "Logradouro", with: ""
    fill_in "Número", with: ""
    fill_in "Bairro", with: ""
    fill_in "Cidade", with: "Florianópolis"
    select "SC", from: "inn_address_attributes_state"
    fill_in "CEP", with: "88000-000"
    click_on "Criar Pousada"

    expect(page).to have_content "Erro ao cadastrar Pousada"
    expect(page).to have_content "Razão social não pode ficar em branco"
    expect(page).to have_content "E-mail não pode ficar em branco"
    expect(page).to have_content "Logradouro não pode ficar em branco"
    expect(page).to have_content "Bairro não pode ficar em branco"
    expect(page).to have_field "Nome", with: "Mar Aberto"
    expect(page).to have_field "CNPJ", with: "84.485.218/0001-73"
    expect(page).to have_field "Métodos de pagamento", with: "Crédito, débito, dinheiro ou pix"
    expect(page).to have_field "Cidade", with: "Florianópolis"
    expect(page).to have_field "Estado", with: "SC"
  end
end
