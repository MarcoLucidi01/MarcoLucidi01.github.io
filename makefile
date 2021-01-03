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
	@sed -n -e '1 s/^/<title>/' -e '1 s/$$/<\/title>/p' $< >> $@
	@cmark $< | sed -e 's/\.md/\.html/g' | tac | awk '!f && /<ul>/ {$$0="<ul class=\"no-bullet\">"; f=1} 1' | tac >> $@

$(INDEXMD): $(ABOUTMD) $(POSTMD)
	@echo $@
	@cp $< $@
	@printf "\nposts\n-----\n\n" >> $@
	@touch $@.tmp
	@for post in $(POSTMD); do \
		date=`sed -n '1p' $$post`; \
		title=`sed -n '3p' $$post`; \
		printf "%c %s [%s](%s)\n" "-" "$$date" "$$title" "$$post" >> $@.tmp; \
	done
	@sort -r -o $@.tmp $@.tmp
	@cat $@.tmp >> $@
	@rm $@.tmp

%.html: %.md $(HEADERHTML) $(FOOTERHTML)
	@echo $@
	@sed 's/href="/href="..\//g' $(HEADERHTML) > $@
	@sed -n -e '3 s/^/<title>/' -e '3 s/$$/<\/title>/p' $< >> $@
	@cmark $< >> $@
	@sed 's/href="/href="..\//g' $(FOOTERHTML) >> $@

post:
	@[ -n "$(TITLE)" ] || (echo error: missing TITLE=\"\" && exit 1)
	@{ \
		post=`printf "%s" "$(TITLE)" | sed -e 's/\s\+/-/g' -e 's#^#$(POSTDIR)/#' -e 's/$$/.md/'`; \
		date=`date +"%Y-%m-%d"`; \
		lentitle=`printf "%s" "$(TITLE)" | wc -m`; \
		heading=`yes '=' | head -n $$lentitle | tr -d '\n'`; \
		printf "%s\n\n%s\n%s\n\n\n" "$$date" "$(TITLE)" "$$heading" >> $$post; \
		vi $$post; \
	}

clean:
	@rm -rf $(INDEXMD) $(INDEXHTML) $(POSTHTML)
