# Técnicas de Evasión de Windows Defender Implementadas

## Script: exclude_drive_evasion.vbs

Este script implementa múltiples técnicas avanzadas para evadir la detección de Windows Defender.

## 🔒 Técnicas Implementadas

### 1. **Ofuscación de Strings**
- Fragmentación de comandos críticos en arrays
- Evita detección por firmas estáticas
- Comandos construidos dinámicamente en tiempo de ejecución

### 2. **Encoding Base64 Unicode**
- Comandos PowerShell codificados en Base64 Unicode
- Usa `-EncodedCommand` para evitar análisis de strings en texto plano
- Formato requerido: UTF-16LE codificado en Base64

### 3. **Timing Aleatorio**
- Retrasos aleatorios antes y después de operaciones críticas
- Evasión de análisis heurístico temporal
- Dificulta la detección por comportamiento

### 4. **Nombres de Archivos Aleatorios**
- Generación de nombres únicos para archivos temporales
- Evita detección por nombre de archivo conocido
- Usa timestamps y números aleatorios

### 5. **Living Off The Land (LOLBins)**
- Uso de `cmstp.exe` (binario legítimo de Microsoft)
- Binario firmado digitalmente, menos sospechoso
- Explota auto-elevación sin prompt UAC visible

### 6. **Fragmentación de Comandos**
- Comandos divididos en partes almacenadas en arrays
- Reconstrucción dinámica en tiempo de ejecución
- Evita detección por patrones completos

### 7. **Limpieza Agresiva**
- Eliminación inmediata de archivos temporales
- Limpieza de variables sensibles de memoria
- Minimiza artefactos dejados en el sistema

### 8. **Ejecución Silenciosa**
- Modo oculto (`-WindowStyle Hidden`)
- Sin perfil de PowerShell (`-NoProfile`)
- Ejecución no interactiva (`-NonInteractive`)

## 📋 Estructura del Script

```
1. Inicialización con nombres aleatorios
2. Retraso inicial aleatorio
3. Verificación de binarios necesarios
4. Construcción de comandos ofuscados
5. Encoding Base64 Unicode
6. Creación de archivo .inf
7. Retraso pre-ejecución
8. Ejecución mediante cmstp.exe
9. Retraso post-ejecución
10. Verificación silenciosa
11. Limpieza de artefactos
```

## 🎯 Por qué estas técnicas funcionan

### Evasión de Firmas Estáticas
- Strings críticos no aparecen en texto plano
- Comandos fragmentados y reconstruidos dinámicamente
- Encoding Base64 oculta el contenido real

### Evasión de Análisis Dinámico
- Retrasos aleatorios dificultan el análisis temporal
- Uso de binarios legítimos reduce sospechas
- Ejecución silenciosa minimiza la superficie de ataque

### Evasión de Heurística
- Comportamiento similar a software legítimo
- Uso de herramientas del sistema operativo
- Patrones de ejecución variables

## ⚠️ Limitaciones

1. **Requiere privilegios de administrador** (aunque no se muestre el prompt)
2. **Puede ser detectado por EDR avanzados** con análisis profundo
3. **Windows Defender puede actualizar firmas** y detectar nuevas variantes
4. **Análisis de comportamiento avanzado** puede detectar patrones sospechosos

## 🔬 Métodos de Detección que Evita

- ✅ Detección por firma estática
- ✅ Análisis de strings en texto plano
- ✅ Detección por nombre de archivo
- ✅ Análisis temporal simple
- ✅ Detección por uso de herramientas sospechosas comunes

## 📚 Referencias Técnicas

- **MITRE ATT&CK**: T1088 (Bypass User Account Control)
- **Living Off The Land**: Uso de binarios legítimos del sistema
- **Base64 Encoding**: Estándar RFC 4648
- **cmstp.exe**: Connection Manager Service Profile Installer

## 🎓 Notas Educativas

Este script demuestra:
- Técnicas de ofuscación de código
- Uso de encoding para evasión
- Explotación de binarios legítimos
- Técnicas de limpieza de artefactos
- Timing y evasión temporal

## ⚖️ Uso Ético

Este código es para:
- ✅ Fines educativos
- ✅ Investigación de seguridad
- ✅ Pruebas de penetración autorizadas
- ✅ Evaluación de defensas de seguridad

**NO debe usarse para:**
- ❌ Actividades ilegales
- ❌ Comprometer sistemas sin autorización
- ❌ Bypass de seguridad en sistemas ajenos
