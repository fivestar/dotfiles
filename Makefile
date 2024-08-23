DOTEXCLUDES := .DS_Store .git
DOTTARGETS  := $(wildcard .??*)
DOTFILES    := $(filter-out $(DOTEXCLUDES), $(DOTTARGETS))
TMP_DIR     := $(HOME)/tmp

.PHONY: all
all: update deploy

.PHONY: list
list:
	@$(foreach dotfile, $(DOTFILES), ls -dF $(dotfile);)

.PHONY: update
update:
	@git pull

.PHONY: deploy
deploy:
	@$(foreach dotfile, $(DOTFILES), ln -vnfs $(abspath $(dotfile)) $(HOME)/$(dotfile);)

.PHONY: clean
clean:
	@-$(foreach dotfile, $(DOTFILES), rm -vrf $(HOME)/$(dotfile);)

.PHONY: tmpdir

$(TMP_DIR):
	@mkdir -p $(TMP_DIR)
	@chmod 700 $(TMP_DIR)

tmpdir: $(TMP_DIR)

