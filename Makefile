ROOT := $(shell git rev-parse --show-toplevel)
FVM := $(ROOT)/.fvm/flutter_sdk/bin/flutter
FLUTTER := $(shell which flutter)
FLUUTER_BIN_DIR := $(shell dirname $(FLUTTER))
FLUTTER_DIR := $(FLUTTER_BIN_DIR:/bin=)
DART := $(FLUTTER_BIN_DIR)/cache/dart-sdk/bin/dart

dryRun:
	@echo "패키지 검증 시작"
	@${FLUTTER} pub publish --dry-run

publish:
	@echo "패키지 업로드 시작"
	@${FLUTTER} pub publish