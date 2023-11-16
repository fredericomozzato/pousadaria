require "rails_helper"

describe "Usuário visita a página inicial" do
  context "desautenticado" do
    it "e não vê o link Minhas Reservas no menu" do
      visit root_path

      within "#navigation-bar" do
        expect(page).not_to have_link "Minhas Reservas"
      end
    end

    it "e é redirecionado para log-in ao acessar Minhas Reservas diretamente" do
      visit my_bookings_path

      expect(current_path).to eq new_user_session_path
    end
  end

  context "autenticado" do
    it "e vê o link Minhas Reservas no menu" do
      user = User.create(
        name: "User",
        email: "user@email.com",
        cpf: "292.625.560-80",
        password: "123456"
      )

      login_as user, scope: :user
      visit root_path

      within "#navigation-bar" do
        expect(page).to have_link "Minhas Reservas"
      end
    end

    it "e acessa a página Minhas Reservas e não vê nenhuma reserva" do
      user = User.create(
        name: "User",
        email: "user@email.com",
        cpf: "292.625.560-80",
        password: "123456"
      )

      login_as user, scope: :user
      visit root_path
      within "#navigation-bar" do
        click_on "Minhas Reservas"
      end

      expect(page).to have_content "Reservas"
      expect(page).to have_content "Você não possui reservas"
      expect(page).to have_link "Voltar para início"
    end

    it "e acessa a página Minhas Reservas e vê suas reservas" do
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
      booking = Booking.create!(
        room: room_ocean,
        user: user,
        start_date: 1.week.from_now,
        end_date: 2.weeks.from_now,
        number_of_guests: 2,
      )

      login_as user, scope: :user
      visit root_path
      within "#navigation-bar" do
        click_on "Minhas Reservas"
      end

      expect(page).to have_content "Reservas"
      expect(page).not_to have_content "Você não possui reservas"
      within "section#bookings-list" do
        expect(page).to have_link booking.code
        expect(page).to have_content "Pousada: #{inn.name}"
        expect(page).to have_content "Quarto: #{room_ocean.name}"
        expect(page).to have_content "Período: #{I18n.l(booking.start_date)} - #{I18n.l(booking.end_date)}"
      end
    end

    it "e vê detalhes de uma reserva a partir da página Minhas Reservas" do
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
      booking = Booking.create!(
        room: room_ocean,
        user: user,
        start_date: 2.week.from_now,
        end_date: 3.weeks.from_now,
        number_of_guests: 2,
      )

      login_as user, scope: :user
      visit root_path
      within "#navigation-bar" do
        click_on "Minhas Reservas"
      end
      within "section#bookings-list" do
        click_on booking.code
      end

      expect(page).to have_content "Detalhes da Reserva"
      expect(page).to have_content "Mar Aberto"
      expect(page).to have_content "Quarto: Oceano"
      expect(page).to have_content "Check-in: #{I18n.l(2.week.from_now.to_date)} a partir das 09:00 horas"
      expect(page).to have_content "Check-out: #{I18n.l(3.weeks.from_now.to_date)} até as 15:00 horas"
      expect(page).to have_content "Número de hóspedes: #{booking.number_of_guests}"
      expect(page).to have_content "Valor: R$ 1.400,00"
      expect(page).to have_content "Código: #{booking.code}"
      expect(page).to have_content "Status: Confirmada"
      expect(page).to have_button "CANCELAR RESERVA"
    end

    it "e acessa a página Minhas Reservas e não vê reservas de outro usuário" do
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
      booking = Booking.create!(
        room: room_ocean,
        user: user,
        start_date: 1.week.from_now,
        end_date: 2.weeks.from_now,
        number_of_guests: 2,
      )
      logged_user = User.create!(
        name: "Logged User",
        cpf: "313.003.380-75",
        email: "loggeduser@email.com",
        password: "654321"
      )

      login_as logged_user, scope: :user
      visit root_path
      click_on "Minhas Reservas"

      expect(page).not_to have_link booking.code
      expect(page).not_to have_content "Pousada: #{inn.name}"
      expect(page).not_to have_content "Quarto: #{room_ocean.name}"
      expect(page).not_to have_content "Período: #{I18n.l(booking.start_date)} - #{I18n.l(booking.end_date)}"
      expect(page).to have_content "Você não possui reservas"
    end
  end
end
