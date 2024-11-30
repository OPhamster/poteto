build: lib/ lib/poteto/
	gem build poteto.gemspec

install: build
	gem install ./poteto-0.1.0.gem

run: install
	./bin/poteto ${COMMIT_ID}
