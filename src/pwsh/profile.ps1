$ErrorActionPreference = 'Stop'

$Env:PIXI_BUILD_BACKEND_OVERRIDE_ALL = '1'
$Env:UV_HTTP_TIMEOUT = '300'

function c {
    Clear-History
    [Microsoft.PowerShell.PSConsoleReadLine]::ClearHistory()
    if ($PSVersionTable.PSVersion.Major -ge 6) {
        [Console]::Write("`ec")
    }
    Remove-Item -ErrorAction Ignore (Get-PSReadlineOption).HistorySavePath
}

function q {
    Remove-Item -ErrorAction Ignore (Get-PSReadlineOption).HistorySavePath
    exit
}

function t {
    begin {
        $t = (Get-Date).Date
    }
    process {
        $_.CreationTime = $_.LastAccessTime = $_.LastWriteTime = $t
    }
}
