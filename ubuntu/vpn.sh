user="$(whoami)"
eval "sudo chown ${user}:${user} /data"
mkdir /data/software    
cd /data/software  
sudo apt-get install -y  openvpn
wget http://172.18.112.106/openvpn.tar.gz
sudo tar -zxf openvpn.tar.gz -C /etc/openvpn
rm -f openvpn.tar.gz
systemctl enable  openvpn
systemctl restart openvpn
ping  10.100.100.12