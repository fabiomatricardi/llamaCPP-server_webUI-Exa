## Enable polilcies on Powershell
```Powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```
## Best practice files
create then proper files

1. `HELP.md`
2. `INSTRUCTIONS.md`
3. `PREPARATIONS.md` this file, optional
4. `README.md` keep track of the Repository
5. `HOWTO.md` alternative to instructions. list the custom commands of the project


### get structure bat
```bat
ni HELP.md -ItemType File
ni INSTRUCTIONS.md -ItemType File
ni README.md -ItemType File
ni HOWTO.md -ItemType File
```


### Install powershell modules
```Powershell
Install-Module -Name Microsoft.PowerShell.PSResourceGet -Repository PSGallery -Scope CurrentUser -Force

Install-PSResource -Name Microsoft.PowerShell.PlatyPS


```