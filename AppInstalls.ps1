     $ProgressPreference = 'SilentlyContinue'
     'Parsing download site...'

     # Retrieve the HTML content of the website
     $response = Invoke-WebRequest -Uri "https://download.msshift.com/link/5da99203-21ba-4aa2-93e6-a60a8a0b3ae3"
     # Extract the text content from the parsed HTML
     $text = $response.ParsedHtml.body.innerText
 
     'Downloading...'

     $Destination = "C:\Temp\adobe.exe" 
     Invoke-WebRequest -Uri $text -OutFile $Destination

     "Launching Adobe with silent installer params..."
     Start-Process -FilePath "C:\Temp\adobe.exe" -ArgumentList "/sPB"
     "Success!"

     'Parsing download site...'
     # Download HF driver
     # Retrieve the HTML content of the website
     $response = Invoke-WebRequest -Uri "https://download.msshift.com/link/c862d6fc-fc72-4e77-8347-ab079c8d4fa3"
     # Extract the text content from the parsed HTML
     $text = $response.ParsedHtml.body.innerText
     'Downloading driver...'

     $Destination = "C:\Temp\Zebra_CoreScanner_Driver.exe" 
     Invoke-WebRequest -Uri $text -OutFile $Destination

    $Destination = [System.IO.Path]::Combine([System.Environment]::GetFolderPath('MyDocuments'), 'Kiosk Configs.pdf')
    $response = Invoke-WebRequest -Uri "https://download.msshift.com/link/0958c824-3f1e-42b3-89d1-c29a88efe9c2"
    $text = $response.ParsedHtml.body.innerText
    Invoke-WebRequest -Uri $text -OutFile $Destination
    'Kiosk Scanner Config PDF saved in Documents Folder...'


$issContent = @"
[{C96D0CF9-799F-4332-81FF-130C0F58AB0C}-DlgOrder]
Dlg0={C96D0CF9-799F-4332-81FF-130C0F58AB0C}-SdWelcome-0
Count=4
Dlg1={C96D0CF9-799F-4332-81FF-130C0F58AB0C}-SetupType2-0
Dlg2={C96D0CF9-799F-4332-81FF-130C0F58AB0C}-SdStartCopy2-0
Dlg3={C96D0CF9-799F-4332-81FF-130C0F58AB0C}-SdFinish-0
[{C96D0CF9-799F-4332-81FF-130C0F58AB0C}-SdWelcome-0]
Result=1
[{C96D0CF9-799F-4332-81FF-130C0F58AB0C}-SetupType2-0]
Result=304
[{C96D0CF9-799F-4332-81FF-130C0F58AB0C}-SdStartCopy2-0]
Result=1
[{C96D0CF9-799F-4332-81FF-130C0F58AB0C}-SdFinish-0]
Result=1
bOpt1=0
bOpt2=0
"@

    $issFilePath = "C:\Temp\custom.iss"
    $issContent | Out-File -FilePath $issFilePath -Encoding ascii
    "iss Config File created in Temp folder..."

     'Giving 180 seconds for processes to catch up...'
     Start-Sleep -Seconds 180

     "Launching Hands Free Scanner with silent installer params..."

	# Define the path to the executable and the parameters
	$exePath = "C:\Temp\Zebra_CoreScanner_Driver.exe"   
	$issFilePath = "C:\Temp\custom.iss"

	# Launch the CMD and run the zebra.exe with the specified arguments
	Start-Process "cmd.exe" -ArgumentList "/c", "$exePath -s -f1`"$issFilePath`""

	Write-Host "CMD launched with Zebra Installer and arguments."
    "Success!"

    'Parsing download site...'

    # Retrieve the HTML content of the website
    $response = Invoke-WebRequest -Uri "https://download.msshift.com/link/1ab37806-4228-4eb1-8178-1ba492b0ea0f"
    # Extract the text content from the parsed HTML
    $text = $response.ParsedHtml.body.innerText

    'Downloading...'

    $Destination = "C:\Temp\DCDSetup1.4.5.1.exe" 
    Invoke-WebRequest -Uri $text -OutFile $Destination

    "Launching DYMO 550 driver with silent installer params..."
    Start-Process -FilePath "C:\Temp\DCDSetup1.4.5.1.exe" -ArgumentList "/S", "/v/qn"
    "Success!"

    'Parsing download site for Kiosk App...'
            
    # Retrieve the HTML content of the website
    $response = Invoke-WebRequest -Uri "https://download.msshift.com/link/6ffe0dbd-c7cd-4206-a960-b2231fd4bd34"
    # Extract the text content from the parsed HTML
    $text = $response.ParsedHtml.body.innerText

    'Downloading...'
       
    $Destination = "C:\Temp\kiosk.zip"
    Invoke-WebRequest -Uri $text -OutFile $Destination
    Write-Host 'Uncompressing...'
    Expand-Archive -LiteralPath $Destination -DestinationPath "C:\"

    'Parsing download site for Kiosk.ico...'
            
    # Retrieve the HTML content of the website
    $response = Invoke-WebRequest -Uri "https://download.msshift.com/link/c55f283e-e94a-4a21-8b04-4b6cd16574b2"
    # Extract the text content from the parsed HTML
    $text = $response.ParsedHtml.body.innerText

    'Downloading...'

    $Destination = "C:\kiosk.ico"
    Invoke-WebRequest -Uri $text -OutFile $Destination
    Write-Host 'Adding Kiosk Shortcut to Desktop'
    $TargetFile = "C:\v2.4_14vp\ms.Visitors.Kiosk.exe"
    $ShortcutFile = "$env:USERPROFILE\Desktop\MS Shift Kiosk.lnk"
    if (-Not (Test-Path $TargetFile)) {
        Write-Host "Error: Target file does not exist at $TargetFile"
        return
    }
    $desktopPath = [System.Environment]::GetFolderPath('Desktop')
    if (-Not (Test-Path $desktopPath)) {
        Write-Host "Error: Desktop directory does not exist."
        return
    }

    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut($ShortcutFile)
    $Shortcut.TargetPath = $TargetFile
    $Shortcut.IconLocation = "C:\kiosk.ico"
    $Shortcut.Save()
    Write-Host "Shortcut created at $ShortcutFile"


    $shortcutPath = "$env:USERPROFILE\Desktop\MS Shift Kiosk.lnk"
    $startupPath = [Environment]::GetFolderPath("Startup")
    Copy-Item $shortcutPath -Destination $startupPath
    Write-Host 'Added kiosk app to Startup folder.'

    'Parsing download site for Teamviewer Setup...'
            
    # Retrieve the HTML content of the website
    $response = Invoke-WebRequest -Uri "https://download.msshift.com/link/50a71d63-6535-4343-88dc-f6870af278e2"
    # Extract the text content from the parsed HTML
    $text = $response.ParsedHtml.body.innerText

    'Downloading...'

    $Destination = "C:\Temp\Teamviewer.exe"
    Invoke-WebRequest -Uri $text -OutFile $Destination
    "Launching Teamviewer installer..."
    Start-Process -FilePath "C:\Temp\Teamviewer.exe"
    "Success!"