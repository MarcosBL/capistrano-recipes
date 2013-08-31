Capistrano::Configuration.instance(true).load do
namespace :mysql do
    desc "Install Mysql-server"
    task :install do
      begin
        # Ask user for a password to configure for external access
        prompt_with_default(:mysql_admin_password, "DeFaUlTPwd")
        # Create a temo text file on destination with the user creation, flush and users select (just as debug)
        put %Q{
                GRANT ALL PRIVILEGES ON *.* TO "root"@"%" IDENTIFIED BY "#{mysql_admin_password}";
                FLUSH PRIVILEGES;
                select CONCAT(User,"@",Host) as User, Password from user;
        }, "/tmp/mysql-install-external-password.tmp"
        # Silent install Mysql Server
        sudo "DEBIAN_FRONTEND=noninteractive apt-get -qq -y install mysql-server"
        # Comment bind line to listen on all interfaces
        sudo "sed -i 's/^bind-address/#bind-address/g' /etc/mysql/my.cnf"
        # Import the previously uploaded sql script
        sudo "mysql -Dmysql < /tmp/mysql-install-external-password.tmp"
        # Restart MySQL to apply changes
        sudo "service mysql restart"
      rescue
        raise
      ensure
        # Delete temp file
        sudo "rm /tmp/mysql-install-external-password.tmp"
      end
    end
end
end
