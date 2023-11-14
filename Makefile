DESTDIR=docs

.PHONY: all
all:



.PHONY: clean
clean:
	@echo "? Cleaning old build"
	cd $(DESTDIR) && rm -rf *


.PHONY: build
build:
	@echo "? Generating site"
	hugo --gc -d $(DESTDIR)
	echo -e "\n\n\n"
	git status | grep posts | grep -v 'posts\/index'
	echo -e "\n\n\n"
	git add -p $(DESTDIR)
	git commit
