#!/bin/bash

export LANG=ja_JP.utf-8
export LC_ALL=$LANG

if [ ! ${EUID:-${UID}} = 0 ]; then
	echo 'sorry..';
	echo 'I am not root.';
	exit 0;
fi

apt-get install -y language-pack-ja
dpkg-reconfigure tzdata
dpkg-reconfigure locales
update-locale LANG=$LANG

echo "export LANG=ja_JP.utf-8" >> $HOME/.profile
echo "[*] done. please 'source ~/.profile'"
