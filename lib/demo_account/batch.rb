# coding: utf-8

module DemoAccount
class Batch
  def self.new_demo(argv)
    date = DateTime.parse(argv[0])

    client = UbiregiAPI::Client.new("#{argv[1]}")
    account = client.account

    account_id = account["id"]

    customer = client._get("customers")
    if customer["customers"].size < 20
      Customer.new(client).create_customers
    else
      customers = customer["customers"]
    end

    checkout_client = Checkout.new(client, account)

    365.times {
      checkouts = checkout_client.create_daily_checkouts(date, rand(20)+10, rand(5)+1)
      CustomerNote.create_customer_notes(client, customers, checkouts)
      date += 1
    }

  end
end
end
