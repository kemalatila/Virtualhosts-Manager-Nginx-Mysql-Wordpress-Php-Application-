#!/bin/bash
echo -e "\n"
echo -e "\e[01;32m      ##################################\e[00m"
echo -e "\e[01;32m      #### Web Installations Script ####\e[00m"
echo -e "\e[01;32m      ##################################\e[00m"
echo -e "\n"
OPTIONS=$1

create_vhost(){

	read -p "Enter the domain ( ex: example.com ): " HOST
	echo -e ""
	echo -e "Virtual Host is started to creating ${HOST} \e[00m"
	cp vhost_template.txt /etc/nginx/sites-available/${HOST}
        find /etc/nginx/sites-available/${HOST} -type f -exec sed -i 's/%host/'${HOST}'/g' {} \;
        ln -s /etc/nginx/sites-available/${HOST} /etc/nginx/sites-enabled/${HOST}
        mkdir /var/www/${HOST}/
        mkdir /var/www/${HOST}/html/
        cp test_index.php /var/www/${HOST}/html/index.php
        chown www-data:www-data -R /var/www/${HOST}/* && chmod 750 -R /var/www/${HOST}/*
        /etc/init.d/nginx restart
        echo -e "Virtual Host Created"
        install_db
}

install_db(){

        read -p "DATABASE NAME (default:will generate automatic) :" DBNAME
        echo -e ""
        read -p "DATABASE USER NAME (default:will generate automatic) :" DBUSER
        echo -e ""
        read -p "Enter Mysql ROOT Password (Required):" ROOT_PASSWORD
        echo -e ""
        echo $HOST
        if [ -z "$DBNAME" ]; then
                HASH=$(random_hash_generator  10)
                DBNAME="$HOST$HASH"
                DBNAME="${DBNAME//./}"
        fi
        if [ -z "$DBUSER" ]; then
                HASH=$(random_hash_generator  7)
                DBUSER="$HOST$HASH"
                DBUSER="${DBUSER//./}"
        fi
        echo $DBNAME
        echo $DBUSER
        echo $ROOT_PASSWORD
        DBUSERPASSWORD=$(random_hash_generator  10)     
        cp adduser.sql adduser_${HOST}.sql
        find adduser_${HOST}.sql -type f -exec sed -i 's/%database_name/'${DBNAME}'/g' {} \;
        find adduser_${HOST}.sql -type f -exec sed -i 's/%dbuser/'${DBUSER}'/g' {} \;        
        find adduser_${HOST}.sql -type f -exec sed -i 's/%password/'${DBUSERPASSWORD}'/g' {} \;
        mysql -h localhost -u root -p${ROOT_PASSWORD} < adduser_${HOST}.sql
        rm adduser_${HOST}.sql
        echo -e ""
        echo -e "Database Name : ${DBNAME}\n"
        echo -e "Database User : ${ROOT_PASSWORD}\n"
        echo -e "Database Password : ${DBNAME}\n"
        if [ "$OPTIONS" = "wordpress" ]; then
                install_wordpress
        fi
}

install_wordpress(){

        curl -O https://wordpress.org/latest.tar.gz
        tar -zxvf latest.tar.gz
        cd wordpress
        cp -rf . ..
        cd ..
        rm -R wordpress
        cp wp-config-sample.php wp-config.php
        perl -pi -e "s/database_name_here/$dbname/g" wp-config.php
        perl -pi -e "s/username_here/$dbuser/g" wp-config.php
        perl -pi -e "s/password_here/$dbpass/g" wp-config.php
}

random_hash_generator(){

        SIZE=$1
        #chararray=(q w e r t y u i o p a s d f g h j k l z x c v b n m Q W E R T Y U I O P A S D F G H J K L Z X C V B N M 1 2 3 4 5 6 7 8 9 0 \! @ \# \$ \% ^ \& \* \( \))
        chararray=(q w e r t y u i o p a s d f g h j k l z x c v b n m Q W E R T Y U I O P A S D F G H J K L Z X C V B N M 1 2 3 4 5 6 7 8 9 0 \! @ \# \$ \& \* \( \))
        num=${#chararray[*]}
        local HASH=''
        i=0
        while [ $i -le $SIZE ]
        do
                local HASH=$HASH${chararray[$((RANDOM%num))]}
                let i=$i+1
        done    
        echo "$HASH"
}

create_vhost




