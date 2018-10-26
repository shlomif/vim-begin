# GENERATED_HTMLS = _site/index.html _site/books/index.html _site/mailing-lists/index.html
D = dest

SHELL = bash

all:

include lib/make/include.mak

SASS_STYLE = compressed
# SASS_STYLE = expanded
SASS_CMD = sass --style $(SASS_STYLE)

SOURCES = $(shell find src -name '*.html') _config.yml atom.xml CNAME README.textile
GENERATED_HTMLS = $(shell find _site -name '*.html')
GENERATED_CSS = src/css/style.css

SCREENSHOTS_PNGS = src/screenshots/images/romainl-macvim1.png src/screenshots/images/romainl-macvim2.png src/screenshots/images/gvim-perl-256.png
SCREENSHOTS_PNGS_PREVIEWS = $(patsubst %.png,%-preview.png,$(SCREENSHOTS_PNGS))

RSYNC = rsync --progress --verbose --rsh=ssh -a

RSYNC_EXTRA_OPTS =

DESTS = $(D)/index.html
HTACCESS_DEST = $(D)/.htaccess

UPLOAD_URL = hostgator:domains/vim.begin-site.org/
UPLOAD_URL_BETA = hostgator:domains/vim.begin-site.org/__Beta-ugrt/

VIM_BEGIN_SVG := dest/images/vim-begin.svg

$(VIM_BEGIN_SVG): ../vim-begin-logo/Vim-begin-logo.svg
	cp -f $< $@


T2_IMAGES_DEST = $(VIM_BEGIN_SVG)

all: $(GENERATED_CSS) $(DESTS) $(HTACCESS_DEST) $(SCREENSHOTS_PNGS_PREVIEWS)

$(DEST_HTMLS): $(SRC_TT2S) footer.tt2 blocks.tt2
	perl process.pl

$(HTACCESS_DEST): htaccess.conf
	cp -f $< $@

T2_SVGS__BASE := $(filter %.svg,$(T2_IMAGES_DEST))
T2_SVGS__MIN := $(T2_SVGS__BASE:%.svg=%.min.svg)
T2_SVGS__svgz := $(T2_SVGS__BASE:%.svg=%.svgz)

$(T2_SVGS__MIN): %.min.svg: %.svg
	minify --svg-decimals 3 -o $@ $<

$(T2_SVGS__svgz): %.svgz: %.min.svg
	gzip --best < $< > $@

min_svgs: $(T2_SVGS__MIN) $(T2_SVGS__svgz)

all: min_svgs

$(GENERATED_CSS) : lib/sass/jqui-override.scss lib/sass/style.scss lib/sass/print.scss lib/sass/vim_syntax_highlighting.scss
	# $(SASS_CMD) lib/sass/style.scss $@
	compass compile
	mkdir -p $(D)/css
	cp -f src/css/*.css $(D)/css/

$(SCREENSHOTS_PNGS_PREVIEWS): %-preview.png: %.png
	convert $< -resize 400 $@

upload_beta: all
	$(RSYNC) --exclude='**~' --exclude='**/.*.swp' $(RSYNC_EXTRA_OPTS) $(D)/ $(UPLOAD_URL_BETA)

upload: all
	$(RSYNC) --exclude='**~' --exclude='**/.*.swp' $(RSYNC_EXTRA_OPTS) $(D)/ $(UPLOAD_URL)

test: all
	prove Tests/*.{py,t}
