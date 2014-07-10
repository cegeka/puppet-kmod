Puppet::Type.newtype(:modprobe) do

  desc <<-EOT
    Load or unload a kernel module.
  EOT

  ensurable do
    desc "What state the kernel module should be in."

    newvalue(:present) do
      provider.create
    end

    newvalue(:absent) do
      provider.destroy
    end

    defaultto :present
  end

  newparam(:name, :namevar => true) do
    desc "The name of the kernel module to load or unload."
  end

end
