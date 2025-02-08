SHELL = /bin/sh

.PHONY : all
all : \
	build/pwsh/profile.ps1 \
	build/vscode/keybindings.json \
	build/vscode/settings.json \
	build/vscode/tasks.json \
	build/wt/settings.json

.PHONY : clean
clean :
	rm -r build

build/pwsh/profile.ps1 :
	mkdir -p build/pwsh
	python scripts/mj.py src/pwsh/profile.ps1 src/pwsh/profile_win.ps1.jinja \
		> $@

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

build/wt/settings.json :
	mkdir -p build/wt
	python scripts/mj.py src/wt/settings.yml.jinja \
		| yq -py -oj -I4 > $@
