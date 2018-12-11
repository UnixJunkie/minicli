.PHONY: build clean edit install uninstall reinstall test

build:
	dune build @install

clean:
	dune clean

edit:
	emacs *.ml *.mli &

install:
	dune build @install
	dune install

uninstall:
	dune uninstall

reinstall: uninstall install

test:
	dune build test.exe
	_build/default/test.exe
