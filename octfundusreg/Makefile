
# set this to the subfolder containing the package contents:
PKG=octfundusreg
VERSION=0.1
TARBALL=$(PKG)_$(VERSION).tar.gz
DESCRIPTION=$(PKG)/DESCRIPTION
MANUAL=$(PKG)_$(VERSION).pdf

.PHONY: install check clean uninstall

all: $(DESCRIPTION) $(TARBALL) $(MANUAL)

$(DESCRIPTION): makefile.r functions.R 
	Rscript makefile.r $(PKG) $(VERSION)

$(TARBALL): $(DESCRIPTION)
	R CMD build $(PKG)

$(MANUAL): $(DESCRIPTION)
	Rscript -e "devtools::build_manual(\"$(PKG)\")"

check: $(TARBALL)
	R CMD check --as-cran $(TARBALL)

install: $(TARBALL)
	R CMD INSTALL $(TARBALL)

uninstall: 
	Rscript -e "remove.packages(\"$(PKG)\")"

clean:
	rm -rf $(PKG) $(TARBALL) $(MANUAL) $(PKG).Rcheck

