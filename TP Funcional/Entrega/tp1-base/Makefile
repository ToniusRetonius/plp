# --ghc 9.4.8 --cabal 3.12.1.0 son las versiones recommendades al momento de escribir este Makefile
GHC_VERION=9.4.8
CABAL_VERSION=3.12.1.0
GHCUP_ENV=ghcup run --ghc $(GHC_VERION) --cabal $(CABAL_VERSION)

.PHONY: test
test:
	$(GHCUP_ENV) -- cabal run

.PHONY: repl
repl:
	$(GHCUP_ENV) -- cabal repl 

bin/ghcid:
	$(GHCUP_ENV) -- cabal install ghcid --installdir=bin

.PHONY: watch
watch: bin/ghcid
	$(GHCUP_ENV) -- bin/ghcid --warnings --test main

.PHONY: clean
clean:
	rm -rf dist-newstyle
	rm -rf bin