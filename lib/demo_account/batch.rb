# coding: utf-8

module DemoAccount
class Batch
  def self.new_demo(argv)
    @date = DateTime.parse(argv[0])

    client = UbiregiAPI::Client.new("#{argv[1]}")
    account = client.account

    @account_id = account["id"]
    menu = account["menus"][0]
    @a_payments = account["payment_types"]
    if account["customer_tags"].size < 3
      create_tags(client)
      @a_tags = @response["customer_tags"]
    else
      @a_tags = account["customer_tags"]
    end

    @menu_items = client._get("menus/#{menu}/items")["items"]

    365.times {
    post_daily_checkouts(rand(20)+10, rand(5)+1, rand(5)+1)
    @date += 1
    }
  end

  private
  def self.create_tags(client)
    tags = [{name:"家族連れ",
             icon_name:"family"},
            {name:"カップル",
             icon_name:"couple"},
            {name:"友達",
             icon_name:"friends"},]
    tag_contents = {customer_tags:tags}
    @response = client._post("accounts/#@account_id/customer_tags",tag_contents)
  end

  def self.post_daily_checkouts(checkout_num=1, item_num=1, count=1)
    checks = []
    checkout_num.times {
               item_jsons = []
               amount = 0

               item_num.times {
                 item = Checkout::Item.new(@menu_items, rand(50))
                 item_jsons << item.to_json(count)
                 amount += item.total
               }

               # AM 9 to PM 9 in JST
               time = @date + Rational(rand(12), 24)

               checks << {
                          items: item_jsons,
                          change: "0",
                          guid: SimpleUUID::UUID.new.to_guid,
                          paid_at: time.to_s,
                          payments: [{payment_type_id: @a_payments[rand(2)]["id"],
                                      amount: amount.to_s}],
                          customers_count: rand(5)+1,
                          customer_tag_ids: [@a_tags[rand(3)]["id"]],
                          status: "close"
                          }
              }

    contents = {checkouts: checks}

    puts @date
    client._post("accounts/#@account_id/checkouts",contents)
  end

end
end
