module DemoAccount
  class Checkout
    def initialize(client, account)
      @client = client

      @account_id = account["id"]
      menu = account["menus"][0]
      @menu_items = @client._get("menus/#{menu}/items")["items"]

      @a_payments = account["payment_types"]

      if account["customer_tags"].size < 3
        create_tags
        @a_tags = @response["customer_tags"]
      else
        @a_tags = account["customer_tags"]
      end
    end

    def create_daily_checkouts(date, checkout_num=1, item_num=1)
      checks = []
      checkout_num.times {
                 item_jsons = []
                 amount = 0

                 item_num.times {
                   item_jsons << create_item_json(@menu_items, rand(10), rand(5)+1)
                   amount += @total
                 }

                 # AM 9 to PM 9 in JST
                 time = date + Rational(rand(12), 24)

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

      query = {checkouts: checks}

      puts date
      @client._post("accounts/#{@account_id}/checkouts",query)
    end

    private
      def create_tags
        tags = [{name:"家族連れ",
               icon_name:"family"},
              {name:"カップル",
               icon_name:"couple"},
              {name:"友達",
               icon_name:"friends"},]
        tag_contents = {customer_tags:tags}
        @response = @client._post("accounts/#{@account_id}/customer_tags",tag_contents)
      end

      def create_item_json(items, item_id, count=1)
          item = items[item_id]
          price = item["price"].to_i
          sales = price/108*100
          tax = price - sales
          @total = price * count

          {menu_item_id: item["id"],
           count: count,
           sales: sales * count,
           tax: tax * count,
           discount_sales: "0",
           discount_tax: "0"
          }
      end
  end
end
