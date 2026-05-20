.PHONY: help package clean

help:
	@echo "Available targets:"
	@echo "  make package  - create release zip"
	@echo "  make clean    - remove build artifacts"

package:
	bash scripts/package_pak.sh

clean:
	rm -rf dist
