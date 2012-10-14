# Cozaepp

A Ruby API for passing messages to Uniforum's EPP-based co.za registry

## Installation

Add this line to your application's Gemfile:

    gem 'cozaepp'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cozaepp

## Usage

require "cozaepp"

epp = CozaEPP::Client.new("some.hostname.co.za","username","password")
epp.login

List of all public instance methods:

ack(messageId) click to toggle source
apply_clienthold(domainName)
create_contact(contactId, contactName, contactOrg, contactStreet1, contactStreet2, contactStreet3, contactCity, contactProvince, contactPostalcode, contactCountry, contactTel, contactFax, contactEmail, contactPassword )
create_domain_with_host(domainName, registrant, nsHostname1, nsipv4Address1, nsipv6Address1, nsHostname2, nsipv4Address2, nsipv6Address2, domainSecret )
create_domain_with_ns(domainName, registrant, nsHostname1, nsHostname2, domainSecret )
create_host(serverHostname, ipv4Address, ipv6Address=nil)
delete_contact(contactId)
delete_domain(domainName)
info_balance(contactId)
info_contact(contactId,contactPassword)
info_contact_linkeddomains(contactId,contactPassword)
info_domain(domainName)
login()
logout()
poll()
remove_clienthold(domainName)
renew_domain(domainName,curExpiryDate)
set_autorenew(domainName, autoRenew)
-autorenew in [ "true", "false"]
transfer_approve(domainName)
transfer_domain(domainName)
update_contact(contactId, contactName, contactOrg, contactStreet1, contactStreet2, contactStreet3, contactCity, contactProvince, contactPostalcode, contactCountry, contactTel, contactFax, contactEmail, contactPassword )
update_domain_ns(domainName, nsHostname1, nsipv4Address1, nsipv6Address1)
update_domain_registrant(domainName,registrant)


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
