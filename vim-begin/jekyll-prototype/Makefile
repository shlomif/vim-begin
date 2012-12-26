GENERATED_HTMLS = _site/index.html

all: $(GENERATED_HTMLS)

$(GENERATED_HTMLS) : atom.xml CNAME _config.yml pgp.txt README.textile _layouts/default.html index.html
	jekyll

RSYNC = rsync --progress --verbose --rsh=ssh

upload: all
	$(RSYNC) -a ./_site $${__HOMEPAGE_REMOTE_PATH}/vim-begin-temp-M90J67C27/
