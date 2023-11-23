# Mar Aberto
owner_1 = Owner.create!(email: "dono_1@email.com", password: "123456")
inn_1 = Inn.create!(
  name: "Mar Aberto",
  corporate_name: "Pousada Mar Aberto/SC",
  registration_number: "84.485.218/0001-73",
  phone: "4899999-9999",
  email: "pousadamaraberto@hotmail.com",
  description: "Pousada na beira do mar com suítes e café da manhã incluso.",
  pay_methods: "Crédito, débito, dinheiro ou pix",
  pet_friendly: true,
  user_policies: "A pousada conta com lei do silêncio das 22h às 8h",
  check_in_time: Time.new(2000, 1, 1, 9, 0, 0, "UTC"),
  check_out_time: Time.new(2000, 1, 1, 15, 30, 0, "UTC"),
  owner: owner_1
)
Address.create!(
  street: "Rua das Flores",
  number: 300,
  neighborhood: "Canasvieiras",
  city: "Florianópolis",
  state: "SC",
  postal_code: "88000-000",
  inn: inn_1
)
inn_1_room_1 = Room.create!(
  name: "Atlântico",
  description: "Quarto com vista para o mar",
  size: 30,
  max_guests: 2,
  price: 200.00,
  inn: inn_1,
  bathroom: true,
  wifi: true,
  wardrobe: true,
  accessibility: true
)
inn_1_room_2 = Room.create!(
  name: "Pacífico",
  description: "Quarto com vista para o mar",
  size: 50,
  max_guests: 4,
  price: 350.00,
  inn: inn_1,
  bathroom: true,
  wifi: true,
  wardrobe: true,
  accessibility: true
)
inn_1_room_3 = Room.create!(
  name: "Índico",
  description: "Quarto com vista para o mar",
  size: 40,
  max_guests: 3,
  price: 250.00,
  inn: inn_1,
  bathroom: true,
  wifi: true,
  wardrobe: true,
  accessibility: true
)

# Morro Azul
owner_2 = Owner.create!(email: "dono_2@email.com", password: "654321")
inn_2 = Inn.create!(
  name: "Morro Azul",
  corporate_name: "Pousada Da Montanha/RS",
  registration_number: "59.457.495/0001-25",
  phone: "5499999-9999",
  email: "pousadamorroazul@gmail.com",
  description: "Pousada com vista pra montanha.",
  pay_methods: "Crédito, débito, dinheiro ou pix",
  user_policies: "A pousada conta com lei do silêncio das 22h às 8h",
  pet_friendly: true,
  check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
  check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
  owner: owner_2
)
Address.create!(
  street: "Rua da Cachoeira",
  number: 560,
  neighborhood: "Zona Rual",
  city: "Cambará do Sul",
  state: "RS",
  postal_code: "77000-000",
  inn: inn_2
)
inn_2_room_1 = Room.create!(
  name: "Canarinho",
  description: "Quarto com vista para a montanha",
  size: 30,
  max_guests: 2,
  price: 150.00,
  inn: inn_2,
  bathroom: true,
  wifi: true,
  tv: true,
  porch: true
)
inn_2_room_2 = Room.create!(
  name: "Gralha Azul",
  description: "Quarto com vista para a montanha",
  size: 50,
  max_guests: 4,
  price: 300.00,
  inn: inn_2,
  bathroom: true,
  wifi: true,
  tv: true,
  porch: true
)
inn_2_room_3 = Room.create!(
  name: "Papagaio",
  description: "Quarto com vista para a montanha",
  size: 45,
  max_guests: 3,
  price: 200.00,
  inn: inn_2,
  bathroom: true,
  wifi: true,
  tv: true,
  porch: true
)

