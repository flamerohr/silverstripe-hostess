/usr/sbin/apache2 -v

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

echo "$block" > "/etc/apache2/sites-available/$1.conf"
ln -fs "/etc/apache2/sites-available/$1.conf" "/etc/apache2/sites-enabled/$1.conf"
sudo service apache2 reload
