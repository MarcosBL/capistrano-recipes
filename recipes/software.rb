Capistrano::Configuration.instance(true).load do
namespace :soft do

        desc "Remove problematic packages"
        task :remove do
            sudo "apt-get remove grub-pc"
            sudo "apt-get -y autoremove"
        end

        desc "Update apt-get sources"
        task :update do
			sudo "apt-get update"
        end

        desc "Upgrade packages"
        task :upgrade do
			sudo "apt-get -y upgrade"
        end

        desc "Install Development Tools"
        task :install_dev do
			sudo "apt-get install build-essential git-core git-svn openssl libssl-dev -y"
			sudo "grep -q \"alias gitcommit='git add *;git commit -am'\" /root/.bashrc || echo \"alias gitcommit='git add *;git commit -am'\" >> /root/.bashrc"
			sudo "grep -q \"alias gitpush='git push origin master'\" /root/.bashrc || echo \"alias gitpush='git push origin master'\" >> /root/.bashrc" 
        end

        desc "Install LAMP software"
        task :install_lamp do
			mysql.install
			sudo "apt-get install apache2 apache2-dev libapache2-mod-php5 php5-mysql php5-gd php5-curl php-pear php5-cli php5-dev php5-mcrypt -y"
        end

        desc "Install Mail"
        task :install_mail do
			sudo "DEBIAN_FRONTEND=noninteractive apt-get -qq -y install postfix"
			sudo "apt-get install dovecot-common dovecot-imapd dovecot-pop3d opendkim dk-filter sasl2-bin libsasl2-modules procmail libsasl2-2 -y"
        end
		
        desc "Install Misc"
        task :install_misc do
			sudo "apt-get install nmap mc grc links screen iproute bridge-utils rdate iftop rsync build-essential rar unrar zip unzip lynx curl htop python-docutils -y"
        end
		
        desc "Install Apticron"
        task :install_apticron do
			begin
				sudo "apt-get install apticron -y"
				prompt_with_default(:apticron_machine_alias, "Machine Alias")
				prompt_with_default(:apticron_notify_mail, "marcosbl@gmail.com")
				sudo "echo '' > /etc/apticron/apticron.conf"
				sudo "echo 'SYSTEM=\" #{apticron_machine_alias} \"' >> /etc/apticron/apticron.conf"
				sudo "echo 'EMAIL=\"#{apticron_notify_mail}\"' >> /etc/apticron/apticron.conf"
				sudo "crontab -u root -l > /tmp/apticron_cron.tmp  || sleep 1"
				sudo "grep -q \"# Apticron Updates\" /tmp/apticron_cron.tmp || (echo \"# Apticron Updates\" >> /tmp/apticron_cron.tmp && echo \"0       0       *       *       *       /usr/sbin/apticron --cron\" >> /tmp/apticron_cron.tmp)"
				sudo "crontab -u root /tmp/apticron_cron.tmp"
			rescue
				raise
			ensure
				# Delete temp file
				sudo "rm /tmp/apticron_cron.tmp"
			end
        end
	end
end
