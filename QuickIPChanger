#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

;_____________________________________________________________________________________
; Setup
RegRead, REma, HKEY_CURRENT_USER\Software\QuickIPChanger\Empty, Mask, 
RegRead, RCheckEma, HKEY_CURRENT_USER\Software\QuickIPChanger\Empty, Save,

RegRead, RP1ip, HKEY_CURRENT_USER\Software\QuickIPChanger\Preset1, IP,
RegRead, RP1ma, HKEY_CURRENT_USER\Software\QuickIPChanger\Preset1, Mask,
RegRead, RP1gw, HKEY_CURRENT_USER\Software\QuickIPChanger\Preset1, Gateway, 
RegRead, RP1d1, HKEY_CURRENT_USER\Software\QuickIPChanger\Preset1, Primary, 
RegRead, RP1d2, HKEY_CURRENT_USER\Software\QuickIPChanger\Preset1, Secondary, 

RegRead, RP2ip, HKEY_CURRENT_USER\Software\QuickIPChanger\Preset2, IP, 
RegRead, RP2ma, HKEY_CURRENT_USER\Software\QuickIPChanger\Preset2, Mask, 
RegRead, RP2gw, HKEY_CURRENT_USER\Software\QuickIPChanger\Preset2, Gateway, 
RegRead, RP2d1, HKEY_CURRENT_USER\Software\QuickIPChanger\Preset2, Primary, 
RegRead, RP2d2, HKEY_CURRENT_USER\Software\QuickIPChanger\Preset2, Secondary, 




RegRead, RNIC_Interf, HKEY_CURRENT_USER\Software\QuickIPChanger\NIC, Interfaces
If (RNIC_Interf = ""){
    RunWait PowerShell.exe Get-NetAdapter -Name * | Get-NetIPAddress -AddressFamily IPv4 | Select-Object InterfaceAlias | clip,,hide
    str = %clipboard%
;-------------------- Start of part -- Great thanks! -- nou [Splash] nou#5251 -- from the Discord --------------------
    data := strSplit(str, "`n", "`r")

    str := ""
    for k, v in data
    {
    ; ignores the first two line:
    if (A_index <= 3)
        continue

    ; build up your list of interfaces
    str .= Trim(v)

    ; append them with "|"
    if !(A_Index = data.count())
        str .= "|"
}
    StringTrimRight, RNIC_Interf, str, 3
;-------------------- End of part -- Great thanks! -- nou [Splash] nou#5251 -- from the Discord --------------------
    RegWrite REG_SZ, HKEY_CURRENT_USER\Software\QuickIPChanger\NIC, Interfaces, %RNIC_Interf%

    FileDelete, nic.txt
} else {
    RegRead, RNIC_Interf, HKEY_CURRENT_USER\Software\QuickIPChanger\NIC, Interfaces
    RegRead, RNIC_InterfPair, HKEY_CURRENT_USER\Software\QuickIPChanger\NIC, InterfacesPair
}

RegRead, RCheckNIC_Save, HKEY_CURRENT_USER\Software\QuickIPChanger\NIC, Save,
RegRead, RNIC, HKEY_CURRENT_USER\Software\QuickIPChanger\NIC, NIC
If (RNIC = 1 || RNIC = ""){
    NIC = 1
} else {
    NIC = %RNIC%
}




;_____________________________________________________________________________________
; GUI
Gui Show, w330 h385, Quick IP Changer



; NIC Group
Gui Add, GroupBox, x170 y0 w155 h75, NIC

Gui Add, DropDownList, vEthN x180 y20 w135, %RNIC_Interf%
GuiControl, Choose, EthN, %NIC%
Gui Add, Button, x235 y45 w80 h23, Refresh &NIC

; CheckBox
If (RCheckNIC_Save = 1 || RCheckNIC_Save = ""){
    symbol_nic = +
} else {
    symbol_nic = -
}

Gui Add, Checkbox, vCheckNIC x180 y50 w45 %symbol_nic%checked, Save


; Manual IP Group
Gui Add, Radio, vEmpty x13 y10 w120 h23 +Checked, &Empty
Gui Add, Radio, vPreset1 x13 y175 w120 h23, P&reset 1
Gui Add, Radio, vPreset2 x178 y175 w120 h23, Prese&t 2

; DHCP Manual Group
Gui Add, GroupBox, x170 y80 w155 h55, DHCP / Manual IP
Gui Add, Radio, vDHCP gSelect x180 y100 w65 h23, &DHCP
Gui Add, Radio, vManualIP gSelect x245 y100 w70 h23 +Checked, M&anual IP



; Empty group
Gui Add, GroupBox, x5 y0 w155 h165,
Gui Add, Text, x13 y40 w35 h21, IP
Gui Add, Edit, vEip x50 y37 w100 h21,
Gui Add, Text, x13 y65 w35 h21, MASK
Gui Add, Edit, vEma x50 y62 w100 h21, %REma%
Gui Add, Text, x13 y90 w35 h21, GW
Gui Add, Edit, vEgw x50 y87 w100 h21,
Gui Add, Text, x13 y110 w142 h2 +0x10
Gui Add, Text, x13 y115 w35 h21, DNS 1
Gui Add, Edit, vEd1 x50 y113 w100 h21,
Gui Add, Text, x13 y140 w35 h21, DNS 2
Gui Add, Edit, vEd2 x50 y137 w100 h21,
GuiControl, Focus, Eip

