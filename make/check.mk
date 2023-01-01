# Sub-Makefile (included by main Makefile)

# Build *directory* path for ToDo comments locations log
TODO_BUILD_PATH := $(ROOT_BUILD_PATH)/todo

# Find ToDos in code base
HELP += find-todo~Find_ToDos_in_code_base
.PHONY: find-todo
find-todo: OUT_FIL := todo.txt
find-todo: TODO_MARKER := TODO:
find-todo:
	@mkdir -p $(TODO_BUILD_PATH)/
	@echo "$(PROMPT)  Find ToDos in code base" \
	    2>&1 | tee $(TODO_BUILD_PATH)/$(OUT_FIL)
	@find \
	    . \
	    -type d \( \
	        -name .git -o \
	        -path "./$(ROOT_BUILD_PATH)*" \
	        \) -prune -o \
	    -type f -exec grep -Hn "$(TODO_MARKER)" {} + | \
	    grep -v ":= $(TODO_MARKER)" \
	    2>&1 | tee -a $(TODO_BUILD_PATH)/$(OUT_FIL) || exit 0
	@echo "---" \
	    2>&1 | tee -a $(TODO_BUILD_PATH)/$(OUT_FIL)
	@echo \
	    "$(PROMPT)  Total TODO comments count: $$(grep -c "$(TODO_MARKER)" $(TODO_BUILD_PATH)/$(OUT_FIL))" \
	    2>&1 | tee -a $(TODO_BUILD_PATH)/$(OUT_FIL)
	@grep -q "$(TODO_MARKER)" $(TODO_BUILD_PATH)/$(OUT_FIL) && \
	    exit 1 || exit 0

# Cleanup
HELP += clean-find-todo~Clean_up_target
.PHONY: clean-find-todo
clean-find-todo:
	rm -rf $(TODO_BUILD_PATH)/*
	@echo "$(PROMPT)  All cleaned up"
