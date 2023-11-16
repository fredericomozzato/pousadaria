require "rails_helper"

describe "Usuário visita a página de reservas" do
  context "desautenticado" do
    it "e vê o formulário" do
      owner = Owner.create!(
          email: "owner@email.com",
          password: "123456"
      )
      inn = Inn.create!(
        name: "Mar Aberto",
        corporate_name: "Pousada Mar Aberto/SC",
        registration_number: "84.485.218/0001-73",
        phone: "4899999-9999",
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
      room_ocean = Room.create!(
        name: "Oceano",
        description: "Quarto com vista para o mar",
        size: 30,
        max_guests: 2,
        price: 200.00,
        inn_id: inn.id
      )

      visit root_path
      click_on "Mar Aberto"
      click_on "Oceano"
      click_on "Reservar"

      expect(page).to have_content "Detalhes da reserva"
      expect(page).to have_content "Pousada: Mar Aberto"
      expect(page).to have_content "Quarto: Oceano"
      expect(page).to have_field "Data de Check-in", type: "date"
      expect(page).to have_field "Data de Check-out", type: "date"
      expect(page).to have_field "Número de hóspedes", type: "number"
      expect(page).to have_button "Avançar"
      expect(page).to have_link "Voltar"
    end

    it "e é redirecionado para página de confirmação de reserva" do
      owner = Owner.create!(
          email: "owner@email.com",
          password: "123456"
      )
      inn = Inn.create!(
        name: "Mar Aberto",
        corporate_name: "Pousada Mar Aberto/SC",
        registration_number: "84.485.218/0001-73",
        phone: "4899999-9999",
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
      room_ocean = Room.create!(
        name: "Oceano",
        description: "Quarto com vista para o mar",
        size: 30,
        max_guests: 2,
        price: 200.00,
        inn_id: inn.id
      )

      visit root_path
      click_on "Mar Aberto"
      click_on "Oceano"
      click_on "Reservar"
      fill_in "Data de Check-in", with: 10.days.from_now
      fill_in "Data de Check-out", with: 14.days.from_now
      fill_in "Número de hóspedes", with: 2
      click_on "Avançar"

      expect(page).to have_content "Dados da Reserva"
      expect(page).to have_content "Quarto: Oceano"
      expect(page).to have_content "Data de entrada: #{I18n.l(10.days.from_now.to_date)} a partir das #{inn.check_in_time.strftime("%H:%M")} horas"
      expect(page).to have_content "Data de saída: #{I18n.l(14.days.from_now.to_date)} até as #{inn.check_out_time.strftime("%H:%M")} horas"
      expect(page).to have_content "Número de hóspedes: 2"
      expect(page).to have_content "Valor da reserva: R$ 800,00"
      expect(page).to have_content "Métodos de pagamento: Crédito, débito, dinheiro ou pix"
      expect(page).to have_button "Confirmar reserva"
      expect(page).to have_link "Voltar"
    end

    it "e preenche datas que conflitam com outra reserva" do
      owner = Owner.create!(
          email: "owner@email.com",
          password: "123456"
      )
      inn = Inn.create!(
        name: "Mar Aberto",
        corporate_name: "Pousada Mar Aberto/SC",
        registration_number: "84.485.218/0001-73",
        phone: "4899999-9999",
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
      room_ocean = Room.create!(
        name: "Oceano",
        description: "Quarto com vista para o mar",
        size: 30,
        max_guests: 2,
        price: 200.00,
        inn_id: inn.id
      )
      user = User.create!(
        email: "user@email.com",
        password: "123456",
        name: "User",
        cpf: "561.473.820-71"
      )
      booking = Booking.create!(
        room: room_ocean,
        start_date: 10.days.from_now,
        end_date: 14.days.from_now,
        number_of_guests: 2,
        user: user,
        status: :confirmed
      )

      visit root_path
      click_on "Mar Aberto"
      click_on "Oceano"
      click_on "Reservar"
      fill_in "Data de Check-in", with: 12.days.from_now
      fill_in "Data de Check-out", with: 16.days.from_now
      fill_in "Número de hóspedes", with: 2
      click_on "Avançar"

      expect(page).to have_content "Já existe uma reserva para este quarto no período selecionado"
    end

    it "e preenche número de hóspedes maior que o permitido" do
      owner = Owner.create!(
          email: "owner@email.com",
          password: "123456"
      )
      inn = Inn.create!(
        name: "Mar Aberto",
        corporate_name: "Pousada Mar Aberto/SC",
        registration_number: "84.485.218/0001-73",
        phone: "4899999-9999",
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
      room_ocean = Room.create!(
        name: "Oceano",
        description: "Quarto com vista para o mar",
        size: 30,
        max_guests: 2,
        price: 200.00,
        inn_id: inn.id
      )
      user = User.create!(
        email: "user@email.com",
        password: "123456",
        name: "User",
        cpf: "368.224.240-67"
      )

      visit root_path
      click_on "Mar Aberto"
      click_on "Oceano"
      click_on "Reservar"
      fill_in "Data de Check-in", with: 12.days.from_now
      fill_in "Data de Check-out", with: 16.days.from_now
      fill_in "Número de hóspedes", with: 3
      click_on "Avançar"

      expect(page).to have_content "Número de hóspedes maior que o permitido para o quarto"
    end

    it "e deixa campos vazios" do
      owner = Owner.create!(
          email: "owner@email.com",
          password: "123456"
      )
      inn = Inn.create!(
        name: "Mar Aberto",
        corporate_name: "Pousada Mar Aberto/SC",
        registration_number: "84.485.218/0001-73",
        phone: "4899999-9999",
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
      room_ocean = Room.create!(
        name: "Oceano",
        description: "Quarto com vista para o mar",
        size: 30,
        max_guests: 2,
        price: 200.00,
        inn_id: inn.id
      )

      visit root_path
      click_on "Mar Aberto"
      click_on "Oceano"
      click_on "Reservar"
      click_on "Avançar"

      expect(page).to have_content "Data de Check-in não pode ficar em branco"
      expect(page).to have_content "Data de Check-out não pode ficar em branco"
      expect(page).to have_content "Número de hóspedes não pode ficar em branco"
    end

    it "e é redirecionado para página de login" do
      owner = Owner.create!(
          email: "owner@email.com",
          password: "123456"
      )
      inn = Inn.create!(
        name: "Mar Aberto",
        corporate_name: "Pousada Mar Aberto/SC",
        registration_number: "84.485.218/0001-73",
        phone: "4899999-9999",
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
      room_ocean = Room.create!(
        name: "Oceano",
        description: "Quarto com vista para o mar",
        size: 30,
        max_guests: 2,
        price: 200.00,
        inn_id: inn.id
      )

      visit root_path
      click_on "Mar Aberto"
      click_on "Oceano"
      click_on "Reservar"
      fill_in "Data de Check-in", with: 10.days.from_now
      fill_in "Data de Check-out", with: 14.days.from_now
      fill_in "Número de hóspedes", with: 2
      click_on "Avançar"
      click_on "Confirmar reserva"

      expect(current_path).to eq new_user_session_path
    end
  end

  context "autenticado" do
    it "e reserva um quarto com sucesso" do
      owner = Owner.create!(
          email: "owner@email.com",
          password: "123456"
      )
      inn = Inn.create!(
        name: "Mar Aberto",
        corporate_name: "Pousada Mar Aberto/SC",
        registration_number: "84.485.218/0001-73",
        phone: "4899999-9999",
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
      room_ocean = Room.create!(
        name: "Oceano",
        description: "Quarto com vista para o mar",
        size: 30,
        max_guests: 2,
        price: 200.00,
        inn_id: inn.id
      )
      user = User.create!(
        name: "User",
        cpf: "820.628.780-95",
        email: "user@email.com",
        password: "123456"
      )

      login_as user, scope: :user
      visit root_path
      click_on "Mar Aberto"
      click_on "Oceano"
      click_on "Reservar"
      fill_in "Data de Check-in", with: 10.days.from_now
      fill_in "Data de Check-out", with: 14.days.from_now
      fill_in "Número de hóspedes", with: 2
      click_on "Avançar"
      allow(SecureRandom).to receive(:alphanumeric).with(8).and_return("ABCD1234")
      click_on "Confirmar reserva"

      expect(page).to have_content "Reserva confirmada"
      expect(page).to have_content "Detalhes da Reserva"
      expect(page).to have_content "Mar Aberto"
      expect(page).to have_content "Quarto: Oceano"
      expect(page).to have_content "Check-in: #{I18n.l(10.days.from_now.to_date)} a partir das 09:00 horas"
      expect(page).to have_content "Check-out: #{I18n.l(14.days.from_now.to_date)} até as 15:00 horas"
      expect(page).to have_content "Número de hóspedes: 2"
      expect(page).to have_content "Valor: R$ 800,00"
      expect(page).to have_content "Código: ABCD1234"
      expect(page).to have_content "Você pode cancelar sua reserva até #{I18n.l(10.days.from_now.to_date - 7.days)}"
      expect(page).to have_button "CANCELAR RESERVA"
    end
  end
end
