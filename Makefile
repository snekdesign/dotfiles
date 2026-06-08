SHELL = /bin/sh

PIXI_HOME ?= $(USERPROFILE)/.pixi

.PHONY : all
all : build/all.tar.gz

.PHONY : install
install : \
		build/git/config \
		build/pixi/pixi-global.toml \
		build/pwsh/profile.ps1 \
		build/vscode/keybindings.json \
		build/vscode/settings.json \
		build/vscode/tasks.json \
		build/wt/settings.json \
		build/zed/keymap.json \
		build/zed/settings.json
	mkdir -p \
		$(USERPROFILE)/.config/git \
		$(PIXI_HOME)/manifests \
		$(USERPROFILE)/Documents/PowerShell \
		$(USERPROFILE)/Documents/WindowsPowerShell \
		$(APPDATA)/VSCodium/User \
		$(LOCALAPPDATA)/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState \
		$(APPDATA)/Zed
	cp -f build/git/config $(USERPROFILE)/.config/git
	cp -f build/pixi/pixi-global.toml $(PIXI_HOME)/manifests
	cp -f build/pwsh/profile.ps1 $(USERPROFILE)/Documents/PowerShell
	cp -f build/pwsh/profile.ps1 $(USERPROFILE)/Documents/WindowsPowerShell
	cp -f build/vscode/*.json $(subst \,/,$(APPDATA))/VSCodium/User
	cp -f build/wt/settings.json $(LOCALAPPDATA)/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState
	cp -f build/zed/*.json $(subst \,/,$(APPDATA))/Zed

.PHONY : clean
clean :
	rm -r build

build/all.tar.gz : \
		build/git/config \
		build/pixi/pixi-global.toml \
		build/pwsh/profile.ps1 \
		build/vscode/keybindings.json \
		build/vscode/settings.json \
		build/vscode/tasks.json \
		build/windows/settings.reg \
		build/wt/settings.json \
		build/zed/keymap.json \
		build/zed/settings.json
	tar -cf $@ build/*/*

build/git/config :
	mkdir -p build/git
	python scripts/mj.py src/git/config.jinja \
		> $@

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
	python scripts/mj.py src/vscode/settings.yml src/vscode/settings_win.yml.jinja \
		| yq -py -oj -I4 > $@

build/vscode/tasks.json :
	mkdir -p build/vscode
	cat src/vscode/tasks.yml src/vscode/tasks_win.yml \
		| yq -py -oj -I4 > $@

build/windows/settings.reg :
	mkdir -p build/windows
	python scripts/mj.py --output-encoding utf-16 src/windows/settings.reg.jinja \
		> $@

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