; Preset 1
Gui Add, GroupBox, x5 y165 w155 h165, ; Preset 1
Gui Add, Text, x13 y205 w35 h21, IP
Gui Add, Edit, vP1ip x50 y202 w100 h21, %RP1ip%
Gui Add, Text, x13 y230 w35 h21, MASK
Gui Add, Edit, vP1ma x50 y227 w100 h21, %RP1ma%
Gui Add, Text, x13 y255 w35 h21, GW
Gui Add, Edit, vP1gw x50 y252 w100 h21, %RP1gw%
Gui Add, Text, x13 y275 w142 h2 +0x10
Gui Add, Text, x13 y280 w35 h21, DNS 1
Gui Add, Edit, vP1d1 x50 y277 w100 h21, %RP1d1%
Gui Add, Text, x13 y305 w35 h21, DNS 2
Gui Add, Edit, vP1d2 x50 y302 w100 h21, %RP1d2%


; Preset 2
Gui Add, GroupBox, x170 y165 w155 h165, ; Preset 2
Gui Add, Text, x178 y205 w35 h21, IP
Gui Add, Edit, vP2ip x215 y202 w100 h21, %RP2ip%
Gui Add, Text, x178 y230 w35 h21, MASK
Gui Add, Edit, vP2ma x215 y227 w100 h21, %RP2ma%
Gui Add, Text, x178 y255 w35 h21, GW
Gui Add, Edit, vP2gw x215 y252 w100 h21, %RP2gw%
Gui Add, Text, x178 y275 w142 h2 +0x10
Gui Add, Text, x178 y280 w35 h21, DNS 1
Gui Add, Edit, vP2d1 x215 y277 w100 h21, %RP2d1%
Gui Add, Text, x178 y305 w35 h21, DNS 2
Gui Add, Edit, vP2d2 x215 y302 w100 h21, %RP2d2%



; Buttons
Gui Add, Button, x5 y335 w80 h23, IP Rene&w
Gui Add, Button, x85 y335 w80 h23, &Save
Gui Add, Button, x165 y335 w80 h23, &OK
Gui Add, Button, x245 y335 w80 h23, Appl&y


; CheckBox
If (RCheckEma = 0){
    symbol_save = -
} else {
    symbol_save = +
}
Gui Add, Checkbox, vCheckEma x170 y145 %symbol_save%checked, Save subnet for "Empty" 


; Show IP
Gui, Add, StatusBar, vStatus,

SetTimer, UpdateOSD, 2000 
Gosub, UpdateOSD 
return 

UpdateOSD:
    GuiControlGet, EthN

    str := % GetIPByAdapter(EthN)

    GetIPByAdapter(adapterName) {
    objWMIService := ComObjGet("winmgmts:{impersonationLevel = impersonate}!\\.\root\cimv2")
    colItems := objWMIService.ExecQuery("SELECT * FROM Win32_NetworkAdapter WHERE NetConnectionID = '" adapterName "'")._NewEnum, colItems[objItem]
    colItems := objWMIService.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration WHERE InterfaceIndex = '" objItem.InterfaceIndex "'")._NewEnum, colItems[objItem]
    Return objItem.IPAddress[0]
}

    GuiControl,, Status, Current IP address %str%
    
return 



;_____________________________________________________________________________________
; Control
Select:
GuiControlGet, DHCP
If (DHCP = 1){
    GuiControl, Disable, Empty
    GuiControl, Disable, Preset1
    GuiControl, Disable, Preset2
;    GuiControl, Disable, Eip
;    GuiControl, Disable, Ema
;    GuiControl, Disable, Egw
;    GuiControl, Disable, Ed1
;    GuiControl, Disable, Ed2
} Else {
    GuiControl, Enable, Empty
    GuiControl, Enable, Preset1
    GuiControl, Enable, Preset2
;    GuiControl, Enable, Eip
;    GuiControl, Enable, Ema
;    GuiControl, Enable, Egw
;    GuiControl, Enable, Ed1
;    GuiControl, Enable, Ed2
}
Return


ButtonRefreshNIC:
    RegDelete, HKEY_CURRENT_USER\Software\QuickIPChanger\NIC, Interfaces
    RegDelete, HKEY_CURRENT_USER\Software\QuickIPChanger\NIC, NIC
    Reload
Return



