#!/bin/bash
        echo "${aws_efs_file_system.efsWordPress.dns_name}:/ /var/www/html nfs defaults,vers=4.1 0 0" >> /etc/fstab
        yum install -y php php-dom php-gd php-mysql
        for z in {0..120}; do
            echo -n .
            host "${aws_efs_file_system.efsWordPress.dns_name}" && break
            sleep 1
        done
        cd /tmp
        wget https://www.wordpress.org/latest.tar.gz
        mount -a
        tar xzvf /tmp/latest.tar.gz --strip 1 -C /var/www/html
        rm /tmp/latest.tar.gz
        chown -R apache:apache /var/www/html
        systemctl enable httpd
        sed -i 's/#ServerName www.example.com:80/ServerName www.myblog.com:80/' /etc/httpd/conf/httpd.conf
        sed -i 's/ServerAdmin root@localhost/ServerAdmin admin@myblog.com/' /etc/httpd/conf/httpd.conf
        #setsebool -P httpd_can_network_connect 1
        #setsebool -P httpd_can_network_connect_db 1
        systemctl start httpd
        #firewall-cmd --zone=public --permanent --add-service=http
        #firewall-cmd --reload
        #iptables -A INPUT -p tcp --dport 80 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
        #iptables -A OUTPUT -p tcp --sport 80 -m conntrack --ctstate ESTABLISHED -j ACCEPT
    EOF
 
