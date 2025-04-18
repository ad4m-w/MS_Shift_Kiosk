if (Test-Path -Path C:\Temp){
    Clear-Host
    "Temp Folder Already Exists"
    }
   
    else{
        New-Item -Path C:\Temp -ItemType Directory
    }
   
if (Test-Path -Path C:\Visitor_Pic){
    "Visitor_Pic Folder Already Exists"
}
   
    else{
        New-Item -Path C:\Visitor_Pic -ItemType Directory
    }
    
$path=Get-Acl -Path C:\Temp
$acl=New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule ('BUILTIN\Users','FullControl','ContainerInherit, ObjectInherit','None','Allow')
$path.setaccessrule($acl)
Set-Acl -Path C:\Temp\ -AclObject $path


$path=Get-Acl -Path C:\Visitor_pic
$acl=New-Object -TypeName System.Security.AccessControl.FileSystemAccessRule ('BUILTIN\Users','FullControl','ContainerInherit, ObjectInherit','None','Allow')
$path.setaccessrule($acl)
Set-Acl -Path C:\Visitor_pic\ -AclObject $path

"Permissions for Temp and Visitor_Pics Set!"

'Enabling Rotation Lock using Registry.'
Set-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\AutoRotation -Name Enable -Value 0 -Type DWord
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\AutoRotation" /v Enable /t REG_DWORD /d 0 /f

'Disabling Notifications using Registry.'
New-Item -Path "HKCU:\Software\Policies\Microsoft\Windows" -Name "Explorer" -force
New-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer" -Name "DisableNotificationCenter" -PropertyType "DWord" -Value 1
New-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\PushNotifications" -Name "ToastEnabled" -PropertyType "DWord" -Value 0

    $regContent = @"
    Windows Registry Editor Version 5.00
    ;Disable IE11 Welcome Screen
    [HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer\Main]
    "DisableFirstRunCustomize"=dword:00000001 
"@
$tempFile = New-TemporaryFile 
$tempFile.FullName 
$regContent | Out-File -FilePath $tempFile.FullName -Encoding ASCII
reg.exe import $tempFile.FullName
Remove-Item $tempFile.FullName   

Get-PnpDevice -FriendlyName "*Microsoft Camera Rear*" | Disable-PnpDevice -Confirm:$false
'Rear Camera Disabled.'

Powercfg /Change monitor-timeout-ac 0
Powercfg /Change monitor-timeout-dc 0
Powercfg /Change standby-timeout-ac 0
Powercfg /Change standby-timeout-dc 0
'Power plan settings changed.'