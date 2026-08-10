.PHONY: build

# Directories
PLUGIN_DIR := plugins
BUILD_DIR := build

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
	@echo Plugin archives exported

# Rule to create zip files
$(BUILD_DIR)/%.zip: $(PLUGIN_DIR)/%
	@# Make sure the build directory exists
	@mkdir -p $(BUILD_DIR)
	@# Zip files
	@cd $(PLUGIN_DIR) && zip -r ../$@ $(patsubst $(PLUGIN_DIR)/%,%,$<)


# target: clean - Clean target to remove all zip files
clean:
	rm -f $(BUILD_DIR)/*.zip