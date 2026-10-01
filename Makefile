SHELL = /bin/bash

CARGO_HOME ?= $(USERPROFILE)/.cargo
PIXI_HOME ?= $(USERPROFILE)/.pixi
TOMBI_CACHE_HOME ?= $(USERPROFILE)/.cache/tombi

.PHONY : all
all : build/all.tar.xz

.PHONY : install
install : \
		build/cargo/config.toml \
		build/pixi/pixi-global.toml \
		build/pwsh/profile.ps1 \
		build/vscode/keybindings.json \
		build/vscode/settings.json \
		build/vscode/tasks.json \
		build/wt/settings.json \
		build/zed/keymap.json \
		build/zed/settings.json
	mkdir -p \
		'$(CARGO_HOME)' \
		'$(PIXI_HOME)/manifests' \
		'$(USERPROFILE)/Documents/PowerShell' \
		'$(USERPROFILE)/Documents/WindowsPowerShell' \
		'$(APPDATA)/VSCodium/User' \
		'$(LOCALAPPDATA)/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState' \
		'$(APPDATA)/Zed'
	cp -f build/cargo/config.toml '$(CARGO_HOME)'
	cp -f build/pixi/pixi-global.toml '$(PIXI_HOME)/manifests'
	cp -f build/pwsh/profile.ps1 '$(USERPROFILE)/Documents/PowerShell'
	cp -f build/pwsh/profile.ps1 '$(USERPROFILE)/Documents/WindowsPowerShell'
	cp -f build/vscode/*.json '$(APPDATA)/VSCodium/User'
	cp -f build/wt/settings.json '$(LOCALAPPDATA)/Packages/Microsoft.WindowsTerminal_8wekyb3d8bbwe/LocalState'
	cp -f build/zed/*.json '$(APPDATA)/Zed'

.PHONY : wsl
wsl : build/wsl/rootfs.tar.xz

.PHONY : clean
clean :
	rm -r build

.SECONDARY : build/wsl/cidfile build/wsl/iidfile build/wsl/tombi.tar.xz

build/all.tar.xz : \
		build/cargo/config.toml \
		build/pixi/pixi-global.toml \
		build/pwsh/profile.ps1 \
		build/vscode/keybindings.json \
		build/vscode/settings.json \
		build/vscode/tasks.json \
		build/windows/settings.reg \
		build/wt/settings.json \
		build/zed/keymap.json \
		build/zed/settings.json
	tar -cf $@ $^

build/cargo/config.toml :
	mkdir -p build/cargo
	cp src/cargo/config.toml $@

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
	python scripts/mj.py src/vscode/tasks.yml src/vscode/tasks_win.yml.jinja \
		| yq -py -oj -I4 > $@

build/windows/settings.reg :
	mkdir -p build/windows
	python scripts/mj.py --output-encoding utf-16 src/windows/settings.reg.jinja \
		> $@

build/wsl/rootfs.tar.xz : build/wsl/cidfile
	wslc export $$(<$<) | xz -9e -T0 > $@
	wslc remove -fv $$(<$<)
	wslc rmi -f $$(<build/wsl/iidfile)
	rm build/wsl/*idfile

build/wsl/cidfile : build/wsl/iidfile
	wslc create --cidfile $@ $$(<$<)

build/wsl/iidfile : build/wsl/tombi.tar.xz
	wslc build --iidfile $@ .
	rm $<

build/wsl/tombi.tar.xz :
	mkdir -p build/wsl
	tar -cf $@ -C '$(TOMBI_CACHE_HOME)' .

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
