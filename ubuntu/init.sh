apt_update(){
    apt-get  update
    apt-get -y upgrade
    apt-get -y install openssh-server git  lrzsz   
}

init_base_environment(){
    #下载包
    git clone git@github.com:liu-rui/Shell.git
    cd Shell/ubuntu
    #搜狗输入法
    wget -O sogou.deb  --tries 4  http://pinyin.sogou.com/linux/download.php?f=linux&bit=64 
    dpkg  -i  sogou.deb
}

init_vim_environment(){
    apt-get install ctags xclip vim-gnome astyle python-setuptools
    git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim  
    cp bash/vim.sh ~/.vimrc
    vim +PluginInstall +qall
}

init_vscode_environment(){    
    wget -O code.deb  --tries 4  https://go.microsoft.com/fwlink/?LinkID=760868
    dpkg  -i  code.deb
    mkdir -p ~/.config/Code/User    
    cp vscode/*  ~/.config/Code/User/
}

init_python_environment(){
    apt-get -y install libc6-dev gcc make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev git libsqlite3-dev wget curl llvm
    git clone https://github.com/yyuu/pyenv.git ~/.pyenv 
    echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bash_profile
    echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bash_profile 
    echo 'eval "$(pyenv init -)"' >> ~/.bash_profile
    source ~/.bash_profile
    git clone https://github.com/yyuu/pyenv-virtualenv.git ~/.pyenv/plugins/pyenv-virtualenv 
    echo 'eval "$(pyenv virtualenv-init -)"' >> ~/.bash_profile
    source ~/.bash_profile
    pyenv install  3.5.3 -v
    pyenv  virtualenv 3.5.3  dev3.5.3
    pyenv global  dev3.5.3

    python -m  pip  install --upgrade pip
    python -m  pip  install flake8
    python -m  pip  install pylint
    python -m  pip  install autopep8
    pip install jinja2
} 

init_nodejs_environment(){
    npm config set registry https://registry.npm.taobao.org
}


main(){
    if [[ "$(whoami)" != "root" ]]; then
        echo "please run this script as root ." >&2
        exit 1
    fi
    echo -e "\033[31m 这个是ubuntu开发环境初始化脚本，请慎重运行！ press ctrl+C to cancel \033[0m"
    sleep 5

    apt_update
    #init_base_environment
    #init_vim_environment
    #init_python_environment
    #init_go_environment
    #init_nodejs_environment
}

main