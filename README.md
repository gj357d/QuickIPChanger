
![App Screenshot](https://github.com/oliverbedi/QuickIPChanger/blob/main/QuickIPChanger.png?raw=true)


# Quick IP Changer

This project was created for the purpose of quickly changing the IP address.


# Important

- If the input data is not correct, the commands are not executed and no change is reflected.
- The detection of the current IP address in the StatusBar is performed every 2 seconds. This means that the command will run in the background, which can lead to a decrease in performance for devices that do not have high performance.
- "Refresh NIC" it refreshes the list of network cards and saves it to the registers
- Keyboard shortcuts can be used when the window is active
## Features

- Manual IP / DHCP switching
- Quick switching between two pre-stored IP addresses and one free one
- Saving default subnet in free one
- Saved prefered NIC
- Showing currently IP Address
- Using keyboard shortcuts
- IP /renew (from cmd)


## Shortcuts

| Keys  | Action |
| ------------- | ------------- |
| Enter  | Button Apply |
| F5  | Reload Application  |
| ESC  | Exit Application  |
| NumpadDot | Send "." (For other keyboard layouts where there is a comma in this position)

And standard Windows keyboard shortcuts using the "alt" key...
## Internal processes

Used internal commands that are executed in the background using CMD or PowerShell

```
PowerShell.exe Get-NetAdapter -Name * | Get-NetIPAddress -AddressFamily IPv4 | Select-Object InterfaceAlias

cmd.exe /k ipconfig /renew

cmd.exe /k netsh interface ip set address ...
cmd.exe /k netsh interface ipv4 set dnsservers ...
cmd.exe /k netsh interface ipv4 add dnsserver ...
```

## Saved data

All data that the application uses and stores are located in the registers.
```
HKEY_CURRENT_USER\Software\QuickIPChanger
```

## Authors

- [@oliverbedi](https://github.com/oliverbedi?tab=repositories)

When I didn't know how to proceed, I got help in the Discord group, thanks to:
 
- nou[Splash]
- https://discord.gg/autohotkey-11599302363617
