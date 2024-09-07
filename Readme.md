# AutoRecover MOF Recompiler

This script is designed to recompile MOF (Managed Object Format) files located in the `AutoRecover` directory of the Windows Management Instrumentation (WMI) service. It first checks the syntax of the MOF files and then recompiles them to ensure proper recovery during system operations. The script excludes any MOF files related to uninstallation.

## Purpose

The purpose of this script is to:
1. Identify `.mof` and `.mfl` files in the AutoRecover path of the WMI repository.
2. Check the syntax of the MOF files to ensure they are error-free.
3. Recompile the MOF files with the `mofcomp.exe` utility, using the `-autorecover` flag.

## How It Works

1. **Set the AutoRecover Path:**
   The script sets the path to the `AutoRecover` directory within the WMI repository.
   
   ```powershell
   $AutoRecoverPath = "$env:windir\System32\wbem\AutoRecover\"
   ```

2. **Get AutoRecover MOFs:**
   The script retrieves all `.mof` and `.mfl` files within the `AutoRecover` directory, excluding any files that contain the word "uninstall" in their name.

   ```powershell
   $GetAutoRecoverMOFS = Get-ChildItem -Path $AutoRecoverPath | Where-Object { ($_.Extension -in ".mof", ".mfl") -and ($_.Name -notlike "*uninstall*") } | Sort-Object -Property Name
   ```

3. **Check MOF Syntax:**
   Each MOF file is checked for syntax correctness using the `-check` flag of the `mofcomp.exe` utility.

   ```powershell
   foreach ($file in $GetAutoRecoverMOFS) {
       C:\Windows\System32\wbem\mofcomp.exe -check $FilePath
   }
   ```

4. **Recompile MOF Files:**
   After syntax verification, the script recompiles each MOF file using the `-autorecover` flag.

   ```powershell
   foreach ($file in $GetAutoRecoverMOFS) {
       C:\Windows\System32\wbem\mofcomp.exe -autorecover $FilePath
   }
   ```

## Usage

1. **Run the script with PowerShell**:  
   Open PowerShell as an administrator and execute the script. Make sure you have the required permissions to access and modify files in the WMI repository.

2. **Verify Execution**:  
   The script will output the progress as it checks and recompiles each MOF file. Errors or issues with MOF files will be displayed during the execution.

## Requirements

- **Windows Operating System**: The script must be run on a Windows machine.
- **Administrative Privileges**: Running the script requires elevated permissions.
- **PowerShell**: Ensure that PowerShell is available and that the execution policy allows the script to run.

## Example Output

```text
Getting AutoRecover MOFs to recompile.
Checking syntax of MOFS in C:\Windows\System32\wbem\AutoRecover
Recompiling example.mof. 1 of 3.
Recompiling example2.mof. 2 of 3.
Recompiling example3.mof. 3 of 3.
```

## Disclaimer

Ensure you understand the purpose of the MOF files being recompiled. Improper changes to MOF files can cause issues with WMI services. Always back up important files and configurations before running the script.
