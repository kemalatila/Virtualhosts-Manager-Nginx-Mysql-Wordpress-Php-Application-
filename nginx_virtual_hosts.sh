#!/bin/bash
echo -e "\n"
echo -e "\e[01;32m      ##################################\e[00m"
echo -e "\e[01;32m      #### Web Installations Script ####\e[00m"
echo -e "\e[01;32m      ##################################\e[00m"
echo -e "\n"

createvhost(){
	read -p "Enter the domain ( ex: example.com ): " HOST
	echo -e ""
	echo -e "Virtual Host is started to creating ${HOST} \e[00m"
	cp vhost_template.txt /etc/nginx/sites-available/${HOST}
        ln -s /etc/nginx/sites-available/${HOST} /etc/nginx/sites-enabled/${HOST}
        mkdir /var/www/${HOST}/
        mkdir /var/www/${HOST}/html/
        cp test_index.php /var/www/${HOST}/html/index.php
        chown www-data:www-data -R /var/www/${HOST}/* && chmod 750 -R /var/www/${HOST}/*
        /etc/init.d/nginx restart
	 echo -e ""

}
createvhost
