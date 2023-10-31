require "rails_helper"

describe "Usuário visita a página inicial" do
  it "e vê o menu" do
    visit root_path

    within("nav") do
      expect(page).to have_content "Pousadaria"
      expect(page).to have_content "Entrar"
    end
    expect(page).to have_content "Nenhuma pousada cadastrada"
  end
end
