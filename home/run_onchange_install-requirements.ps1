function Assert-Command($name) {
    if (-not (Get-Command $name -ErrorAction SilentlyContinue)) {
        throw "${name}: not found"
    }
}

function Test-PipxPackageInstalled {
    param(
        [Parameter(Mandatory)]
        [string]$PackageName
    )

    pipx list --json | jq -e --arg package $PackageName '.venvs | has($package)' > $null
    return $LASTEXITCODE -eq 0
}

Assert-Command pipx
Assert-Command jq

if (Test-PipxPackageInstalled "dotfiles-pyutils") {
    Write-Host "pyutils already installed thru pipx! :)"
} else {
    Push-Location "$env:CHEZMOI_WORKING_TREE/pyutils"
    pipx install -e .
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to install pyutils thru pipx :("
    }
    Pop-Location
}

if (Test-PipxPackageInstalled "xonsh") {
    Write-Host "xonsh already installed thru pipx! :)"
} else {
    pipx install xonsh
    if ($LASTEXITCODE -ne 0) {
        throw "Failed to install pyutils thru pipx :("
    }
}
