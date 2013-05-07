require "scorebutt/version"
require "scorebutt/watcher"
require "scorebutt/host_watcher"

module Scorebutt
  class Scorer

    attr_accessor :sleep_time

    def initialize(attributes)
      self.sleep_time = attributes[:sleep_time]
      self.sleep_time ||= 10
    end

    def watch(&block)
      watchees = Scorebutt::Watcher.new(&block)
      # Watcher.new should return an array of procs that test each service for a given host
      watcher_blocks = watchees.get_blocks.flatten!
      puts "Got #{watcher_blocks.size} blocks"

      counter=0 and loop do
        counter+=1
        watchees.get_blocks.each do |watcher|
          # Watcher is a proc, so run it
          puts watcher.call
        end
        sleep self.sleep_time
        puts "\n\n\n\n\n\n\n\n\n\n\n\n"
      end
    
    rescue SystemExit, Interrupt  # From SIGINT
      puts "\nInterrupt signal recieved"
    
    ensure  # Print some stats on program exit
      puts "#{counter} checks made"
    end

  end
end
