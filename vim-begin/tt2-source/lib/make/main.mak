D = dest

SHELL = bash

all:

include lib/make/include.mak

SASS_STYLE = compressed
# SASS_STYLE = expanded
SASS_CMD = sass --style $(SASS_STYLE)

GENERATED_CSS = src/css/style.css

SCREENSHOTS_PNGS = src/screenshots/images/romainl-macvim1.png src/screenshots/images/romainl-macvim2.png src/screenshots/images/gvim-perl-256.png
SCREENSHOTS_PNGS_PREVIEWS = $(patsubst %.png,%-preview.png,$(SCREENSHOTS_PNGS))

RSYNC = rsync --progress --verbose --rsh=ssh -a

RSYNC_EXTRA_OPTS =

HTACCESS_DEST = $(D)/.htaccess

UPLOAD_URL = hostgator:domains/vim.begin-site.org/
UPLOAD_URL_BETA = hostgator:domains/vim.begin-site.org/__Beta-ugrt/

VIM_BEGIN_SVG := dest/images/vim-begin.svg

$(VIM_BEGIN_SVG): ../vim-begin-logo/Vim-begin-logo.svg
	cp -f $< $@


WEBSITE_IMAGES_DEST = $(VIM_BEGIN_SVG)

all: $(GENERATED_CSS) $(HTACCESS_DEST) $(SCREENSHOTS_PNGS_PREVIEWS)

$(DEST_HTMLS): src/js/jq.js $(SRC_TT2S) footer.tt2 blocks.tt2
	perl bin/tt-render.pl

DEST_HTMLS__PIVOT = dest/about.html

fastrender: $(DEST_HTMLS__PIVOT)

all: $(DEST_HTMLS) dest/js/jq.js

$(HTACCESS_DEST): htaccess.conf
	cp -f $< $@

WEBSITE_SVGS__BASE := $(filter %.svg,$(WEBSITE_IMAGES_DEST))
WEBSITE_SVGS__MIN := $(WEBSITE_SVGS__BASE:%.svg=%.min.svg)
WEBSITE_SVGS__svgz := $(WEBSITE_SVGS__BASE:%.svg=%.svgz)

$(WEBSITE_SVGS__MIN): %.min.svg: %.svg
	minify --svg-precision 3 -o $@ $<

$(WEBSITE_SVGS__svgz): %.svgz: %.min.svg
	gzip --best -n < $< > $@

min_svgs: $(WEBSITE_SVGS__MIN) $(WEBSITE_SVGS__svgz)

all: min_svgs

$(GENERATED_CSS) : lib/sass/jqui-override.scss lib/sass/style.scss lib/sass/print.scss lib/sass/vim_syntax_highlighting.scss
	# $(SASS_CMD) lib/sass/style.scss $@
	compass compile
	mkdir -p $(D)/css
	cp -f src/css/*.css $(D)/css/

$(SCREENSHOTS_PNGS_PREVIEWS): %-preview.png: %.png
	convert $< -resize 400 $@

bulk-make-dirs:

upload_beta: all
	$(RSYNC) --exclude='**~' --exclude='**/.*.swp' $(RSYNC_EXTRA_OPTS) $(D)/ $(UPLOAD_URL_BETA)

upload: all
	$(RSYNC) --exclude='**~' --exclude='**/.*.swp' $(RSYNC_EXTRA_OPTS) $(D)/ $(UPLOAD_URL)

test: all
	prove Tests/*.{py,t}

src/js/jq.js: node_modules/jquery/dist/jquery.min.js
	cp -f $< $@

all: src/js/jq.js

.PHONY: bulk-make-dirs fastrender
