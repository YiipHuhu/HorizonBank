class Account < ApplicationRecord
  # has_secure_password é um método do Rails que adiciona funcionalidades de autenticação a um modelo
  # Ele requer que o modelo tenha uma coluna chamada password_digest
  # Ele adiciona um método chamado authenticate que verifica se a senha fornecida é a mesma que a senha armazenada no banco de dados
  # Ele também adiciona um método chamado password= que criptografa a senha fornecida e a armazena no banco de dados
  has_secure_password
  has_many :transactions
  has_many :sent_transfers, class_name: 'Transfer', foreign_key: 'sender_account_id'
  has_many :received_transfers, class_name: 'Transfer', foreign_key: 'receiver_account_id'

  validates :name, :birthdate, :document, presence: { message: "Está faltando informar alguns itens" }
  # eu valido apenas esses campos acima, se a pessoa nao enviar o balance, ele vai ser setado como 0.0
  validates :document, uniqueness: { message: "Este documento já esta sendo usado" }
  # Garantir que o saldo inicial seja zero ao criar uma conta
  after_initialize :set_default_balance, if: :new_record?
  before_validation :generate_password, on: :create

  private

  def set_default_balance
    self.balance ||= 0.0
  end

  # metodo para gerar um hash de senha aleatório de 16 digitos(sao 8byts) e salvar no banco
  def generate_password
    self.password = SecureRandom.hex(8) if password_digest.blank?
  end
end
