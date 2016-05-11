#!/usr/bin/env bash

	block="<VirtualHost *:$3 *:$4>

		ServerName $1

		ServerAdmin admin@example.com
		DocumentRoot $2

		ErrorLog /var/log/apache2/$1-error.log
		CustomLog /var/log/apache2/$1-access.log combined

		<Directory $2>
			Options Indexes FollowSymLinks Includes ExecCGI
			AllowOverride All
			<IfVersion < 2.4>
				Allow from all
			</IfVersion>
			<IfVersion >= 2.4>
				Require all granted
			</IfVersion>
		</Directory>

	</VirtualHost>"

echo "--- setup $1 ---"
if hash /usr/sbin/apache2 2>/dev/null;
then
	echo 'using Apache on Debian'
	echo "$block" > "/etc/apache2/sites-available/$1.conf"
	ln -fs "/etc/apache2/sites-available/$1.conf" "/etc/apache2/sites-enabled/$1.conf"

	grep -q -F 'IncludeOptional /etc/apache2/sites-enabled/*.conf' /etc/apache2/conf-enabled/other-vhosts-access-log.conf || echo 'IncludeOptional /etc/apache2/sites-enabled/*.conf' >> /etc/apache2/conf-enabled/other-vhosts-access-log.conf

	sudo service apache2 reload
elif hash apachectl 2>/dev/null;
then
	echo 'using Apache on CentOS'
	echo "$block" > "/etc/httpd/sites-available/$1.conf"
	ln -fs "/etc/httpd/sites-available/$1.conf" "/etc/httpd/sites-enabled/$1.conf"

	grep -q -F 'IncludeOptional /etc/httpd/sites-enabled/*.conf' /etc/httpd/conf/httpd.conf || echo 'IncludeOptional /etc/httpd/sites-enabled/*.conf' >> /etc/httpd/conf/httpd.conf

	sudo apachectl restart
fi

