require "rails_helper"

describe "Usuário acessa o formulário de busca avançada" do
  it "a partir da página inicial" do
    visit root_path
    within "#navigation-bar" do
      click_on "Busca avançada"
    end

    expect(current_path).to eq advanced_search_inns_path
    within "h1" do
      expect(page).to have_content "Busca avançada"
    end
    expect(page).to have_field "Nome"
    expect(page).to have_field "Cidade"
    expect(page).to have_field "Bairro"
    expect(page).to have_field "Aceita pets", type:"checkbox"
    expect(page).to have_field "Acessível para PCD", type:"checkbox"
    expect(page).to have_field "Wi-fi", type:"checkbox"
    expect(page).to have_field "Quartos com ar-condicionado", type:"checkbox"
    expect(page).to have_field "Quartos com guarda-roupas", type:"checkbox"
    expect(page).to have_field "Quartos com TV", type:"checkbox"
    expect(page).to have_field "Quartos com varanda", type:"checkbox"
    expect(page).to have_field "Quartos com cofre", type:"checkbox"
    within "#advanced-search-form" do
      expect(page).to have_button "Buscar"
    end
  end
end
