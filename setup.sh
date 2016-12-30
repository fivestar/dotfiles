#!/bin/bash

cd $(dirname $0)

git submodule init
git submodule update

for dotfile in .gitconfig .gvimrc .lv .peco .screenrc .vimrc .zprofile .zshrc .atom
do
  rm -fr ~/$dotfile
  ln -vnfs $PWD/$dotfile ~/$dotfile
done

# mysql
mycnfpath=$HOME/.my.cnf
mysqldir=$HOME/.mysql

rm -fr $mycnfpath
echo "!includedir $mysqldir" > $mycnfpath

if [ ! -d $mysqldir ]; then
    mkdir -p $mysqldir
fi

for myfile in default.cnf
do
  rm -fr $mysqldir/$myfile
  ln -vnfs $PWD/.mysql/$myfile $mysqldir/$myfile
done

# composer
if type composer >/dev/null 2>&1; then
    composer config --global bin-dir "~/bin"
fi
