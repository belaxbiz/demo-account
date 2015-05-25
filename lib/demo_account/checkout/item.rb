module DemoAccount
  module Checkout
    class Item
      attr_reader :total
      def initialize(items, num)
        item = items[num]
        @id = item["id"]
        @price = item["price"].to_i
        @sales = @price/108*100
        @tax = @price - @sales
      end

      def to_json(count=1)
        @total = @price * count
        {menu_item_id: @id,
         count: count,
         sales: @sales * count,
         tax: @tax * count,
         discount_sales: "0",
         discount_tax: "0"
        }
      end
    end
  end
end
