#!/bin/bash

# based on: http://pastebin.com/RjmDapEv

# USER=$SUDO_USER
USER=zaki
HOME=/home/$USER
cd $HOME

mkdir -p $HOME/git $HOME/local/{bin,src,etc}

# 
echo grub-common hold | dpkg --set-selections
echo grub-pc hold | dpkg --set-selections
echo grub-pc-bin hold | dpkg --set-selections
echo grub2-common hold | dpkg --set-selections

echo keyboard-configuration hold | dpkg --set-selections
# echo "set grub-pc/install_devices /dev/sda" | debconf-communicate

# ■common
sed -i.bak -e "s%http://[^ ]\+%http://ftp.jaist.ac.jp/pub/Linux/ubuntu/%g" /etc/apt/sources.list
# sed -i.bak -e "s%http://[^ ]\+%http://ftp.tsukuba.wide.ad.jp/Linux/ubuntu/%g" /etc/apt/sources.list
apt-get update && apt upgrade -y
# apt-get update 
apt-get install -y vim tmux gdb gdbserver socat binutils manpages-ja manpages-dev manpages-ja-dev nasm python python-pip git autoconf libtool make libc6-dbg || \
    (echo "[!] apt-get install failed at common"; exit)


# To use x86 binary at x86_64 enviroment.
apt-get install -y gcc-multilib lib32z1 lib32ncurses5 libbz2-1.0:i386 libc6:i386 || \
    (echo "[!] apt-get install failed at x86"; exit)



# ■dotfiles
cd $HOME
git clone https://github.com/tty-nkzk/dotfiles.git $HOME/git/dotfiles
ln -s git/dotfiles/.tmux.conf .tmux.conf
ln -s git/dotfiles/.vimrc .vimrc
cd $HOME/git/dotfiles
git remote set-url origin git@github.com:tty-nkzk/dotfiles.git
git config --local push.default simple
git config --local user.email tty.nkzk@gmail.com
git config --local user.name tty-nkzk
 
# ■peda
cd $HOME
git clone https://github.com/longld/peda.git $HOME/git/peda
echo source $HOME/git/peda/peda.py >> $HOME/.gdbinit
 
# ■rp++
cd $HOME
wget -q https://github.com/downloads/0vercl0k/rp/rp-lin-x64
chmod +x rp-lin-x64 && mv rp-lin-x64 $HOME/local/bin


cd $HOME
echo "" >> .profile
echo "# set PATH so it includes my private bin directories" >> .profile
echo 'export PATH="$HOME/local/bin:$PATH"' >> .profile

# for pwntools
apt-get install -y python2.7 python-pip python-dev git libssl-dev libffi-dev build-essential pandoc|| \
    (echo "[!] apt-get install failed at pwntools"; exit)

# pyenv
# cd $HOME
# apt-get install -y make build-essential libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev libncursesw5-dev xz-utils tk-dev|| \
#     (echo "[!] apt-get install failed at pyenv"; exit)
# 
# curl -L https://raw.githubusercontent.com/pyenv/pyenv-installer/master/bin/pyenv-installer | bash
# echo "" >> .profile
# echo "# set PATH for pyenv" >> .profile
# echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> .profile
# echo 'eval "$(pyenv init -)"' >> .profile
# echo 'eval "$(pyenv virtualenv-init -)"' >> .profile
# 
# echo 'pyenv install 2.7.17' >> pyenv_init.sh
# echo 'pyenv install 3.8.1' >> pyenv_init.sh
# echo 'pyenv global 2.7.17' >> pyenv_init.sh
# echo 'pyenv virtualenv ctf' >> pyenv_init.sh
# echo 'pyenv global ctf' >> pyenv_init.sh
# 
# echo '# https://github.com/aquynh/capstone/issues/413' >> pyenv_init.sh
# echo 'pip install capstone==3.0.5rc2' >> pyenv_init.sh
# 
# echo '# ROPgadget' >> pyenv_init.sh
# echo 'pip install ROPgadget' >> pyenv_init.sh
# 
# echo 'pip install pwntools' >> pyenv_init.sh
# 
# chmod +x pyenv_init.sh

# keygen
# ssh-keygen -t ed25519 -N "" -f $HOME/.ssh/id_ed25519

# novim
cd $HOME
echo "" >> .profile
echo "# set alias" >> .profile
echo "alias novim='vim --noplugin -u NONE'" >> .profile

# ~/.ssh/config
# Host github.com
#   Hostname ssh.github.com
#   Port 443
#   IdentityFile ~/.ssh/id_ed25519
# Host bitbucket.com
#   Hostname altssh.bitbucket.com
#   Port 443
#   IdentityFile ~/.ssh/id_ed25519

# tmux for 256 color
cd $HOME
echo "" >> .profile
echo "alias tmux='tmux -2'" >> .profile

# vim install
chmod +x git/dotfiles/vim-install.sh
./git/dotfiles/vim-install.sh


# 
echo grub-common install | dpkg --set-selections
echo grub-pc install | dpkg --set-selections
echo grub-pc-bin install | dpkg --set-selections
echo grub2-common install | dpkg --set-selections

chown $USER:$USER -R $HOME
echo "[+] bootstrap.sh done!"
echo "[+] please do folloing" 
echo "[+] 1. pyenv_init.sh"
echo "[+] 2. lang_setup.sh"
echo "[+] 3. keygen"
echo "[+] 4. ssh config and put your pubkey"
echo "[+] 5. clone ctf"
echo "git clone git@bitbucket.org:nakazakit/ctf.git"



