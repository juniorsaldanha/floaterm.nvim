TESTS_INIT=tests/minimal_init.lua
TESTS_DIR=tests/

.PHONY: nvim_minimal
nvim_minimal:
	nvim --noplugin -u scripts/minimal_init.vim

# TODO: This is not working so far
.PHONY: test
test:
	@nvim \
		--headless \
		--noplugin \
		-u ${TESTS_INIT} \
		-c "PlenaryBustedDirectory ${TESTS_DIR} { minimal_init = '${TESTS_INIT}' }"
