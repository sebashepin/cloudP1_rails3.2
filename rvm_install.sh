#/bin/bash
apt-get -y install curl
\curl -L https://get.rvm.io | bash -s stable --ruby
rvm gemset create cloud
./sw_install.sh
