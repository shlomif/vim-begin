GENERATED_HTMLS = _site/index.html
GENERATED_CSS = _site/css/style.css

all: $(GENERATED_HTMLS) $(GENERATED_CSS)

$(GENERATED_HTMLS) : atom.xml CNAME _config.yml pgp.txt README.textile _layouts/default.html index.html
	jekyll

$(GENERATED_CSS) : sass/jqui-override.sass sass/style.sass sass/print.sass sass/vim_syntax_highlighting.sass
	compass compile
	mkdir -p _site/css
	cp -f src/*.css _site/css

RSYNC = rsync --progress --verbose --rsh=ssh

upload: all
	$(RSYNC) -a ./_site $${__HOMEPAGE_REMOTE_PATH}/vim-begin-temp-M90J67C27/
