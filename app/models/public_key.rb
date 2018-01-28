require 'base64'
require 'openssl'

class PublicKey < ApplicationRecord
  validates :name, presence: true
  validates :pubkey, presence: true

  has_many :builds

  def fingerprint
    content = key.split(/\s/)[1]

    if content
      Digest::MD5.hexdigest(Base64.decode64(content))
        .scan(/.{1,2}/)
        .join(":")
    else
      'Unknown'
    end
  end

  def ssh_key?
    (type, b64, _) = key.split(/\s/)
    %w{ssh-rsa ssh-dss}.include?(type) && b64.present?
  end

  # Public: In order to verify a signature we need the key to be an OpenSSL
  # RSA PKey and not a string that you would find in an ssh pubkey key. Most
  # people are going to be adding ssh public keys to their build system, this
  # method will covert them to OpenSSL RSA if needed.
  def to_rsa
    ConvertToRSA.convert(key)
  end

  # Public: Will verify that the signer has access to deploy the build
  # object. The signature includes the endpoint and app name.
  #
  # Returns boolean
  def verify(build)
    # TODO might as well cache this and store in the db so we dont have to
    # convert every time
    public_key = to_rsa
    signature = Base64.decode64(build.signature)
    digest = OpenSSL::Digest::SHA256.new

    match = build.html &&
            signature &&
            public_key.verify(digest, signature, build.html)
    # Bug in ruby's OpenSSL implementation.
    # SSL connection with PostgreSQL can fail, after a call to
    # OpenSSL::X509::Certificate#verify with result 'false'. Root cause is
    # the thread local error queue of OpenSSL, that is used to transmit
    # textual error messages to the application after a failed crypto
    # operation. A failure in Certificate#verify leaves some messages on the
    # error queue, which can lead to errors in a SSL communication of other
    # parts of the application. The only solution at the moment is running:
    # OpenSSL.errors.clear after certificate verifying. This clears OpenSSL
    # errors array and keeps database connection alive.
    # From https://bugs.ruby-lang.org/issues/7215
    OpenSSL.errors.clear
    match # return true/false
  end
end
