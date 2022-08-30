# Initial setup

Install Powershell, launch it with `pwsh` and configure it:

```powershell
cd (Split-Path (Split-Path $profile))
git clone git@github.com:orobardet/posh-config.git powershell
cd powershell

Set-PSRepository -Name "PSGallery" -InstallationPolicy Trusted
Install-Module -Name PSReadLine -Repository PSGallery -Force
Install-Module -Name CompletionPredictor -Repository PSGallery
Install-Module Get-ChildItemColor
```

Exit Powershell and launch it again.
