require 'star_ethernet/command'
require 'star_ethernet/config'
require 'star_ethernet/printer'
require 'star_ethernet/status'
require 'star_ethernet/status_item'
require 'star_ethernet/version'
require 'star_ethernet/exceptions'

module StarEthernet
  def self.configuration
    @config ||= StarEthernet::Config.new
  end
end
