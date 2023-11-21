require "rails_helper"

describe "Proprietário acessa a página de cadastro" do
  it "a partir da página inicial" do
    visit root_path
    click_on "Entrar"
    click_on "Proprietário"
    click_on "Criar conta"

    expect(page).to have_content "Nova conta - Proprietário"
    expect(page).to have_field "E-mail"
    expect(page).to have_field "Senha"
    expect(page).to have_field "Confirmar senha"
    expect(page).to have_button "Criar conta"
  end

  it "e cria uma nova conta" do
    visit new_owner_registration_path
    fill_in "E-mail", with: "owner@example.com"
    fill_in "Senha", with: "123456"
    fill_in "Confirmar senha", with: "123456"
    click_on "Criar conta"

    within "nav" do
      expect(page).to have_content "owner@example.com"
      expect(page).to have_button "Sair"
    end
    expect(current_path).to eq new_inn_path
  end
end
