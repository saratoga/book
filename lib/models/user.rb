class User
  include DataMapper::Resource
  
  property :id,       Serial,       :nullable => false
  property :email,    String,       :nullable => false
  property :login,    String,       :nullable => false
  property :password, BCryptHash,   :nullable => false
  
  class << self
    def email_regex
      /^[a-zA-Z][\w\.-]*[a-zA-Z0-9]@[a-zA-Z0-9][\w\.-]*[a-zA-Z0-9]\.[a-zA-Z][a-zA-Z\.]*[a-zA-Z]$/
    end
  end
  
  def valid_email
    unless( email.blank? )
        unless( email =~ email_regex )
            errors.add(:email, "Your email address does not appear to be valid")
        else
            errors.add(:email, "Your email domain name appears to be incorrect") unless validate_email_domain(email)
        end
    end
  end

  def validate_email_domain(email)
        domain = email.match(/\@(.+)/)[1]
        Resolv::DNS.open do |dns|
            @mx = dns.getresources(domain, Resolv::DNS::Resource::IN::MX)
        end
        @mx.size > 0 ? true : false
  end
  
end