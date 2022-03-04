<p align="left">
  <a href="https://github.com/vdarkobar/Home-Cloud/blob/main/shared/ProxMoxHowTo.md#windows-guest-on-proxmox">Back</a>
</p>  

## Upgrade Windows Server 2016/2019 Eval to Full

*Windows Server 2016 Evaluation/Windows Server 2019 Free Trial*

Verify if you are using Windows Server Evaluation edition and get the list of \
Windows Server editions to which you can upgrade your current Eval edition:
```
DISM /online /Get-CurrentEdition
DISM /online /Get-TargetEditions
```
Display the grace period expiration date:
```
slmgr /dli
```
Extend Windows Server Evaluation period by 180 days (up to 5 times):
```
slmgr /rearm
```
  
To convert Windows Server XXXX EVAL to a full edition, <a href="https://docs.microsoft.com/en-us/windows-server/get-started/kmsclientkeys"> you need to use the GVLK (KMS) keys for Windows.</a>
You can upgrade Windows Server 2019 edition the same way.

```
        OS Edition	                        GVLK Key
Windows Server 2022 Datacenter:       WX4NM-KYWYW-QJJR4-XV3QB-6VM33
Windows Server 2022 Standard:         VDYBN-27WPP-V4HQT-9VMD4-VMK7H

Windows Server 2019 Datacenter:       WMDGN-G9PQG-XVVXX-R3X43-63DFG
Windows Server 2019 Standard:         N69G4-B89J2-4G8F4-WWYCC-J464C
Windows Server 2019 Essentials:       WVDHN-86M7X-466P6-VHXV7-YY726
```
  
### Convert Windows Server 2019 Evaluation to Windows Server 2019 Standard:
```
dism /online /set-edition:ServerStandard /productkey:N69G4-B89J2-4G8F4-WWYCC-J464C /accepteula
```
### Convert Windows Server 2019 Evaluation to Windows Server 2019 Datacenter edition:
```
dism /online /set-edition:ServerDatacenter /productkey:WMDGN-G9PQG-XVVXX-R3X43-63DFG /accepteula
```
  
## Windows 10/11
  
<a href="https://www.microsoft.com/en-us/software-download/windows10"> Download the latest version of Windows 10 Media Creation Tool.</a>  
<a href="https://www.microsoft.com/en-us/software-download/windows11"> Download the latest version of Windows 10 Media Creation Tool.</a>  
  
<a href="https://docs.microsoft.com/en-us/windows-server/get-started/kmsclientkeys"> Use a GVLK (KMS) key to proceed and build the ISO.</a>  
  
Open Command Prompt or PowerShell in your Downloads folder. Adjust for the name of the downloaded file and run: 
```
.\MediaCreationTool21H1.exe /Eula Accept /Retail /MediaArch x64 /MediaLangCode en-US /MediaEdition EnterpriseN
```
  
### *Download <a href="https://github.com/vdarkobar/Home-Cloud/blob/main/shared/MAS-1-4.rar?raw=true"> 1.4.zip </a>*.
