.POSIX:
.PHONY: all post link clean

GENERATE       = ./generate
POSTSDIR       = posts
POSTSINDEXMD   = $(POSTSDIR)/index.md
POSTSINDEXHTML = $(POSTSDIR)/index.html
POSTSMD        = $(shell find $(POSTSDIR) -name "*.md" ! -wholename "$(POSTSINDEXMD)")
POSTSHTML      = $(patsubst %.md, %.html, $(POSTSMD))
ABOUTMD        = about.md
INDEXMD        = index.md
LINKSMD        = links.md
INDEXHTML      = index.html
LINKSHTML      = links.html
HEADERHTML     = header.html
FOOTERHTML     = footer.html
RSSXML         = rss.xml
BASEURL        = https://marcolucidi01.github.io

all: $(INDEXHTML) $(LINKSHTML) $(POSTSINDEXHTML) $(POSTSHTML) $(RSSXML)

$(INDEXHTML): $(HEADERHTML) $(ABOUTMD) $(INDEXMD)
	@echo $@
	@$(GENERATE) indexhtml $^ > $@

$(LINKSHTML): $(HEADERHTML) $(ABOUTMD) $(LINKSMD) $(FOOTERHTML)
	@echo $@
	@$(GENERATE) linkshtml $^ > $@

# INDEXMD should be just a redirect to ABOUTMD, but i don't know how to make redirects in github pages
$(INDEXMD): $(ABOUTMD)
	@echo $@
	@cp $< $@

$(POSTSINDEXHTML): $(HEADERHTML) $(ABOUTMD) $(POSTSINDEXMD) $(FOOTERHTML)
	@echo $@
	@$(GENERATE) postsindexhtml $^ > $@

$(POSTSINDEXMD): $(POSTSMD)
	@echo $@
	@$(GENERATE) postsindexmd $^ > $@

$(RSSXML): $(ABOUTMD) $(POSTSHTML)
	@echo $@
	@$(GENERATE) rssxml "$(BASEURL)" "$(RSSXML)" $^ > $@

%.html: $(HEADERHTML) %.md $(FOOTERHTML)
	@echo $@
	@$(GENERATE) posthtml $^ > $@

post:
	@$(GENERATE) newpost "$(POSTSDIR)" "$(TITLE)"

link:
	@$(GENERATE) newlink "$(LINKSMD)"

clean:
	@rm -f $(INDEXHTML) $(INDEXMD) $(POSTSINDEXHTML) $(POSTSINDEXMD) $(POSTSHTML) $(RSSXML)
