Capistrano::Configuration.instance(true).load do
namespace :misc do
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
          sudo "apt-get install build-essential -y"
        end

        desc "Install Git"
        task :install_git do
          sudo "apt-get install git-core git-svn -y"
        end
end
end
