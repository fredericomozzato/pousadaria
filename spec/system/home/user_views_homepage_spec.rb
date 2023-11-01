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

    it "e faz login como Proprietário" do
      Owner.create!(email: "owner@example.com", password: "123456")

      visit root_path
      click_on "Entrar"
      click_on "Proprietário"
      fill_in "E-mail", with: "owner@example.com"
      fill_in "Senha", with: "123456"
      within "form" do
        click_on "Entrar"
      end

      within "nav" do
        expect(page).to have_link "Sair"
        expect(page).to have_content "owner@example.com"
      end
      expect(current_path).to eq new_inn_path
      expect(page).to have_content "Cadastre sua Pousada!"
    end
  end

  context "autenticado como Proprietário" do
    it "e vê o menu" do
      owner = Owner.create!(email: "owner@example.com", password: "123456")

      login_as owner
      visit root_path

      within "nav" do
        expect(page).to have_content "owner@example.com"
        expect(page).to have_link "Sair"
        expect(page).not_to have_link "Entrar"
      end
    end

    it "e faz logout" do
      owner = Owner.create!(email: "owner@example.com", password: "123456")

      login_as owner
      visit root_path
      within "nav" do
        click_on "Sair"
      end

      expect(page).to have_link "Entrar"
      expect(page).not_to have_link "Sair"
      expect(page).not_to have_content "owner@example.com"
    end
  end
end
