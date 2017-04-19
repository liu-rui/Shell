sudo apt-get  update
sudo apt-get -y upgrade
sudo apt-get -y install openssh-server git  lrzsz wget
sudo mkdir -p /data
user="$(whoami)"
eval "sudo chown ${user}:${user} /data"
mkdir /data/software    
cd /data/software  
ln  -s /data/software  ~/software
#搜狗输入法
wget -O sogou.deb  --tries 4  http://pinyin.sogou.com/linux/download.php?f=linux&bit=64 
sudo dpkg  -i  sogou.deb
#配置JDK
wget http://172.18.112.106/jdk-8u121-linux-x64.tar.gz
tar -zxf jdk-8u121-linux-x64.tar.gz
echo 'export JAVA_HOME="$HOME/software/jdk1.8.0_121"' >> ~/.bashrc
echo 'PATH="$JAVA_HOME/bin:$PATH"' >> ~/.bashrc
echo 'export JRE_HOME="$JAVA_HOME/jre"' >> ~/.bashrc
echo 'PATH="$JRE_HOME/bin:$PATH"' >> ~/.bashrc
sh ~/.bashrc
#配置mono
sudo add-apt-repository ppa:alexlarsson/flatpak    
sudo apt update
sudo apt install  -y flatpak
flatpak install --user --from https://download.mono-project.com/repo/monodevelop.flatpakref 
sudo apt-get  install -y mono-xsp
sudo  chmod  -R  +w /etc/mono
wget http://172.18.112.106/riderRS-171.3655.1246.tar.gz
tar -zxf riderRS-171.3655.1246.tar.gz
nohup sh /data/software/Rider-171.3655.1246/bin/rider.sh &
echo "mono开发环境安装完成！"