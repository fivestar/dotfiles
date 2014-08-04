#!/bin/bash

git submodule init
git submodule update

for dotfile in .gitconfig .gvimrc .lv .my.cnf .screenrc .vimrc. zshrc
do
  rm -fr ~/$dotfile
  ln -vnfs $PWD/$dotfile ~/$dotfile
done
