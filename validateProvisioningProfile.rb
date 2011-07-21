#!/usr/bin/ruby
require "openssl"
require "rexml/document"
require "getoptlong"

RED = 31
GREEN = 32

def puts_message(color, code, text)
  puts "[ \e[#{color}m#{code.upcase}\e[0m ] #{text}"
end

begin

  opt = GetoptLong.new(
    ["--certificate", "-c", GetoptLong::REQUIRED_ARGUMENT],
    ["--profile", "-p", GetoptLong::REQUIRED_ARGUMENT],
    ["--password", "-P", GetoptLong::OPTIONAL_ARGUMENT]
  )

  @options = Hash.new
  opt.each do |name, arg|
    @options[name] = arg
  end

  if @options["--certificate"].nil? or not File.exists?(@options["--certificate"])
    puts_message(RED, "error", "can't find the certificate file.")
    exit 2
  end
  if @options["--profile"].nil? or not File.exists?(@options["--profile"])
    puts_message(RED, "error", "can't find the provisioning profile file.")
    exit 2
  end

  profile = File.read(@options["--profile"])
  certificate = File.read(@options["--certificate"])

  p7 = OpenSSL::PKCS7.new(profile)
  cert = OpenSSL::PKCS12.new(certificate, @options["--password"])

  store = OpenSSL::X509::Store.new
  p7.verify([], store)

  plist = REXML::Document.new(p7.data)

  plist.elements.each('/plist/dict/key') do |ele|
    if ele.text == "DeveloperCertificates"
      keys = ele.next_element
      key = keys.get_elements('//array/data')[0].text

      profile_cert = "-----BEGIN CERTIFICATE-----" + key.gsub(/\t/, "") + "-----END CERTIFICATE-----\n"

      @provisioning_cert = OpenSSL::X509::Certificate.new(profile_cert)
    end
  end

  if @provisioning_cert.to_s != cert.certificate.to_s
    puts_message(RED, "error", "Provisioning profile was not signed with provided certificate.")

    exit 1
  else
    puts_message(GREEN, "passed", "Provisioning profile signature validation passed.")
  
    exit 0
  end

rescue OpenSSL::PKCS12::PKCS12Error
  puts_message(RED, "Error", "Invalid password for certificate.")
  
  exit 2
end
