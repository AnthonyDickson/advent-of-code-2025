MAIN = app/Main.hs

.PHONY: test run build benchmark fmt clean

test:
	cabal test

run:
	cabal run

build: $(MAIN)
	cabal build

benchmark: build
	hyperfine --time-unit microsecond -N $(shell cabal list-bin aoc)
	time -v $(shell cabal list-bin aoc)

clean:
	cabal clean

