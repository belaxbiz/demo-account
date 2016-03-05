module DemoAccount
  class Customer
    def initialize(client)
      @client = client
    end

    def create_customers
      generate_customer_fields
      contents = []
      20.times do |n|
        contents <<
         {
            guid: SimpleUUID::UUID.new.to_guid,
            deleted: false,
            updated_fields: @cfa[n]
          }
      end

      query = {customers: contents}
      response = @client._post("customers", query)
      response["customers"]
    end

  private
    def generate_customer_fields
      family_names = %w{
          a:佐藤:さとう:sato
          b:鈴木:すずき:suzuki
          c:高橋:たかはし:takahashi
          d:田中:たなか:tanaka
      }
      last_names = %w{
          001:一郎:いちろう:ichiro
          002:二郎:じろう:jiro
          003:松子:まつこ:matsuko
          004:竹子:たけこ:takeko
          005:梅子:うめこ:umeko
      }

        @cfv = []
        @cfa = []

        20.times do |n|
          fn = family_names[n % 4].split(":")
          ln = last_names[n % 5].split(":")

          @cfv = ["#{fn[0]}#{ln[0]}", "#{fn[1]} #{ln[1]}", "#{fn[2]} #{ln[2]}", "#{ln[3]}.#{fn[3]}@example.com"]
          @cfa << cf_array
        end
      end

      def cf_array
        name = %w{
          customer.field.customerID
          customer.field.name
          customer.field.ruby
          customer.field.email
        }

        customer_fields = []

        4.times do |m|
          customer_fields << {
            guid: SimpleUUID::UUID.new.to_guid,
            app_created_at: Time.now,
            name: name[m % 4],
            value: @cfv[m],
            deleted:false
          }
        end
        customer_fields
      end
  end
end