ButtonSave:
    Gosub, GetDataGuiControlGet


    If (CheckEma = 0)
        Ema =
    RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\QuickIPChanger\Empty, Mask, %Ema%
    RegWrite, REG_DWORD, HKEY_CURRENT_USER\Software\QuickIPChanger\Empty, Save, %CheckEma%

    RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\QuickIPChanger\Preset1, IP, %P1ip%
    RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\QuickIPChanger\Preset1, Mask, %P1ma%
    RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\QuickIPChanger\Preset1, Gateway, %P1gw%
    RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\QuickIPChanger\Preset1, Primary, %P1d1%
    RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\QuickIPChanger\Preset1, Secondary, %P1d2%

    RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\QuickIPChanger\Preset2, IP, %P2ip%
    RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\QuickIPChanger\Preset2, Mask, %P2ma%
    RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\QuickIPChanger\Preset2, Gateway, %P2gw%
    RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\QuickIPChanger\Preset2, Primary, %P2d1%
    RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\QuickIPChanger\Preset2, Secondary, %P2d2%

    If (CheckNIC = 0){
        RegWrite, REG_DWORD, HKEY_CURRENT_USER\Software\QuickIPChanger\NIC, Save, %CheckNIC%
        RegDelete, HKEY_CURRENT_USER\Software\QuickIPChanger\NIC, NIC,
    } Else {
        RegWrite, REG_DWORD, HKEY_CURRENT_USER\Software\QuickIPChanger\NIC, Save, %CheckNIC%
        RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\QuickIPChanger\NIC, NIC, % EthN
    }
Return



ButtonIPRenew:
    Run, *RunAs cmd.exe /k ipconfig /renew %EthN%,, Hide
Return

ButtonOK:
    Gosub, ButtonApply
    ExitApp
Return


ButtonApply:
    Gosub, GetDataGuiControlGet

    If (DHCP = 1){
        Run, *RunAs cmd.exe /k netsh interface ip set address %EthN% dhcp,, Hide
        Run, *RunAs cmd.exe /k netsh interface ip set dnsservers name=%EthN% source=dhcp,, Hide
    } if else (ManualIP = 1){
        if (Empty = 1){
            Run, *RunAs cmd.exe /k netsh interface ipv4 set address name=%EthN% source=static addr=%Eip% mask=%Ema% gateway=%Egw% 1,, Hide
	        Run, *RunAs cmd.exe /k netsh interface ipv4 set dnsservers name=%EthN% static %Ed1%,, Hide
	        Run, *RunAs cmd.exe /k netsh interface ipv4 add dnsserver name=%EthN% address=%Ed2% index=2,, Hide
        }
        if else (Preset1 = 1){
            Run, *RunAs cmd.exe /k netsh interface ip set address name=%EthN% source=static addr=%P1ip% mask=%P1ma% gateway=%P1gw% 1,, Hide
	        Run, *RunAs cmd.exe /k netsh interface ipv4 set dnsservers name=%EthN% static %P1d1%,, Hide
	        Run, *RunAs cmd.exe /k netsh interface ipv4 add dnsserver name=%EthN% address=%P1d2% index=2,, Hide
        }
        if else (Preset2 = 1){
            Run, *RunAs cmd.exe /k netsh interface ip set address name=%EthN% source=static addr=%P2ip% mask=%P2ma% gateway=%P2gw% 1,, Hide
	        Run, *RunAs cmd.exe /k netsh interface ipv4 set dnsservers name=%EthN% static %P2d1%,, Hide
	        Run, *RunAs cmd.exe /k netsh interface ipv4 add dnsserver name=%EthN% address=%P2d2% index=2,, Hide        
        }
    }
Return    


ButtonOpenRegEdit:
    Run, Regedit.exe
Return


ButtonClearRegistry:
    RegDelete, HKEY_CURRENT_USER\Software\QuickIPChanger,,
Return


ButtonSavethePairing:
    Gosub, GetDataGuiControlGet
    RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\QuickIPChanger\Config, PairNIC1, %PairNIC1%
    RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\QuickIPChanger\Config, PairNIC2, %PairNIC2%
    RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\QuickIPChanger\Config, PairNIC3, %PairNIC3%
    RegWrite, REG_SZ, HKEY_CURRENT_USER\Software\QuickIPChanger\Config, PairNIC4, %PairNIC4%

;_____________________________________________________________________________________
; Called SUB
GetDataGuiControlGet:
GuiControlGet, DHCP
GuiControlGet, ManualIP
GuiControlGet, Empty
GuiControlGet, CheckEma
GuiControlGet, EthN
GuiControlGet, Eip
GuiControlGet, Ema
GuiControlGet, Egw
GuiControlGet, Ed1
GuiControlGet, Ed2
GuiControlGet, Preset1
GuiControlGet, P1ip
GuiControlGet, P1ma
GuiControlGet, P1gw
GuiControlGet, P1d1
GuiControlGet, P1d2
GuiControlGet, Preset2
GuiControlGet, P2ip
GuiControlGet, P2ma
GuiControlGet, P2gw
GuiControlGet, P2d1
GuiControlGet, P2d2
GuiControlGet, CheckNIC
GuiControlGet, PairNIC1
GuiControlGet, PairNIC2
GuiControlGet, PairNIC3
GuiControlGet, PairNIC4
Return

;_____________________________________________________________________________________
; Shortcuts

#IfWinActive, Quick IP Changer

NumpadDot::
Send, .
Return

~Enter::
Gosub, ButtonApply
Return

~NumpadEnter::
Gosub, ButtonApply
Return

~F5::
Reload
Return

GuiClose:
ExitApp

esc::
ExitApp

#IfWinActive
