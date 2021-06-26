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

all: $(INDEXHTML) $(POSTSHTML)

$(INDEXHTML): $(HEADERHTML) $(INDEXMD)
	@echo $@
	@$(GENERATE) indexhtml $^ > $@

$(INDEXMD): $(ABOUTMD) $(POSTSMD)
	@echo $@
	@$(GENERATE) indexmd $^ > $@

%.html: $(HEADERHTML) %.md $(FOOTERHTML)
	@echo $@
	@$(GENERATE) posthtml $^ > $@

post:
	@$(GENERATE) newpost "$(POSTSDIR)" "$(TITLE)"

clean:
	@rm -f $(INDEXMD) $(INDEXHTML) $(POSTSHTML)
