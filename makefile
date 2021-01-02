.PHONY: all post clean

POSTDIR    := posts
POSTMD     := $(shell find $(POSTDIR) -type f -name '*.md')
POSTHTML   := $(patsubst %.md, %.html, $(POSTMD))
ABOUTMD    := about.md
INDEXMD    := index.md
INDEXHTML  := index.html
HEADERHTML := header.html
FOOTERHTML := footer.html

all: $(INDEXHTML) $(POSTHTML)

$(INDEXHTML): $(INDEXMD) $(HEADERHTML)
	@echo $@
	@cp $(HEADERHTML) $@
	@sed -n '1p' $< | sed -e 's/^# /<title>/' -e 's/$$/<\/title>/' >> $@
	@cmark $< | sed -e 's/\.md/\.html/g' -e 's/<ul>/<ul class="no-bullet">/' >> $@

$(INDEXMD): $(ABOUTMD) $(POSTMD)
	@echo $@
	@cp $< $@
	@echo >> $@
	@touch $@.tmp
	@for post in $(POSTMD); do \
		date=`sed -n '1p' $$post`; \
		title=`sed -n '3p' $$post | sed 's/^# //'`; \
		printf "%c %s: [%s](%s)\n" "-" "$$date" "$$title" "$$post" >> $@.tmp; \
	done
	@sort -r -o $@.tmp $@.tmp
	@cat $@.tmp >> $@
	@rm $@.tmp

%.html: %.md $(HEADERHTML) $(FOOTERHTML)
	@echo $@
	@sed 's/href="/href="..\//g' $(HEADERHTML) > $@
	@sed -n '3p' $< | sed -e 's/^# /<title>/' -e 's/$$/<\/title>/' >> $@
	@cmark $< >> $@
	@sed 's/href="/href="..\//g' $(FOOTERHTML) >> $@

post:
	@[ -n "$(TITLE)" ] || (echo error: missing TITLE=\"\" && exit 1)
	@{ \
		date=`date +"%Y-%m-%d"`; \
		post=`echo $(TITLE) | sed -e 's/ /-/g' -e 's#^#$(POSTDIR)/#' -e 's/$$/.md/'`; \
		printf "%s\n\n# %s\n" "$$date" "$(TITLE)" >> $$post; \
		vi $$post; \
	}

clean:
	@rm -rf $(INDEXMD) $(INDEXHTML) $(POSTHTML)
