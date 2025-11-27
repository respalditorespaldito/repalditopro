# Script de Exclusión de Windows Defender usando cmstp.exe

## Descripción
Este script utiliza `cmstp.exe` (Connection Manager Service Profile) para lograr autoelevación de privilegios sin mostrar el prompt de UAC, implementando una técnica conocida de UAC Bypass.

## Archivos

### exclude_drive_cmstp.vbs
Versión básica del script que implementa el método de autoelevación usando cmstp.exe.

### exclude_drive_cmstp_advanced.vbs
Versión avanzada con:
- Sistema de logging
- Mejor manejo de errores
- Limpieza automática de archivos temporales
- Verificación mejorada de resultados

## Cómo funciona el método cmstp.exe

1. **cmstp.exe** es un binario firmado por Microsoft que está en la lista de auto-elevación de Windows
2. El script crea un archivo `.inf` temporal con comandos a ejecutar
3. Cuando `cmstp.exe` procesa el archivo `.inf`, ejecuta los comandos especificados en `[RunPreSetupCommandsSection]` con privilegios elevados
4. El archivo `.inf` contiene comandos PowerShell que agregan la exclusión a Windows Defender
5. Después de la ejecución, el script limpia los archivos temporales

## Ventajas del método cmstp.exe

- ✅ No muestra prompt de UAC visible al usuario
- ✅ Usa un binario legítimo de Microsoft (firmado)
- ✅ Funciona en sistemas Windows modernos
- ✅ Más silencioso que otros métodos

## Limitaciones

- ⚠️ Requiere que el usuario tenga privilegios de administrador (aunque no se muestre el prompt)
- ⚠️ Puede ser detectado por algunos antivirus
- ⚠️ El archivo `.inf` se crea temporalmente en el sistema

## Uso

1. Ejecutar el script como usuario con privilegios de administrador:
   ```
   wscript exclude_drive_cmstp.vbs
   ```

2. El script automáticamente:
   - Crea el archivo `.inf` temporal
   - Ejecuta `cmstp.exe` con privilegios elevados
   - Agrega la exclusión `C:\` a Windows Defender
   - Limpia los archivos temporales

## Verificación

Para verificar que la exclusión se agregó correctamente:
```powershell
Get-MpPreference | Select-Object -ExpandProperty ExclusionPath
```

## Notas Educativas

Este script es para fines educativos y demuestra:
- Técnicas de bypass de UAC
- Uso de binarios legítimos para elevación de privilegios
- Manipulación de archivos de configuración (.inf)
- Integración de PowerShell en scripts VBScript

## Referencias

- cmstp.exe es parte de Windows Connection Manager
- El método explota la auto-elevación de cmstp.exe
- Documentado en MITRE ATT&CK como técnica de bypass de UAC
