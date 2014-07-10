Puppet::Type.type(:modprobe).provide :modprobe do

  desc "Modprobe support; intelligently adds or removes a module from the Linux kernel."

  commands :lsmod => '/sbin/lsmod'
  commands :modprobe => '/sbin/modprobe'

  confine :kernel => :linux

  def self.instances
    modules = lsmod

    list_modules = modules.split("\n")
    list_modules.shift
    ls_modules = []
    list_modules.each { |item|
      mod = item.split("\s")[0]
      ls_modules << mod
    }

    ls_modules.collect do |module_name|
      new(:name => module_name, :ensure => :present)
    end
  end

  def self.prefetch(resources)
    modules = instances
    resources.keys.each do |name|
      if provider = modules.find { |module_name| module_name.name == name }
        resources[name].provider = provider
      end
    end
  end

  def create
    debug 'Loading kernel module %s' % resource[:name]
    modprobe resource[:name]

    @property_hash[:ensure] = :present
  end

  def destroy
    debug 'Unloading kernel module %s' % resource[:name]
    modprobe '-r', resource[:name]

    @property_hash.clear
  end

  def exists?
    @property_hash[:ensure] == :present
  end

end
