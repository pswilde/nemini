all: build
.PHONY: install

build:
	nimble build

install:
	./install from_make

clean:
	rm -r nemini
