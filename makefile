.POSIX:
.PHONY: all post clean

GENERATE   = ./generate
POSTSDIR   = posts
POSTSMD    = $(wildcard $(POSTSDIR)/*.md)
POSTSHTML  = $(patsubst %.md, %.html, $(POSTSMD))
ABOUTMD    = about.md
INDEXMD    = index.md
INDEXHTML  = index.html
HEADERHTML = header.html
FOOTERHTML = footer.html
BASEURL    = https://marcolucidi01.github.io
RSSXML     = rss.xml
LANG       = en

all: $(INDEXHTML) $(RSSXML) $(POSTSHTML)

$(INDEXHTML): $(HEADERHTML) $(INDEXMD)
	@echo $@
	@$(GENERATE) indexhtml $^ > $@

$(INDEXMD): $(ABOUTMD) $(POSTSMD)
	@echo $@
	@$(GENERATE) indexmd "$(RSSXML)" $^ > $@

$(RSSXML): $(ABOUTMD) $(POSTSHTML)
	@echo $@
	@$(GENERATE) rssxml "$(BASEURL)" "$@" "$(LANG)" $^ > $@

%.html: $(HEADERHTML) %.md $(FOOTERHTML)
	@echo $@
	@$(GENERATE) posthtml $^ > $@

post:
	@$(GENERATE) newpost "$(POSTSDIR)" "$(TITLE)"

clean:
	@rm -f $(INDEXHTML) $(INDEXMD) $(RSSXML) $(POSTSHTML)
