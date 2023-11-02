require "rails_helper"

describe "Proprietário acessa formulário de cadastro de quarto" do
  it "a partir da página inicial" do
    owner = Owner.create!(
      email: "owner@email.com",
      password: "123456"
    )
    inn = Inn.create!(
      name: "Mar Aberto",
      corporate_name: "Pousada Mar Aberto/SC",
      registration_number: "84.485.218/0001-73",
      phone: "9999999994899999-9999",
      email: "pousadamaraberto@gmail.com",
      description: "Pousada na beira do mar com suítes e café da manhã incluso.",
      pay_methods: "Crédito, débito, dinheiro ou pix",
      user_policies: "A pousada conta com lei do silêncio das 22h às 8h",
      pet_friendly: true,
      check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
      check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
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

    login_as(owner)
    visit root_path
    click_on "Minha Pousada"
    click_on "Adicionar Quarto"

    expect(page).to have_content "Novo Quarto"
    expect(page).to have_field "Nome", type: "text"
    expect(page).to have_field "Descrição", type: "text"
    expect(page).to have_field "Tamanho (m²)", type: "number"
    expect(page).to have_field "Número máximo de hóspedes", type: "number"
    expect(page).to have_field "Valor da diária", type: "number"
    expect(page).to have_content "Comodidades"
    expect(page).to have_field "Banheiro próprio", type: "checkbox"
    expect(page).to have_field "Varanda", type: "checkbox"
    expect(page).to have_field "Ar-condicionado", type: "checkbox"
    expect(page).to have_field "Televisão", type: "checkbox"
    expect(page).to have_field "Guarda-roupas", type: "checkbox"
    expect(page).to have_field "Cofre", type: "checkbox"
    expect(page).to have_field "Acessibilidade", type: "checkbox"
    expect(page).to have_field "Wi-fi", type: "checkbox"
    expect(page).to have_button "Criar Quarto"
  end
end