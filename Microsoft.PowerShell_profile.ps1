Import-Module PSReadline

Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

Set-PSReadLineOption -EditMode Emacs
Set-PSReadlineOption -BellStyle None
Set-PSReadLineOption -Colors @{ "Command"=[ConsoleColor]::DarkYellow }

# Install-Module posh-git -Scope CurrentUser
Import-Module posh-git
# Install-Module oh-my-posh -Scope CurrentUser
Import-Module oh-my-posh
Set-Theme Paradox

If (-Not (Test-Path Variable:PSise)) {  # Only run this in the console and not in the ISE
    Import-Module Get-ChildItemColor
    Set-Alias l Get-ChildItem -option AllScope
    Set-Alias ls Get-ChildItemColorFormatWide -option AllScope
	Set-Alias ll l
} Else {
	Set-Alias ll ls
	Set-Alias l ls
}

Set-Alias vi vim
Set-Alias g git

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
	Import-Module "$ChocolateyProfile"
}
