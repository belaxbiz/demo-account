module DemoAccount
  class CustomerNote
    def self.create_customer_notes(client, customers, checkouts)
      @customer_num = customers.size
      @customer_ids = []

      @customer_num.times do |n|
        @customer_ids << customers[n]["id"]
      end

      contents = []

      checkouts.size.times do |m|
        checkout_id = checkouts[m]["id"]
        contents << note(checkout_id)
      end

      query = {notes: contents}

      client._post("customers/notes", query)
    end

    private
    def self.note(checkout_id)
      {
        customer_id: @customer_ids[rand(@customer_num)],
        app_created_at: Time.now,
        checkout_id: checkout_id
      }
    end
  end
end