# Ilha da Magia
owner_3 = Owner.create!(email: "dono_3@email.com", password: "abcdef")
inn_3 = Inn.create!(
  name: "Ilha da Magia",
  corporate_name: "Pousada Ilha da Magia Floripa",
  registration_number: "81.289.700/0001-40",
  phone: "48829999-9999",
  email: "pousadailhadamagia@gmail.com",
  description: "Pousada na Ilha da Magia.",
  pay_methods: "Crédito, débito, dinheiro ou pix",
  user_policies: "A pousada conta com lei do silêncio das 22h às 8h",
  pet_friendly: false,
  check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
  check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
  owner: owner_3
)
Address.create!(
  street: "Rua da Praia",
  number: 190,
  neighborhood: "Campeche",
  city: "Florianópolis",
  state: "SC",
  postal_code: "88800-000",
  inn: inn_3
)
inn_3_room_1 = Room.create!(
  name: "Canasvieiras",
  description: "Quarto com vista para a praia",
  size: 20,
  max_guests: 2,
  price: 200.00,
  inn: inn_3,
  bathroom: true,
  porch: true,
  wardrobe: true,
  air_conditioner: true,
  accessibility: true
)
inn_3_room_2 = Room.create!(
  name: "Campeche",
  description: "Quarto com vista para a praia",
  size: 50,
  max_guests: 4,
  price: 350.00,
  inn: inn_3,
  bathroom: true,
  porch: true,
  wardrobe: true,
  air_conditioner: true,
  accessibility: true
)
inn_3_room_3 = Room.create!(
  name: "Sambaqui",
  description: "Quarto com vista para a praia",
  size: 60,
  max_guests: 5,
  price: 500.00,
  inn: inn_3,
  bathroom: true,
  porch: true,
  wardrobe: true,
  air_conditioner: true,
  accessibility: true
)


# Lage da Pedra
owner_4 = Owner.create!(email: "dono_4@email.com", password: "fedcba")
  inn_4 = Inn.create!(
  name: "Lage da Pedra",
  corporate_name: "Pousada Lage da Pedra",
  registration_number: "09.167.769/0001-73",
  phone: "3499999-9999",
  email: "lagedapedra@gmail.com",
  description: "Pousada com cachoeiras.",
  pay_methods: "Crédito, débito, dinheiro ou pix",
  user_policies: "A pousada conta com lei do silêncio das 22h às 8h",
  pet_friendly: false,
  check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
  check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
  owner: owner_4
)
Address.create!(
  street: "Servidão da Cachoeira",
  number: 32,
  neighborhood: "Morro da Pedra",
  city: "Uberlândia",
  state: "MG",
  postal_code: "33000-000",
  inn: inn_4
)
inn_4_room_1 = Room.create!(
  name: "Basalto",
  description: "Quarto com vista para a cachoeira",
  size: 50,
  max_guests: 4,
  price: 300.00,
  inn: inn_4,
  bathroom: true,
  tv: true,
  wifi: true,
  accessibility: true,
  wardrobe: true
)
inn_4_room_2 = Room.create!(
  name: "Quartzo",
  description: "Quarto com vista para a cachoeira",
  size: 35,
  max_guests: 3,
  price: 200.00,
  inn: inn_4,
  bathroom: true,
  tv: true,
  wifi: true,
  accessibility: true,
  wardrobe: true
)
inn_4_room_3 = Room.create!(
  name: "Diamante",
  description: "Quarto com vista para a cachoeira",
  size: 60,
  max_guests: 4,
  price: 450.00,
  inn: inn_4,
  bathroom: true,
  tv: true,
  wifi: true,
  accessibility: true,
  wardrobe: true,
  safe: true
)

# Vento Sul
owner_5 = Owner.create!(email: "dono_5@email.com", password: "uvwxyz")
inn_5 = Inn.create!(
  name: "Vento Sul",
  corporate_name: "PVS Pousada",
  registration_number: "72.153.926/0001-28",
  phone: "48989998998",
  email: "pousadaventosul@email.com",
  description: "Pousada na beira da praia.",
  pay_methods: "Dinheiro, cartão e pix",
  user_policies: "",
  pet_friendly: false,
  check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
  check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
  owner: owner_5
)
Address.create!(
  street: "Servidão Ventania",
  number: 100,
  neighborhood: "Pântano do Sul",
  city: "Florianópolis",
  state: "SC",
  postal_code: "88000-800",
  inn: inn_5
)
inn_5_room_1 = Room.create!(
  name: "Minuano",
  description: "Quarto com vista para o mar",
  size: 20,
  max_guests: 2,
  price: 125.00,
  inn: inn_5,
  porch: true,
  air_conditioner: true,
  wifi: true,
  safe: true
)
inn_5_room_2 = Room.create!(
  name: "Ventania",
  description: "Quarto com vista para o mar",
  size: 35,
  max_guests: 3,
  price: 300.00,
  inn: inn_5,
  bathroom: true,
  porch: true,
  air_conditioner: true,
  wifi: true,
  safe: true
)
inn_5_room_3 = Room.create!(
  name: "Maral",
  description: "Quarto com vista para o mar",
  size: 40,
  max_guests: 2,
  price: 250.00,
  inn: inn_5,
  porch: true,
  air_conditioner: true,
  wifi: true,
  safe: true
)

