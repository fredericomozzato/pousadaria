# Pousadaria
Frederico Mozzato, 2023

Projeto em desenvolvimento para o curso TreinaDev 11 com Ruby on Rails.

### Versões

- Rails 7.0.8
- Ruby 3.2.2


### Descrição do projeto

*O projeto se chama Pousadaria e a ideia principal é facilitar que as pessoas encontrem quartos aconhegantes em pousadas de todo o país. Para isto, a plataforma vai permitir que donos de pousadas cadastrem seus estabelecimentos e quartos disponíveis e gerenciem suas reservas. Os visitantes do site devem ser capazes de localizar as pousadas, visualizar suas informações e fazer reservas de quartos.*


### Gems externas:

- br_documents [https://github.com/asseinfo/br_documents]


### Observações de design

- A busca avançada usa o operador AND para encontrar pousadas com quartos que tenham correspondência ***exata*** com os atributos pesquisados.
- A cobrança de diárias no sistema é por noite na pousada. Ou seja, a data de check-out não conta como uma diária cobrada, a não ser que o hóspede faça check-out *após* o horário limite determiado pela pousada.
- Em casos de um user/owner tentar acessar uma página a qual não tem autorização, a mensagem de resposta não indica o erro de forma exata, com a intenção de não revelar a usuários não autorizadoas a existência ou não de uma página.

---

## API

Lista dos endpoints expostos pela API v1

- ### `GET /api/v1/inns[?name=]`
  Retorna listagem de pousadas ativas na plataforma. O detalhes incluem todos os atributos da pousada *exceto* CNPJ (`registration_number`), razão social (`corporate_name`) e ativa (`active`), já que uma pousada na lista pode ser considerada ativa implicitamente.

  #### Ex.:

  ```
  # status 200
  
  [
    {
    "id": 1,
    "name": "Mar Aberto",
    "phone": "4899999-9999",
    "email": "pousadamaraberto@hotmail.com",
    "description": "Pousada na beira do mar com suítes e café da manhã incluso.",
    "pay_methods": "Crédito, débito, dinheiro ou pix",
    "pet_friendly": true,
    "user_policies": "A pousada conta com lei do silêncio das 22h às 8h",
    "formatted_check_in_time": "09:00",
    "formatted_check_out_time": "15:30",
    "average_score": "3.7",
    "address": {
      "street": "Rua das Flores",
      "number": "300",
      "neighborhood": "Canasvieiras",
      "city": "Florianópolis",
      "state": "SC",
      "postal_code": "88000-000"
      }
    },
    ...
  ]
  ```

  Aceita parâmetro `name` na URL para pesquisar pousadas por nome. A pesquisa é feita usando o operador `LIKE`, retornando todas as pousadas em que o nome contém o parâmetro, seja um match exato ou parcial. Retorna um array mesmo se apenas um resultado for encontrado.

  ---

- ### `GET /api/v1/inns/:id`
  Retorna detalhes de uma pousada por ID seguindo o mesmo padrão da listagem. Nesse caso retorna somente um objeto.

  **Retorna apenas pousadas ativas na plataforma**. No caso de uma requisição para um ID não existente ou para um ID de uma pousada marcada como inativa, retorna `404`.

  #### Ex.:

  ```
  # status 404

  {"erro": "Pousada não encontrada"}`
  ```
  ---

- ### `GET /api/v1/inns/:inn_id/rooms`

  Retorna lista de quartos para uma pousada ativa. Sempre retorna um array, mesmo quando apenas um resultado é encontrado.

  #### Ex.:

  ```
  # status 200

  [
    {
      "id": 1,
      "name": "Atlântico",
      "description": "Quarto com vista para o mar",
      "size": 30,
      "max_guests": 2,
      "price": "200.0",
      "bathroom": true,
      "porch": false,
      "air_conditioner": false,
      "tv": false,
      "wardrobe": true,
      "safe": false,
      "wifi": true,
      "accessibility": true,
      "active": true
    },
    ...
  ]
  ```

  Em casos onde a pousada não exista ou está inativa, retorna `404`

  #### Ex.:

  ```
  #status 404

  {"erro": "Pousada não encontrada"}
  ```

  ---

  ### `GET api/v1/bookings/pre-booking`

  Recebe como parâmetros a o ID de um quarto (`room_id`), data de entrada(`start_date`), saída (`end_date`) e quantidade de hóspedes (`number_of_guests`). Retorna o valor da reserva ou mensagens de erro caso o período desejado não esteja disponível, o número de hóspedes seja maior do que o quarto suporta ou caso o quarto não exista no sistema.

  #### Ex.:
  ```
  # request body

  {
    "room_id": 1, 
    "start_date": "2023-12-01",
    "end_date": "2023-12-05",
    "number_of_guests": 2
  }


  # status 200

  {"valor": 800.0}
  ```

  Se o período escolhido não estiver disponível a resposta retorna com status `409 CONFLICT`:

  Ex.:
  ```
  # status: 409

  {"erro": "Já existe uma reserva para este quarto no período selecionado"}
  ```

  Caso o quarto esteja inativo ou não exista no sistema retorna `404 NOT FOUND`


