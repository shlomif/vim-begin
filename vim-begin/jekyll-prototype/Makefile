# GENERATED_HTMLS = _site/index.html _site/books/index.html _site/mailing-lists/index.html
SOURCES = $(shell find src -name '*.html') _config.yml atom.xml CNAME README.textile
GENERATED_HTMLS = $(shell find _site -name '*.html')
GENERATED_CSS = src/css/style.css

all: $(GENERATED_HTMLS) $(GENERATED_CSS)

$(GENERATED_HTMLS) : $(SOURCES)
	jekyll

$(GENERATED_CSS) : sass/jqui-override.sass sass/style.sass sass/print.sass sass/vim_syntax_highlighting.sass
	compass compile
	mkdir -p _site/css
	cp -f src/css/*.css _site/css

RSYNC = rsync --progress --verbose --rsh=ssh

upload: all
	$(RSYNC) -a ./_site/* hostgator:domains/vim.begin-site.org/