# Chalés da Roça
owner_6 = Owner.create!(email: "dono_6@email.com", password: "zyxwvu")
inn_6 = Inn.create!(
  name: "Chalés da Roça",
  corporate_name: "Pousada Chalés",
  registration_number: "06.849.772/0001-89",
  phone: "1999987656",
  email: "chalésdaroça@email.com",
  description: "Pousada de campo com café colonial.",
  pay_methods: "Dinheiro, cartão e pix",
  user_policies: "",
  pet_friendly: false,
  check_in_time: Time.new(2000, 1, 1, 9, 0, 0, 'UTC'),
  check_out_time: Time.new(2000, 1, 1, 15, 0, 0, 'UTC'),
  owner: owner_6
)
Address.create!(
  street: "Estrada da Roça",
  number: 1800,
  neighborhood: "São Luiz",
  city: "Barão Geraldo",
  state: "SP",
  postal_code: "11000-900",
  inn: inn_6,
)
inn_6_room_1 = Room.create!(
  name: "Quartinho",
  description: "Quarto com vista para a roça",
  size: 15,
  max_guests: 2,
  price: 100.00,
  inn: inn_6,
  porch: true,
  wifi: true,
  accessibility: true
)
inn_6_room_2 = Room.create!(
  name: "Quartão",
  description: "Quarto com vista para a roça",
  size: 50,
  max_guests: 4,
  price: 300.00,
  inn: inn_6,
  porch: true,
  wifi: true,
  accessibility: true
)
inn_6_room_2 = Room.create!(
  name: "Junto e misturado",
  description: "Quarto com vista para a roça compartilhado",
  size: 70,
  max_guests: 7,
  price: 300.00,
  inn: inn_6,
  porch: true,
  wifi: true,
  accessibility: true
)

# users
user_1 = User.create!(
  name: "João Silva",
  cpf: "899.924.320-63",
  email: "joao@email.com",
  password: "123456"
)
user_2 = User.create!(
  name: "Leila Mattos",
  cpf: "627.201.780-47",
  email: "leila@email.com",
  password: "123456"
)
user_3 = User.create!(
  name: "Frederico Mozzato",
  cpf: "890.619.700-40",
  email: "frederico@email.com",
  password: "123456"
)
user_4 = User.create!(
  name: "Luciana Rodrigues",
  cpf: "595.315.930-78",
  email: "luciana@email.com",
  password: "123456"
)

# bookings
booking_1 = Booking.create!(
  room: inn_1_room_1,
  user: user_1,
  start_date: Date.today,
  end_date: 5.days.from_now,
  number_of_guests: 2,
  status: :active
)
booking_2 = Booking.create!(
  room: inn_2_room_2,
  user: user_2,
  start_date: 1.week.from_now,
  end_date: 2.weeks.from_now,
  number_of_guests: 2
)
booking_3 = Booking.create!(
  room: inn_3_room_3,
  user: user_3,
  start_date: 2.days.from_now,
  end_date: 5.days.from_now,
  number_of_guests: 2
)
booking_4 = Booking.create!(
  room: inn_1_room_2,
  user: user_4,
  start_date: 2.weeks.from_now,
  end_date: 3.weeks.from_now,
  number_of_guests: 2
)
booking_5 = Booking.create!(
  room: inn_3_room_1,
  user: user_1,
  start_date: 1.week.from_now,
  end_date: 2.weeks.from_now,
  number_of_guests: 2,
  status: :active
)
