class Authentication
  include MongoMapper::Document

  def self.authenticate(uid)
    authentication = first uid: uid
    if authentication
      authentication.user
    else
      nil
    end
  end
end
