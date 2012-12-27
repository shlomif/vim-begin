GENERATED_HTMLS = _site/index.html _site/books/index.html _site/mailing-lists/index.html
GENERATED_CSS = _site/src/css/style.css

all: $(GENERATED_HTMLS) $(GENERATED_CSS)

$(GENERATED_HTMLS) : atom.xml CNAME _config.yml pgp.txt README.textile src/_layouts/default.html src/index.html src/books/index.html src/mailing-lists/index.html src/about.html
	jekyll

$(GENERATED_CSS) : sass/jqui-override.sass sass/style.sass sass/print.sass sass/vim_syntax_highlighting.sass
	compass compile
	mkdir -p _site/css
	cp -f src/*.css _site/css

RSYNC = rsync --progress --verbose --rsh=ssh

upload: all
	$(RSYNC) -a ./_site/* hostgator:domains/vim.begin-site.org/
