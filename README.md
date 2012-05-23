# Bluecoat

This gem provides an interface from ruby to Blue Coat Boxes.

## Installation

Add this line to your application's Gemfile:

    gem 'bluecoat'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bluecoat

## Usage

    require 'bluecoat'

### connect to ProxySG Box
    sg = BlueCoat::SG.new({
      :host => "bluecoatsg.local",
      :user => "admin",
      :pass => "password"
    })

### fetch whole policy
    policy = sg.fetch_policy

### fetch a defined subnet
    subnet = sg.fetch_subnet "subnet1"


### connect to Reporter
    bc = BlueCoat::Reporter.new({
      :host => "bluecatreporter.local",
      :user => "admin",
      :pass => "password",
      :role => "admin"    # choose existant role on reporter
    })

### fetch a report from reporter through WEB API

Give parameters as specified by the Blue Coat Reporter WEB API. The result
is a two dimensional array rows/columns.

    result = bc.fetch_report({
      :database => "databasename",
      :columns => "total_bytes",
      :sort => "total_bytes",
      :summarizeBy => "c_ip",
      :rows => 100,
      :dateRelativeUnit => :month,
      :dateStart => -1,
      :dateEnd => 0
    })

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
