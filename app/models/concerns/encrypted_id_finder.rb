module EncryptedIdFinder
  extend ActiveSupport::Concern

  included do
    # ActiveRecord::Relation should use find_by_encrypted_id.
    #
    # The find_by_encrypted_id call EncryptedId::class.find method.
    # https://github.com/pencil/encrypted_id/blob/master/lib/encrypted_id.rb
    #
    # Without this method ActiveRecord::Relation will call original find method.
    # That means we can't find objects with an encrypted id.
    # How To:
    # model:
    # require 'encrypted_id_finder'
    # encrypted_id key: '36aAoQHCaJKETWHR'
    # include EncryptedIdFinder
    #
    # controller:
    # Order.done.find_by_encrypted_id(params[:id])
    def self.find_by_encrypted_id(*args)
      self.find(*args)
    end
  end
end
