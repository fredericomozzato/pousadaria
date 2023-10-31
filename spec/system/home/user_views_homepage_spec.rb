require "rails_helper"

describe "Usuário visita a página inicial" do
  context "desautenticado" do
    it "e vê o menu" do
      visit root_path

      within "nav" do
        expect(page).to have_content "Pousadaria"
        expect(page).to have_link "Entrar"
      end
    end

    it "e faz login" do
      User.create!(email: "user@example.com", password: "123456")

      visit root_path
      click_on "Entrar"
      fill_in "E-mail", with: "user@example.com"
      fill_in "Senha", with: "123456"
      within "form" do
        click_on "Entrar"
      end

      within "nav" do
        expect(page).to have_link "Sair"
        expect(page).to have_content "user@example.com"
      end
    end
  end

  context "autenticado" do
    it "e vê o menu" do
      user = User.create!(email: "user@example.com", password: "123456")

      login_as user
      visit root_path

      within "nav" do
        expect(page).to have_content "user@example.com"
        expect(page).to have_link "Sair"
        expect(page).not_to have_link "Entrar"
      end
    end

    it "e faz logout" do
      user = User.create!(email: "user@example.com", password: "123456")

      login_as user
      visit root_path
      within "nav" do
        click_on "Sair"
      end

      expect(page).to have_link "Entrar"
      expect(page).not_to have_link "Sair"
      expect(page).not_to have_content "user@example.com"
    end
  end
end
