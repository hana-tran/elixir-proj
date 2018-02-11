TEST_LOG_FILE := test.log

.PHONY: compile deps_compile deps_get apps clean distclean test

compile:
	@mix compile

apps:
	@mix compile --no-deps-check --no-npm

clean:
	@mix clean

distclean: clean clean-deps clean-docs
	@mix clean --deps

deps_compile: deps_get
	@mix deps.compile

deps_get:
	@mix deps.get

test:
	@mix test

# Dialyzer

.PHONY: dialyzer

dialyzer:
	@echo "-*- mode: compilation-minor; eval: (auto-revert-mode 1) -*-" > .dialyzer_result
	mix dialyzer | tee .dialyzer_result
	mv .dialyzer_result dialyzer_result

# Releases

.PHONY: rel
rel: deps_get docs
	MIX_ENV=prod mix release
