# config.rb

module Config
    # This module contains configuration settings for the Vagrant environment.

    # Vagrant Configuration
    VAGRANT_VERSION = ">= 2.4.3"
    VAGRANT_CONFIG_VERSION = "2"
    PROVIDER = "vmware_desktop"

    # Environment Configuration
    BASE_IMAGE = "gadgie/ubuntu24.04"
    HOSTNAME_BASE = "k8s-staging"
    DISABLE_SHARED_FOLDER = true
    ALLOW_FSTAB_MODIFICATION = false

    # Cloud Init Configuration
    CLOUD_INIT = true
    CLOUD_INIT_ISO = "#{Dir.pwd}/seeds/cloud-init.iso"
    BUILD_ISO = true

    # SSH Configuration
    SSH_USERNAME = "gadge"
    SSH_PRIVATE_KEY_PATH = "#{Dir.home}/.ssh/gadge"
    SSH_PORT = 22
    SSH_GUEST_PORT = 22
    SSH_FORWARD_AGENT = false
    SSH_CONNECT_TIMEOUT = 30
    SSH_INSERT_KEY = false
    SSH_KEY_TYPE = "ed25519"
  
    # Cluster Configuration
    NODES = 3
  
    # Network Configuration
    NETWORK = "192.168.6"
  
    # VM Configuration
    GUI = false
    LINKED_CLONE = false
    MEMORY = 4096
    CPUS = 2
  
    def self.validate!
      errors = []

      errors << "VAGRANT_VERSION must be a non-empty String" unless VAGRANT_VERSION.is_a?(String) && !VAGRANT_VERSION.empty?
      errors << "VAGRANT_CONFIG_VERSION must be a non-empty String" unless VAGRANT_CONFIG_VERSION.is_a?(String) && !VAGRANT_CONFIG_VERSION.empty?
      errors << "PROVIDER must be a non-empty String" unless PROVIDER.is_a?(String) && !PROVIDER.empty?
      
      errors << "BASE_IMAGE must be a non-empty String" unless BASE_IMAGE.is_a?(String) && !BASE_IMAGE.empty?
      errors << "HOSTNAME_BASE must be a non-empty String" unless HOSTNAME_BASE.is_a?(String) && !HOSTNAME_BASE.empty?
      errors << "DISABLE_SHARED_FOLDER must be true or false" unless [true, false].include?(DISABLE_SHARED_FOLDER)
      errors << "ALLOW_FSTAB_MODIFICATION must be true or false" unless [true, false].include?(ALLOW_FSTAB_MODIFICATION)

      errors << "CLOUD_INIT must be true or false" unless [true, false].include?(CLOUD_INIT)
      errors << "CLOUD_INIT_ISO must be a valid path string ending in .iso" unless CLOUD_INIT_ISO.is_a?(String) && File.extname(CLOUD_INIT_ISO) == ".iso"
      errors << "BUILD_ISO must be true or false" unless [true, false].include?(BUILD_ISO)
  
      if !NODES.is_a?(Integer) || NODES <= 0
        errors << "NODES must be a positive Integer"
      elsif NODES.even?
        errors << "NODES must be an odd number"
      end

      errors << "SSH_USERNAME must be a non-empty String" unless SSH_USERNAME.is_a?(String) && !SSH_USERNAME.empty?
      errors << "SSH_PRIVATE_KEY_PATH must be a non-empty String" unless SSH_PRIVATE_KEY_PATH.is_a?(String) && !SSH_PRIVATE_KEY_PATH.empty?
      errors << "SSH_PORT must be an Integer between 1 and 65535" unless SSH_PORT.is_a?(Integer) && SSH_PORT.between?(1, 65535)
      errors << "SSH_GUEST_PORT must be an Integer between 1 and 65535" unless SSH_GUEST_PORT.is_a?(Integer) && SSH_GUEST_PORT.between?(1, 65535)
      errors << "SSH_FORWARD_AGENT must be true or false" unless [true, false].include?(SSH_FORWARD_AGENT)
      errors << "SSH_CONNECT_TIMEOUT must be a positive Integer" unless SSH_CONNECT_TIMEOUT.is_a?(Integer) && SSH_CONNECT_TIMEOUT > 0
      errors << "SSH_INSERT_KEY must be true or false" unless [true, false].include?(SSH_INSERT_KEY)
      
      valid_key_types = ["auto", "rsa", "dsa", "ecdsa", "ecdsa521", "ed25519"]
      errors << "SSH_KEY_TYPE must be one of #{valid_key_types.join(', ')}" unless valid_key_types.include?(SSH_KEY_TYPE)
      
      ip_regex = /\A\d{1,3}(\.\d{1,3}){2}\z/
      errors << "NETWORK must be in 'x.x.x' format" unless NETWORK.match?(ip_regex)
  
      errors << "GUI must be true or false" unless [true, false].include?(GUI)
      errors << "LINKED_CLONE must be true or false" unless [true, false].include?(LINKED_CLONE)
      errors << "MEMORY must be an Integer >= 512" unless MEMORY.is_a?(Integer) && MEMORY >= 512
      errors << "CPUS must be an Integer >= 1" unless CPUS.is_a?(Integer) && CPUS >= 1
  
      raise RuntimeError, "Configuration validation failed:\n" + errors.map { |e| " - #{e}" }.join("\n") if errors.any?
  
      true
    end
  end
