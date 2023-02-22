all: build

build:
	nimble build

install:
	./install from_make

clean:
	rm -r nemini
