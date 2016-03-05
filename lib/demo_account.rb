require 'httpclient'
require 'json'
require 'pp'
require 'optparse'
require 'simple_uuid'
require 'time'
require 'date'

require 'demo_account/batch'
require 'demo_account/checkout'
require 'demo_account/customer'
require 'demo_account/customer_note'
require "demo_account/ubiregi_api/client.rb"
require 'demo_account/version'

# UbiregiAPIという名前空間の作成
#module UbiregiAPI
#end
