Capistrano::Configuration.instance(true).load do
namespace :network do
    desc "OVH - Configure first Failover IP"
    task :failover do
		begin
			# Ask user for the IP
			prompt_with_default(:failover_ip, "xx.xx.xx.xx")
			# Create and Upload a text file with the new conf
			put %Q{
auto eth0:0
iface eth0:0 inet static
        address #{failover_ip}
        netmask 255.255.255.255
        broadcast #{failover_ip}
			}, "/tmp/failover_text.tmp"
			# Import the previously uploaded configuration
			sudo "grep -q \"address #{failover_ip}\" /etc/network/interfaces || cat /tmp/failover_text.tmp >> /etc/network/interfaces"
			# Restart Networking to apply changes
			sudo "/etc/init.d/networking restart"
		rescue
			raise
		ensure
			# Delete temp file
			sudo "rm /tmp/failover_text.tmp"
		end
    end
end
end
