require 'bluecoat/version'
require 'bluecoat/sg'
require 'bluecoat/reporter'
require 'openssl'

# disable SSL certificate validation
module OpenSSL
  # disable SSL certificate validation
  module SSL
    remove_const :VERIFY_PEER
    VERIFY_PEER = VERIFY_NONE
  end
end

