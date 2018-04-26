.PHONY: check-ready check-live

# Used default value from nodejs.config.js
host ?= localhost
max_try ?= 1
wait_seconds ?= 1
delay_seconds ?= 0

default: check-ready

check-ready:
	wait_for_node $(host) $(max_try) $(wait_seconds) $(delay_seconds)

check-live:
	@echo "OK"
