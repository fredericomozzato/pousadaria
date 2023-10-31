require "rails_helper"

describe "Usuário acessa a página de cadastro" do
  it "a partir da página inicial" do
    visit root_path
    click_on "Entrar"
    click_on "Nova conta"

    expect(page).to have_field "E-mail"
    expect(page).to have_field "Senha"
    expect(page).to have_field "Confirmar senha"
    expect(page).to have_button "Criar conta"
  end
end
