require 'httpclient'
require 'colored'
module Scorebutt
  class HostWatcher
    attr_accessor :ip, :blocks
    def initialize(attributes)
      self.ip = attributes[:ip]
      self.blocks = []
    end

    def process(&block)
      instance_eval(&block)
      self.blocks
    end

    def http
      self.blocks << lambda do
        ok_status_codes = [
          200, 201, 202, 203, 204, 205, 206, 207
        ]

        proxy = ENV['HTTP_PROXY']
        client = HTTPClient.new(proxy)
        target = "http://" + self.ip
        begin
          result = client.get(target)
          if ok_status_codes.include? result.header.status_code
            puts "#{self.ip}: OK".green
          else
            puts "#{self.ip}: ERROR".red
          end
        rescue Exception => detail
            puts "#{self.ip}: ERROR ".red + detail.to_s
        end
      end
    end

    def https
    end

    def smtp
    end

    def ftp
    end

    def telnet
    end

    def ssh
    end

    def ntp
    end

    def bonjour
    end
  end
end
