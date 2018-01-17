#!/bin/bash

# based on: http://pastebin.com/RjmDapEv

HOME=/home/vagrant

cd $HOME
pwd
mkdir -p local/bin

# ■common
sudo apt-get update && sudo apt upgrade -y
sudo apt-get install -y vim tmux gdb gdbserver socat binutils nasm python git autoconf libtool make || \
        (echo "[!] apt-get install failed"; exit)

# To use x86 binary at x86_64 enviroment.
sudo apt-get install -y gcc-multilib lib32z1 lib32ncurses5 lib32bz2-1.0
sudo apt-get install -y libc6:i386

# ■peda
cd $HOME
git clone https://github.com/longld/peda.git $HOME/peda
echo source $HOME/peda/peda.py >> $HOME/.gdbinit
 
# ■rp++
cd $HOME
wget -q https://github.com/downloads/0vercl0k/rp/rp-lin-x64
chmod +x rp-lin-x64 && mv rp-lin-x64 local/bin

# ■dotfiles
cd $HOME
git clone https://github.com/tty-nkzk/dotfiles.git 
ln -s dotfiles/.tmux.conf .tmux.conf
ln -s dotfiles/.vimrc .vimrc


# ■checksec
cd $HOME
git clone https://github.com/slimm609/checksec.sh.git 
cd local/bin
ln -s checksec.sh/checksec checksec

echo 'export PATH="/home/vagrant/local/bin:$PATH"' >> .bashrc

 
# ■disas-seccomp-filter
cd $HOME
git clone git://github.com/seccomp/libseccomp && cd libseccomp
./autogen.sh && ./configure && make
cp tools/scmp_bpf_disasm tools/scmp_sys_resolver /usr/local/bin
wget -q https://raw.githubusercontent.com/akiym/akitools/master/disas-seccomp-filter
chmod +x disas-seccomp-filter && mv disas-seccomp-filter /usr/local/bin


# 以下，使うかどうかわからないけど取り敢えず
 
# ■libheap
cd $HOME
apt-get install -y libc6-dbg || \
        (echo "[!] apt-get install failed"; exit)
wget -q http://pastebin.com/raw/8Mx8A1zG -O libheap.py
echo 'from .libheap import *' > __init__.py
mkdir -p /usr/local/lib/python3.4/dist-packages/libheap/
mv libheap.py __init__.py /usr/local/lib/python3.4/dist-packages/libheap/
echo -e 'define heap\n  python from libheap import *\nend' >> $HOME/.gdbinit
 
# ■katana
cd $HOME
apt-get -y install libelf-dev libdwarf-dev libunwind8-dev libreadline-dev bison flex g++
git clone git://git.savannah.nongnu.org/katana.git && cd katana
ls /usr/bin/aclocal-1.15 || ln -s /usr/bin/aclocal-1.14 /usr/bin/aclocal-1.15
ls /usr/bin/automake-1.15 || ln -s /usr/bin/automake-1.14 /usr/bin/automake-1.15
sed -i '784,787d' src/patchwrite/patchwrite.c
sed -i '783a\int res=dwarf_producer_init(flags,dwarfWriteSectionCallback,dwarfErrorHandler,NULL,&err);' src/patchwrite/patchwrite.c
./configure && make
sed -i 's/\($(AM_V_CCLD).*\)/\1 $(lebtest_LDFLAGS)/' tests/code/Makefile
make && make install

chown vagrant:vagrant -R $HOME
echo "[+] bootstrap.sh done!"

