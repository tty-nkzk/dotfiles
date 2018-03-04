#!/bin/bash

#*******************************************************
cd $HOME

sudo apt-get -y update
sudo apt-get -y upgrade

sudo apt-get -y install mercurial gettext libncurses5-dev libxmu-dev libgnomeui-dev

sudo apt-get -y install lua5.2 liblua5.2-dev

sudo apt-get -y install libperl-dev python-dev python3-dev ruby-dev 

# hg clone https://vim.googlecode.com/hg/ vim
# hg pull -u
git clone https://github.com/vim/vim.git local/src/vim


cd local/src/vim/src
./configure --prefix=$HOME/local --with-features=huge --enable-gui=gnome2 --enable-fail-if-missing --enable-rubyinterp --enable-pythoninterp --enable-perlinterp --enable-python3interp --enable-luainterp --enable-multibyte
make
sudo make install

# cd
# sudo apt-get -y install git
# mkdir -p .vim/bundle
# mkdir .vim/colors
# 
# git clone git://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
# git clone git://github.com/tomasr/molokai
# mv molokai/colors/molokai.vim .vim/colors/
# rm -rf molokai
