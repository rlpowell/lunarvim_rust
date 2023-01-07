#!/bin/bash

# https://github.com/xd009642/tarpaulin/issues/1088
cargo watch -x check -x test -x "tarpaulin --target-dir target/tarpaulin-target/ --skip-clean" -x audit -x run
