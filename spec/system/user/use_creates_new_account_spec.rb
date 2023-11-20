require "rails_helper"

describe "Usuário acessa a página de cadastro" do
  it "a partir da tela inicial" do
    visit root_path
    click_on "Entrar"
    click_on "Hóspede"
    click_on "Criar conta"

    expect(page).to have_field "Nome completo"
    expect(page).to have_field "CPF"
    expect(page).to have_field "E-mail"
    expect(page).to have_field "Senha"
    expect(page).to have_field "Confirmar senha"
    expect(page).to have_button "Criar conta"
  end

  it "e cria uma nova conta" do
    visit root_path
    click_on "Entrar"
    click_on "Hóspede"
    click_on "Criar conta"
    fill_in "Nome completo", with: "Fulano de Tal"
    fill_in "CPF", with: "159.163.070-39"
    fill_in "E-mail", with: "fulano@email.com"
    fill_in "Senha", with: "123456"
    fill_in "Confirmar senha", with: "123456"
    click_on "Criar conta"

    expect(current_path).to eq root_path
    within "#navigation-bar" do
      expect(page).to have_content "fulano@email.com"
      expect(page).to have_button "Sair"
      expect(page).not_to have_button "Entrar"
    end
    expect(User.all.count).to eq 1
    expect(User.last.name).to eq "Fulano de Tal"
    expect(User.last.cpf).to eq "159.163.070-39"
  end
end
