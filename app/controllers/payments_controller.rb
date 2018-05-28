class PaymentsController < ApplicationController
  before_action :authorize, except: [:create]

  def create
    name = payment_params[:name]
    email = payment_params[:email]
    stripe_token = payment_params[:"stripe-token"]

    person = person_for(name, email)

    total = tickets.reduce(0) { |total, ticket| total + ticket.cost }
    description = tickets.map(&:description).join(', ')

    grand_total = ((total + 30) / (1 - 0.029)).round

    Stripe.api_key = group.stripe_secret_key

    transaction = group.transactions.create(
      description: description,
      currency: 'USD',
      paid_by: person,
      paid_at: DateTime.now,
      amount_paid: grand_total,
      payment_method: "stripe",
    )

    charge = Stripe::Charge.create({
      currency: 'USD',
      amount: grand_total,
      receipt_email: person.email,
      description: description,
      metadata: {
        person: "#{ENV['APP']}/people/#{person.id}",
        name: person.name,
        transaction: "#{ENV['APP']}/ledger/#{transaction.id}"
      },
      source: stripe_token
    })

    payment_processor_url = if Rails.env.development?
                              "https://dashboard.stripe.com/test/payments/#{charge.id}"
                            else
                              "https://dashboard.stripe.com/payments/#{charge.id}"
                            end

    balance = Stripe::BalanceTransaction.retrieve(charge.balance_transaction)

    transaction.update_attributes(
      amount_paid: balance.net,
      currency: balance.currency,
      payment_processor_url: payment_processor_url
    )

    tickets.each do |ticket|
      ticket.events.each do |event|
        group.ticket_stubs.create(
          person: person,
          event: event,
          purchase: transaction,
          ticket: ticket,
          attended: false
        )
      end
    end

    # OrderMailer.confirmation_email(person, order).deliver!
  rescue Stripe::CardError => e
    e.json_body[:error][:message]
  end

  private

  def person_for(name, email)
    if email.present?
      people = group.people.where('LOWER(email) = LOWER(?)', email)
      if people.count > 0
        people.first
      else
        group.people.create(email: email, name: name)
      end
    else
      group.people.create(name: name)
    end
  end

  def api_key
    params[:api_key] || super
  end

  def payment_params
    create_params[:data][:attributes]
  end

  def tickets
    return @tickets if @tickets
    @tickets = Ticket.find(create_params[:data][:relationships][:tickets][:data].map { |rel| rel[:id] })
  end

  def create_params
    params.permit(
      data: [
        :type, {
        attributes: [
          :email,
          :name,
          :"stripe-token"
        ],
        relationships: {
          tickets: {
            data: [:id, :type]
          }
        }
      }]
    )
  end
end
