Import-Module PSReadline
Import-Module CompletionPredictor

$Env:PATH += ";$Env:GOPATH\bin"

Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

Set-PSReadLineOption -EditMode Emacs
Set-PSReadlineOption -BellStyle None
Set-PSReadLineOption -Colors @{ "Command"=[ConsoleColor]::DarkYellow }
Set-PSReadlineOption -PredictionSource HistoryAndPlugin
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

## Posh-git and oh-my-posh are replaced with powerline-go blow
# Install-Module posh-git -Scope CurrentUser
# Import-Module posh-git
# Install-Module oh-my-posh -Scope CurrentUser
# Import-Module oh-my-posh
# Set-PoshPrompt -Theme Fish

# Load powerline-go prompt
function global:prompt {
    # $pwd = $ExecutionContext.SessionState.Path.CurrentLocation
    $startInfo = New-Object System.Diagnostics.ProcessStartInfo
    $startInfo.FileName = "powerline-go"
    $startInfo.Arguments = "-shell bare -modules termtitle,exit,docker,venv,vgo,newline,host,perms,cwd,git,newline,jobs,time,root -cwd-max-depth 5 -max-width 100 -shorten-gke-names"
    $startInfo.Environment["TERM"] = "xterm-256color"
    $startInfo.CreateNoWindow = $true
    $startInfo.StandardOutputEncoding = [System.Text.Encoding]::UTF8
    $startInfo.RedirectStandardOutput = $true
    $startInfo.UseShellExecute = $false
    $startInfo.WorkingDirectory = $ExecutionContext.SessionState.Path.CurrentLocation
    $process = New-Object System.Diagnostics.Process
    $process.StartInfo = $startInfo
    $process.Start() | Out-Null
    $standardOut = $process.StandardOutput.ReadToEnd()
    $process.WaitForExit()
    $standardOut
}

If (-Not (Test-Path Variable:PSise)) {  # Only run this in the console and not in the ISE
	# Import-Module -Name Terminal-Icons # disabled as it is slow 
    # Import-Module Get-ChildItemColor
    Set-Alias l Get-ChildItem -option AllScope
    Set-Alias ls Get-ChildItemColorFormatWide -option AllScope
	Set-Alias ll l
	Set-Alias spp Split-Path
} Else {
	Set-Alias ll ls
	Set-Alias l ls
}

Set-Alias vi vim
Set-Alias g git
Set-Alias which Get-Command

# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
	Import-Module "$ChocolateyProfile"
}

# Completion for winget
Register-ArgumentCompleter -Native -CommandName winget -ScriptBlock {
	param($wordToComplete, $commandAst, $cursorPosition)
	[Console]::InputEncoding = [Console]::OutputEncoding = $OutputEncoding = [System.Text.Utf8Encoding]::new()
	$Local:word = $wordToComplete.Replace('"', '""')
	$Local:ast = $commandAst.ToString().Replace('"', '""')
	winget complete --word="$Local:word" --commandline "$Local:ast" --position $cursorPosition | ForEach-Object {
		[System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
	}
}
