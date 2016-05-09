	block="<VirtualHost *:$3 *:$4>

		ServerName $1

		ServerAdmin admin@example.com
		DocumentRoot $2

		ErrorLog /var/log/apache2/$1-error.log
		CustomLog /var/log/apache2/$1-access.log combined

		<Directory $2>
			Options Indexes FollowSymLinks Includes ExecCGI
			AllowOverride All
			Require all granted
		</Directory>

	</VirtualHost>"

if [ command -v /usr/sbin/apache2 >/dev/null 2>&1 ]
then
	echo "$block" > "/etc/apache2/sites-available/$1.conf"
	ln -fs "/etc/apache2/sites-available/$1.conf" "/etc/apache2/sites-enabled/$1.conf"
	sudo service apache2 reload
elif [ command -v apachectl >/dev/null 2>&1 ]
then
	echo "$block" > "/etc/httpd/sites-available/$1.conf"
	ln -fs "/etc/httpd/sites-available/$1.conf" "/etc/httpd/sites-enabled/$1.conf"

	grep -q -F 'IncludeOptional /etc/httpd/sites-enabled/*.conf' /etc/httpd/conf/httpd.conf || echo 'IncludeOptional /etc/httpd/sites-enabled/*.conf' >> /etc/httpd/conf/httpd.conf

	sudo apachectl restart
fi

