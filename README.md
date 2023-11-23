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


## API

Lista dos endpoints expostos pela API v1

- ### `GET /api/v1/inns`
  Retorna listagem de pousadas ativas na plataforma. O detalhes incluem todos os atributos da pousada *exceto* CNPJ (`registration_number`), razão social (`corporate_name`) e ativa (`active`), já que uma pousada na lista pode ser considerada ativa implicitamente.

  Aceita parâmetro `name` na URL para pesquisar pousadas por nome. A pesquisa é feita usando o operador `LIKE`, retornando todas as pousadas em que o nome contém o parâmetro, seja um match exato ou parcial.

  #### `GET /api/v1/inns?name=foo`



