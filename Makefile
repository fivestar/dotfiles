EXCLUDES := .DS_Store .git
DOTFILES := $(filter-out $(EXCLUDES), $(wildcard .??*))

.PHONY: all
all: up

.PHONY: list
list:
	@$(foreach dotfile, $(DOTFILES), ls -dF $(dotfile);)

.PHONY: up
up: update install

.PHONY: update
update:
	git pull origin master

.PHONY: install
install:
	@$(foreach dotfile, $(DOTFILES), ln -vnfs $(abspath $(dotfile)) $(HOME)/$(dotfile);)

.PHONY: clean
clean:
	@-$(foreach dotfile, $(DOTFILES), rm -vrf $(HOME)/$(dotfile);)


