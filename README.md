# About
This repository contains utility powershell and bash scripts which can help in automating and
optimizing daily cumbersome, repeatitive and tedious tasks to achieve higher efficiency and
productivity.

## Scripts
### Powershell

#### open.ps1
---
##### Introduction

The `open.ps1` script is a PowerShell script that opens a file based on a trigger word. The script takes two arguments: a trigger word and an optional flag. The trigger word is used to look up a file path in a predefined dictionary. If the trigger word is found, the script opens the file. If the optional flag is `-vs`, the file is opened in Visual Studio Code. If no flag is provided, the file is opened with the default program associated with the file type.

##### Syntax

The syntax for running the script is as follows:
```powershell
open.ps1 <trigger_word> [-vs]
```
Where:
- `<TriggerWord>` is a placeholder for the trigger word associated with the file you want to open.
- `[-vs]` is an optional flag that, if provided, will open the file in Visual Studio Code.

##### How to Use

Follow these steps to use the `open.ps1` script:

1. **Installation**: No installation is required. Just ensure you have PowerShell installed on your Windows machine.

2. **Configuration**: Before you can use the script, you need to configure the trigger words and associated file paths. Open the `open.ps1` script in a text editor and locate the `$filePaths` dictionary. Uncomment the lines and replace `[TriggerWord1]`, `[TriggerWord2]`, etc. with your desired trigger words, and replace `[FilePath1]`, `[FilePath2]`, etc. with the full paths to the files you want to open with those trigger words.

3. **Execution**: To run the script, open a PowerShell terminal and navigate to the directory containing the `open.ps1` script. Use the following command to run the script:

    ```
    .\open.ps1 YourTriggerWord
    ```

    Replace `YourTriggerWord` with one of the trigger words you defined in the `$filePaths` dictionary. This will open the associated file with the default program for that file type.

    If you want to open the file in Visual Studio Code, use the `-vs` flag:

    ```
    .\open.ps1 YourTriggerWord -vs
    ```

    This will open the associated file in Visual Studio Code.

Please note that the script will terminate itself (`Stop-Process -Id $pid`) after opening the file. If the trigger word is not found in the `$filePaths` dictionary, or if an invalid flag is provided, the script will output an error message.