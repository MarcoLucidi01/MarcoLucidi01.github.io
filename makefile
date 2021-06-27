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
RSSXML     = rss.xml
BASEURL    = https://marcolucidi01.github.io

all: $(INDEXHTML) $(RSSXML) $(POSTSHTML)

$(INDEXHTML): $(HEADERHTML) $(INDEXMD)
	@echo $@
	@$(GENERATE) indexhtml $^ > $@

$(INDEXMD): $(ABOUTMD) $(POSTSMD)
	@echo $@
	@$(GENERATE) indexmd "$(RSSXML)" $^ > $@

$(RSSXML): $(ABOUTMD) $(POSTSHTML)
	@echo $@
	@$(GENERATE) rssxml "$(BASEURL)" "$(RSSXML)" $^ > $@

%.html: $(HEADERHTML) %.md $(FOOTERHTML)
	@echo $@
	@$(GENERATE) posthtml $^ > $@

post:
	@$(GENERATE) newpost "$(POSTSDIR)" "$(TITLE)"

clean:
	@rm -f $(INDEXHTML) $(INDEXMD) $(RSSXML) $(POSTSHTML)
