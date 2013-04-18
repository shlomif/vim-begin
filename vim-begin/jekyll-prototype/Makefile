# GENERATED_HTMLS = _site/index.html _site/books/index.html _site/mailing-lists/index.html
D = dest

SOURCES = $(shell find src -name '*.html') _config.yml atom.xml CNAME README.textile
GENERATED_HTMLS = $(shell find _site -name '*.html')
GENERATED_CSS = src/css/style.css

SCREENSHOTS_PNGS = src/screenshots/images/romainl-macvim1.png src/screenshots/images/romainl-macvim2.png src/screenshots/images/gvim-perl-256.png
SCREENSHOTS_PNGS_PREVIEWS = $(patsubst %.png,%-preview.png,$(SCREENSHOTS_PNGS))

RSYNC = rsync --progress --verbose --rsh=ssh

RSYNC_EXTRA_OPTS =

DESTS = $(D)/index.html
HTACCESS_DEST = $(D)/.htaccess

UPLOAD_URL = hostgator:public_html/temp-www.linux.org.il-new-site/

all: $(GENERATED_CSS) $(DESTS) $(HTACCESS_DEST) $(SCREENSHOTS_PNGS_PREVIEWS)

$(DESTS): $(D)/%.html: src/%.html.tt2 footer.tt2 blocks.tt2
	perl process.pl

$(HTACCESS_DEST): htaccess.conf
	cp -f $< $@

$(GENERATED_CSS) : sass/jqui-override.sass sass/style.sass sass/print.sass sass/vim_syntax_highlighting.sass
	compass compile
	mkdir -p $(D)/css
	cp -f src/css/*.css $(D)/css/

$(SCREENSHOTS_PNGS_PREVIEWS): %-preview.png: %.png
	convert $< -resize 400 $@

upload: all
	$(RSYNC) --exclude='**~' --exclude='**/.*.swp' $(RSYNC_EXTRA_OPTS) $(D)/ $(UPLOAD_URL)
