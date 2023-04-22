#/bin/bash
file=index.html
echo "<html><head><title>index</title></head><body>" > $file 
echo "&nbsp" >> $file
echo "<h1> Hi! welcome everyone!</h1>" >> $file
echo "<h2>below are host Details:-</h2>" >> $file
echo "<p>public_ip-adress: $(curl ifconfig.me)" >> $file
echo "&nbsp </p>" >> $file
echo "local_ip-address: `hostname -I | awk '{print $1}'`" >> $file
echo "</body></html>" >> $file
sudo cp index.html /var/www/html 
sudo mv /var/www/html/index.nginx*.html /var/www/html/default.html 
sudo systemctl reload nginx


