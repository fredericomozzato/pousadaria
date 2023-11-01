require "rails_helper"

describe "Proprietário visita a página de cadastro de pousada" do
  it "a partir da tela inicial" do
    owner = Owner.create!(email: "owner@email.com", password: "123456")

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
    expect(page).to have_field "Horário de check-in"
    expect(page).to have_field "Horário de check-out"
    expect(page).to have_field "Rua"
    expect(page).to have_field "Número"
    expect(page).to have_field "Bairro"
    expect(page).to have_field "Cidade"
    expect(page).to have_field "Estado"
    expect(page).to have_field "CEP"
    expect(page).to have_field "Ativa"
    expect(page).to have_button "Criar Pousada"
  end
end
