.PHONY: example clean
example:
	typst compile --format svg --root . examples/main.typ examples/main_{p}.svg
clean:
	rm examples/main.pdf
	
