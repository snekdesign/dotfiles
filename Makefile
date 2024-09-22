SHELL = /bin/sh

.PHONY : all
all : \
	build/vscode/keybindings.json \
	build/vscode/settings.json \
	build/vscode/tasks.json

.PHONY : clean
clean :
	rm -r build

build/vscode/keybindings.json :
	mkdir -p build/vscode
	cat src/vscode/keybindings.yml src/vscode/keybindings_win.yml \
		| yq -py -oj -I4 > $@

build/vscode/settings.json :
	mkdir -p build/vscode
	cat src/vscode/settings.yml src/vscode/settings_win.yml \
		| yq -py -oj -I4 > $@

build/vscode/tasks.json :
	mkdir -p build/vscode
	cat src/vscode/tasks.yml src/vscode/tasks_win.yml \
		| yq -py -oj -I4 > $@
