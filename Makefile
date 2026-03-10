SHELL = /bin/sh

.PHONY : all
all : build/all.tar.gz

.PHONY : clean
clean :
	rm -r build

build/all.tar.gz : \
		build/pixi/pixi-global.toml \
		build/pwsh/profile.ps1 \
		build/vscode/keybindings.json \
		build/vscode/settings.json \
		build/vscode/tasks.json \
		build/wt/settings.json \
		build/zed/keymap.json \
		build/zed/settings.json
	tar -cf $@ build/*/*

build/pixi/pixi-global.toml :
	mkdir -p build/pixi
	python scripts/mj.py src/pixi/pixi-global.toml.jinja \
		> $@

build/pwsh/profile.ps1 :
	mkdir -p build/pwsh
	python scripts/mj.py src/pwsh/profile.ps1.jinja src/pwsh/profile_win.ps1.jinja \
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

build/zed/keymap.json :
	mkdir -p build/zed
	cat src/zed/keymap.yml src/zed/keymap_win.yml \
		| yq -py -oj -I4 > $@

build/zed/settings.json :
	mkdir -p build/zed
	cat src/zed/settings.yml src/zed/settings_win.yml \
		| yq -py -oj -I4 > $@
