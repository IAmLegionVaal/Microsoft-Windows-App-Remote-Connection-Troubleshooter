# Microsoft Windows App Remote Connection Troubleshooter

Created by **Dewald Pretorius**.

The repository includes the original connection, authentication, workspace, feed, gateway, and session diagnostics plus a guarded `Repair.ps1` helper.

Supported actions are `Diagnose`, `ResetClientCache`, and `FlushDns`.

```powershell
.\Repair.ps1 -Action Diagnose
.\Repair.ps1 -Action ResetClientCache -WhatIf
.\Repair.ps1 -Action ResetClientCache -Confirm
```

Close Windows App and Remote Desktop clients before cache repair. Existing cache data is preserved as a timestamped backup. Source-reviewed for PowerShell 5.1; not runtime-tested against every remote workspace or Windows build.
