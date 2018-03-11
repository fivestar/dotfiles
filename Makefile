DOTEXCLUDES := .DS_Store .git
DOTTARGETS  := $(wildcard .??*)
DOTFILES    := $(filter-out $(DOTEXCLUDES), $(DOTTARGETS))

.PHONY: all
all: update deploy

.PHONY: list
list:
	@$(foreach dotfile, $(DOTFILES), ls -dF $(dotfile);)

.PHONY: update
update:
	git pull origin master

.PHONY: deploy
deploy:
	@$(foreach dotfile, $(DOTFILES), ln -vnfs $(abspath $(dotfile)) $(HOME)/$(dotfile);)

.PHONY: clean
clean:
	@-$(foreach dotfile, $(DOTFILES), rm -vrf $(HOME)/$(dotfile);)

