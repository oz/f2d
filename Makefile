
all: clean
	coffee -bc -o lib src/

watch:
	coffee -wbc -o lib src/

clean:
	rm -rf ./lib
	mkdir lib

PHONY: all watch
