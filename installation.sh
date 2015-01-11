#!/bin/sh

# locale ayarlanmasi...
sudo rm /etc/environment
sudo echo -e 'LANG=en_US.utf-8\r\nLC_ALL=en_US.utf-8' >> /etc/environment 

# fatest mirror disable
sudo rm /etc/yum/pluginconf.d/fastestmirror.conf
sudo cp fastestmirror.conf /etc/yum/pluginconf.d/fastestmirror.conf

# ana dizinleri olustur.
sudo mkdir /var/www
sudo mkdir /var/www/qa
sudo mkdir /var/www/qa/core
#sudo mkdir /var/www/qa/virtualenv

# postgresql kurulumu
sudo yum install postgresql postgresql-server postgresql-devel postgresql-contrib -y
sudo postgresql-setup initdb
sudo chkconfig postgresql on
sudo systemctl start postgresql.service
sudo -u postgres psql template1 < pg_sql.sql
sudo cp pg_hba.conf  /var/lib/pgsql/data/pg_hba.conf 
sudo systemctl restart postgresql.service

# Ptyhon virtualenv
sudo easy_install pip
#sudo pip install virtualenv
#sudo virtualenv /var/www/qa/virtualenv

# compailer
sudo yum groupinstall 'Development Tools' -y

# biostar install
sudo yum install python-devel -y
sudo git clone https://github.com/ialbert/biostar-central.git /var/www/qa/core
#sudo source /var/www/qa/virtualenv/bin/activate
sudo pip install --upgrade -r /var/www/qa/core/conf/requirements/deploy.txt
#sudo source /var/www/qa/core/conf/defaults.env
#sudo /var/www/qa/core/biostar.sh init import run

# live config dizinleri...
sudo mkdir /var/www/qa/core/live
sudo mkdir /var/www/qa/core/live/btsorucevap
sudo mkdir /var/www/qa/core/live/btsorucevap/logs
sudo mkdir /var/www/qa/core/live/btsorucevap/deploy
#sudo mkdir /var/www/qa/core/live/btsorucevap/server_configs
#
sudo touch /var/www/qa/core/live/__init__.py
sudo touch /var/www/qa/core/live/btsorucevap/__init__.py
sudo touch /var/www/qa/core/live/btsorucevap/deploy/__init__.py

# 
sudo cp deploy.env /var/www/qa/core/live/btsorucevap/deploy/
sudo cp deploy.py /var/www/qa/core/live/btsorucevap/deploy/

#lessc
sudo curl -sL https://rpm.nodesource.com/setup | sudo bash -
sudo yum install nodejs npm -y
sudo npm install -g less -y 

#nginx
sudo cp nginx.repo /etc/yum.repos.d/nginx.repo
sudo yum install nginx -y
sudo chkconfig nginx on

#supervisord
sudo pip install supervisor
sudo echo_supervisord_conf > /etc/supervisord.conf
sudo mkdir /etc/supervisord.d/
sudo echo -e "\n[include]\nfiles = /etc/supervisord.d/*.conf\n" >> /etc/supervisord.conf
sudo cp supervisord /etc/rc.d/init.d/supervisord
sudo chmod +x /etc/rc.d/init.d/supervisord
sudo chkconfig --add supervisord
sudo chkconfig supervisord on
sudo service supervisord start

#cp configs
sudo cp biostar.nginx.conf  /var/www/qa/core/live/btsorucevap/deploy/
sudo ln -fs /var/www/qa/core/live/btsorucevap/deploy/biostar.nginx.conf /etc/nginx/conf.d/btsorucevap.com.conf
#
sudo cp biostar.supervisor.conf /var/www/qa/core/live/btsorucevap/deploy/
sudo ln -fs /var/www/qa/core/live/btsorucevap/deploy/biostar.supervisor.conf /etc/supervisord.d/
#
sudo cp gunicorn.start.sh /var/www/qa/core/live/btsorucevap/deploy/
sudo cp celery.beat.sh /var/www/qa/core/live/btsorucevap/deploy/
sudo cp celery.worker.sh /var/www/qa/core/live/btsorucevap/deploy/

#init
sudo /bin/sh -c 'source  /var/www/qa/core/live/btsorucevap/deploy/deploy.env && /var/www/qa/core/biostar.sh init migrate'
sudo /bin/sh -c 'source  /var/www/qa/core/live/btsorucevap/deploy/deploy.env && python /var/www/qa/core/manage.py syncdb --all'

#
sudo chown -R nginx:nginx /var/www/qa
sudo chmod -R 755 /var/www/qa
sudo reboot








