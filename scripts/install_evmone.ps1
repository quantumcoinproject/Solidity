$ErrorActionPreference = "Stop"

# Needed for Invoke-WebRequest to work via CI.
$progressPreference = "silentlyContinue"

Invoke-WebRequest -URI "https://github.com/ethereum/evmone/releases/download/v0.5.0/evmone-0.5.0-windows-amd64.zip" -OutFile "evmone.zip"
tar -xf evmone.zip "bin/evmone.dll"

$path = "deps"
If(!(test-path -PathType container $path))
{
  New-Item -ItemType Directory -Path $path
}

mv bin/evmone.dll deps
