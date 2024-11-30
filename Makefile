build: lib/ lib/poteto/
	gem build poteto.gemspec

install: build
	gem install ./poteto-0.1.0.gem

shell: install
	irb -r poteto

run: install
	./bin/poteto -n -a ${ACCESS_TOKEN} ${COMMIT_ID} ${PR_ID}
