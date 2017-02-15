#!/bin/sh

apt_update(){
    sudo apt-get  update
    sudo apt-get -y upgrade
    sudo apt-get -y install openssh-server git  lrzsz wget
}

init_base_environment(){
    #下载包
    git clone https://github.com/liu-rui/Shell.git
    cd Shell/ubuntu
    #搜狗输入法
    wget -O sogou.deb  --tries 4  http://pinyin.sogou.com/linux/download.php?f=linux&bit=64 
    sudo dpkg  -i  sogou.deb
}

init_vim_environment(){
    sudo apt-get -y install ctags xclip vim-gnome astyle python-setuptools
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim  
    cp base/vim.sh ~/.vimrc
    vim +PluginInstall +qall
}

init_vscode_environment(){    
    wget -O code.deb  --tries 4  https://go.microsoft.com/fwlink/?LinkID=760868
    sudo dpkg  -i  code.deb
    mkdir -p ~/.config/Code/User    
    cp vscode/*  ~/.config/Code/User/
    
    #安装vscode默认环境插件
    code --install-extension robertohuertasm.vscode-icons
}

init_python_environment(){
    sudo  apt-get -y install libc6-dev gcc make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev git libsqlite3-dev wget curl llvm
    git clone https://github.com/yyuu/pyenv.git ~/.pyenv 
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
    echo 'eval "$(pyenv init -)"' >> ~/.bashrc    
    git clone https://github.com/yyuu/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv 
    echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bashrc
    sh ~/.bashrc
    pyenv install  3.5.3 -v
    pyenv  virtualenv 3.5.3  dev3.5.3
    pyenv global  dev3.5.3

    #为vscode配置python环境
    python -m  pip  install --upgrade pip
    python -m  pip  install flake8
    python -m  pip  install pylint
    python -m  pip  install autopep8
    code --install-extension donjayamanne.python

    #安装python常用库
    pip install jinja2
    pip install nose
} 

init_go_environment(){
    sudo  apt-get -y install golang-go golang-golang-x-tools        
    mkdir -p  /data/code/go
    echo 'export GOPATH="/data/code/go"' >> ~/.bashrc
    echo 'PATH="$GOPATH/bin:$PATH"' >> ~/.bashrc
    sh ~/.bashrc   
    
    #为vscode配置go环境
    tar zxf go/go_package.tar.gz  -C "$GOPATH/src/"    
    go install github.com/nsf/gocode
    go install github.com/rogpeppe/godef
    go install github.com/zmb3/gogetdoc
    go install github.com/golang/lint/golint
    go install github.com/lukehoban/go-outline
    go install sourcegraph.com/sqs/goreturns
    go install golang.org/x/tools/cmd/gorename
    go install github.com/tpng/gopkgs
    go install github.com/newhook/go-symbols
    go install golang.org/x/tools/cmd/guru
    go install github.com/cweill/gotests/...
    
    code --install-extension lukehoban.Go    

    #安装go常用库
    go get -u -v github.com/astaxie/beego
    go get -u -v github.com/beego/bee

}

init_nodejs_environment(){
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.0/install.sh | bash
    sh .bashrc
    nvm  install node
    nvm  use node
    npm config set registry https://registry.npm.taobao.org
    npm install gulp --global

    code --install-extension abusaidm.html-snippets
    code --install-extension dbaeumer.vscode-eslint
    code --install-extension msjsdiag.debugger-for-chrome
}


main(){
    echo -e "\033[31m 这个是ubuntu开发环境初始化脚本，请慎重运行！ press ctrl+C to cancel \033[0m"
    sleep 5

    apt_update
    init_base_environment
    init_vim_environment
    init_vscode_environment
    init_python_environment
    init_go_environment
    init_nodejs_environment
}

main