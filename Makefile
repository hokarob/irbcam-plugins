.PHONY: build

# Directories
PLUGIN_DIR := ./plugins
BUILD_DIR := ./build

# Find all directories inside PLUGIN_DIR
PLUGIN_DIRS := $(wildcard $(PLUGIN_DIR)/*/)
ZIP_FILES := $(patsubst $(PLUGIN_DIR)/%/,$(BUILD_DIR)/%.zip,$(PLUGIN_DIRS))


all:
	@echo "Hello $(LOGNAME), nothing to do by default"
	@echo "Try 'make help'"

# target: help - Display callable targets.
help:
	@egrep "^# target:" [Mm]akefile

# target: archives - Make ZIP archives of plugins
archives: $(ZIP_FILES)

# Rule to create zip files
$(BUILD_DIR)/%.zip: $(PLUGIN_DIR)/%
	@mkdir -p $(BUILD_DIR)
	# zip -r $@ $<
	cd $</.. && zip -r ../$@ ./*

# target: clean - Clean target to remove all zip files
clean:
	rm -f $(BUILD_DIR)/*.zip