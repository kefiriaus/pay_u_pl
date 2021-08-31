# PayUPl

PayU api integrations for Poland:

- REST API

[CHANGELOG](CHANGELOG.md)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pay_u_pl', github: 'kefiriaus/pay_u_pl'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install pay_u_pl

## Usage

### Configuration

Go to `config/initializers` folder and create file `pay_u_pl.rb` with configuration according with your settings

```ruby
PayUPl::RestApi.configure do |config|
  config.gateway = "https://secure.snd.payu.com" # production: https://secure.payu.com
  config.currency_code = "PLN"
  config.client_id = "123456"
  config.client_secret = '1aaaaaa1111a11aaa111a11a1111a1aa'
  config.pos_id = '123456'
end

# Additional configuration for http_log in development
HttpLog.configure do |c|
  c.enabled = true
  c.log_headers = true
  c.color = :green
  c.filter_parameters = %w[password client_id client_secret access_token]
end
```

### Getting pay methods

> PayU documentation: https://developers.payu.com/en/restapi.html#Transparent_retrieve

```ruby
# Request
response = PayUPl::RestApi::Requests::PayMethods.call(lang: 'pl') # lang - optional parameter
response.success? # true or false
response.error? # true or false
response.to_json # response data
```

```ruby
# Response
response.to_json
{
 pay_by_links: [
   {
      value: "c",
      name: "Płatność online kartą płatniczą",
      brand_image_url: "http://static.payu.com/images/mobile/logos/pbl_c.png",
      status: "ENABLED",
      min_amount: 50,
      max_amount: 100000
   },
   {
      value: "o",
      name: "Pekao24Przelew",
      brand_image_url: "http://static.payu.com/images/mobile/logos/pbl_o.png",
      status: "DISABLED",
      min_amount: 50,
      max_amount: 100000
   },
   {
      value: "ab",
      name: "Płacę z Alior Bankiem",
      brand_image_url: "http://static.payu.com/images/mobile/logos/pbl_ab.png",
      status: "TEMPORARY_DISABLED",
      min_amount: 50,
      max_amount: 100000
   }
]
}
```

### Order creation

> PayU documentation: https://developers.payu.com/en/restapi.html#creating_new_order
> 
> PayU errors documentation: https://developers.payu.com/en/restapi.html#references_statuses

```ruby
# Request
response = PayUPl::RestApi::Requests::Order.call(
    ext_order_id: "1111-1111-1111-1111",
    notify_url: "https://your.eshop.com/notify",
    customer_ip: "127.0.0.1",
    merchant_pos_id: "123456",
    validity_time: 86400,
    description: "Description of the an order",
    additional_description: "Additional description of the order",
    visible_description: "Text visible on the PayU payment page (max. 80 chars)",
    currency_code: "PLN",
    total_amount: "21000",
    continue_url: "https://your.eshop.com/continue",
    buyer: {
      ext_customer_id: "123456",
      email: "john.doe@example.com",
      phone: "654111654",
      first_name: "John",
      last_name: "Doe",
      nin: "987654321-01",
      language: "pl"
    },
    products: [
      {
        name: "Wireless Mouse for Laptop",
        unit_price: "15000",
        quantity: "1"
      },
      {
        name: "HDMI cable",
        unit_price: "6000",
        quantity: "1"
      }
    ],
    pay_methods: {
      pay_method: {
        type: "PBL", # PBL | CARD_TOKEN | PAYMENT_WALL
        value: "blik", # for PBL, CARD_TOKEN
        authorization_code: "123456" # 6-digit BLIK code
      }
    }
)
response.success? # true or false
response.error? # true or false
response.to_json # response data
```

```ruby
# Response
response.to_json
{
  status: {
    status_code: "SUCCESS",
  },
  redirect_uri: "{payment_summary_redirection_url}",
  order_id: "WZHF5FFDRJ140731GUEST000P01",
  ext_order_id: "{YOUR_EXT_ORDER_ID}",
}
```

### Response errors

While using methods you can catch those errors:

```ruby
begin
  response = PayUPl::RestApi::Requests::PayMethods.call
  begin
    response_body = response.to_json
  rescue PayUPl::ProcessFailed => e # raising on code 400...500 
    ap e.message # common text error message for logs
    ap e.messages # hash with errors prom PayU
    # Example
    # {
    #   status: {
    #     status_code: "ERROR_SYNTAX"
    #   }
    # }
  rescue PayUPl::HostIsDownError => e # raising on code 500..511
    ap e.message # common text error message for logs
    ap e.messages # hash with errors prom PayU
    # Example
    # {
    #   status: {
    #     status_code: "BUSINESS_ERROR"
    #   }
    # }
  end
rescue PayUPl::ValidationError => e # raising on attribute's validations errors
  ap e.message # common text error message for logs
  ap e.messages # hash with errors prom Dry::Validations
  # Example
  # {
  #   status: {
  #     status_code: "ERROR_ATTRIBUTES_NOT_VALID",
  #     errors: {
  #       lang: ["must be filled"]
  #     }
  #   }
  # }
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kefiriaus/pay_u_pl.

## License
The gem is available as open source under the terms of the [GPLv3 License](https://www.gnu.org/licenses/gpl-3.0.txt).
