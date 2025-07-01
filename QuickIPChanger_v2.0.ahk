#SingleInstance Force
SendMode "Input"
SetWorkingDir A_ScriptDir

;_____________________________________________________________________________________
; Setup
REma := RegRead("HKEY_CURRENT_USER\Software\QuickIPChanger\Empty", "Mask", "")
RCheckEma := RegRead("HKEY_CURRENT_USER\Software\QuickIPChanger\Empty", "Save", "")

RP1ip := RegRead("HKEY_CURRENT_USER\Software\QuickIPChanger\Preset1", "IP", "")
RP1ma := RegRead("HKEY_CURRENT_USER\Software\QuickIPChanger\Preset1", "Mask", "")
RP1gw := RegRead("HKEY_CURRENT_USER\Software\QuickIPChanger\Preset1", "Gateway", "")
RP1d1 := RegRead("HKEY_CURRENT_USER\Software\QuickIPChanger\Preset1", "Primary", "")
RP1d2 := RegRead("HKEY_CURRENT_USER\Software\QuickIPChanger\Preset1", "Secondary", "")

RP2ip := RegRead("HKEY_CURRENT_USER\Software\QuickIPChanger\Preset2", "IP", "")
RP2ma := RegRead("HKEY_CURRENT_USER\Software\QuickIPChanger\Preset2", "Mask", "")
RP2gw := RegRead("HKEY_CURRENT_USER\Software\QuickIPChanger\Preset2", "Gateway", "")
RP2d1 := RegRead("HKEY_CURRENT_USER\Software\QuickIPChanger\Preset2", "Primary", "")
RP2d2 := RegRead("HKEY_CURRENT_USER\Software\QuickIPChanger\Preset2", "Secondary", "")

RNIC_Interf := RegRead("HKEY_CURRENT_USER\Software\QuickIPChanger\NIC", "Interfaces", "")
if (RNIC_Interf = "") {
    RunWait 'PowerShell.exe Get-NetAdapter -Name * | Get-NetIPAddress -AddressFamily IPv4 | Select-Object InterfaceAlias | clip', , "Hide"
    str := A_Clipboard
    ;-------------------- Start of part -- Great thanks! -- nou [Splash] nou#5251 -- from the Discord --------------------
    data := StrSplit(str, "`n", "`r")
    str := ""
    for k, v in data {
        ; ignores the first two line:
        if (A_Index <= 3)
            continue
        ; build up your list of interfaces
        str .= Trim(v)
        ; append them with "|"
        if !(A_Index = data.Length)
            str .= "|"
    }
    RNIC_Interf := SubStr(str, 1, -3)
    ;-------------------- End of part -- Great thanks! -- nou [Splash] nou#5251 -- from the Discord --------------------
    RegWrite(RNIC_Interf, "REG_SZ", "HKEY_CURRENT_USER\Software\QuickIPChanger\NIC", "Interfaces")
    FileDelete("nic.txt")
} else {
    RNIC_Interf := RegRead("HKEY_CURRENT_USER\Software\QuickIPChanger\NIC", "Interfaces", "")
    RNIC_InterfPair := RegRead("HKEY_CURRENT_USER\Software\QuickIPChanger\NIC", "InterfacesPair", "")
}

RCheckNIC_Save := RegRead("HKEY_CURRENT_USER\Software\QuickIPChanger\NIC", "Save", "")
RNIC := RegRead("HKEY_CURRENT_USER\Software\QuickIPChanger\NIC", "NIC", "")
if (RNIC = 1 || RNIC = "") {
    NIC := 1
} else {
    NIC := RNIC
}

;_____________________________________________________________________________________
; GUI
mainGui := Gui()
mainGui.Title := "Quick IP Changer"
mainGui.SetFont("s9", "Segoe UI")
mainGui.Add("GroupBox", "x170 y0 w155 h75", "NIC")
mainGui.Add("DropDownList", "vEthN x180 y20 w135", StrSplit(RNIC_Interf, "|"))
mainGui["EthN"].Choose(NIC)
mainGui.Add("Button", "vButtonRefreshNIC x235 y45 w80 h23", "Refresh &NIC")

mainGui.Add("Radio", "vDHCP x180 y100 w65 h23", "&DHCP")
mainGui.Add("Radio", "vManualIP x245 y100 w70 h23 Checked", "M&anual IP")

; Now that all radio buttons exist, set DHCP/Manual radio based on current adapter status
SetInitialIPMode()

if (RCheckNIC_Save = 1 || RCheckNIC_Save = "") {
    symbol_nic := "+"
} else {
    symbol_nic := "-"
}
mainGui.Add("Checkbox", "vCheckNIC x180 y50 w45 " symbol_nic "checked", "Save")

mainGui.Add("Radio", "vEmpty x13 y10 w120 h23 Checked", "&Empty")
mainGui.Add("Radio", "vPreset1 x13 y175 w120 h23", "P&reset 1")
mainGui.Add("Radio", "vPreset2 x178 y175 w120 h23", "Prese&t 2")

mainGui.Add("GroupBox", "x170 y80 w155 h55", "DHCP / Manual IP")

mainGui.Add("GroupBox", "x5 y0 w155 h165")
mainGui.Add("Text", "x13 y40 w35 h21", "IP")
mainGui.Add("Edit", "vEip x50 y37 w100 h21")
mainGui.Add("Text", "x13 y65 w35 h21", "MASK")
mainGui.Add("Edit", "vEma x50 y62 w100 h21", REma)
mainGui.Add("Text", "x13 y90 w35 h21", "GW")
mainGui.Add("Edit", "vEgw x50 y87 w100 h21")
mainGui.Add("Text", "x13 y110 w142 h2 +0x10")
mainGui.Add("Text", "x13 y115 w35 h21", "DNS 1")
mainGui.Add("Edit", "vEd1 x50 y113 w100 h21")
mainGui.Add("Text", "x13 y140 w35 h21", "DNS 2")
mainGui.Add("Edit", "vEd2 x50 y137 w100 h21")
mainGui["Eip"].Focus()

mainGui.Add("GroupBox", "x5 y165 w155 h165")
mainGui.Add("Text", "x13 y205 w35 h21", "IP")
mainGui.Add("Edit", "vP1ip x50 y202 w100 h21", RP1ip)
mainGui.Add("Text", "x13 y230 w35 h21", "MASK")
mainGui.Add("Edit", "vP1ma x50 y227 w100 h21", RP1ma)
mainGui.Add("Text", "x13 y255 w35 h21", "GW")
mainGui.Add("Edit", "vP1gw x50 y252 w100 h21", RP1gw)
mainGui.Add("Text", "x13 y275 w142 h2 +0x10")
mainGui.Add("Text", "x13 y280 w35 h21", "DNS 1")
mainGui.Add("Edit", "vP1d1 x50 y277 w100 h21", RP1d1)
mainGui.Add("Text", "x13 y305 w35 h21", "DNS 2")
mainGui.Add("Edit", "vP1d2 x50 y302 w100 h21", RP1d2)

mainGui.Add("GroupBox", "x170 y165 w155 h165")
mainGui.Add("Text", "x178 y205 w35 h21", "IP")
mainGui.Add("Edit", "vP2ip x215 y202 w100 h21", RP2ip)
mainGui.Add("Text", "x178 y230 w35 h21", "MASK")
mainGui.Add("Edit", "vP2ma x215 y227 w100 h21", RP2ma)
mainGui.Add("Text", "x178 y255 w35 h21", "GW")
mainGui.Add("Edit", "vP2gw x215 y252 w100 h21", RP2gw)
mainGui.Add("Text", "x178 y275 w142 h2 +0x10")
mainGui.Add("Text", "x178 y280 w35 h21", "DNS 1")
mainGui.Add("Edit", "vP2d1 x215 y277 w100 h21", RP2d1)
mainGui.Add("Text", "x178 y305 w35 h21", "DNS 2")
mainGui.Add("Edit", "vP2d2 x215 y302 w100 h21", RP2d2)

mainGui.Add("Button", "vButtonIPRenew x5 y335 w80 h23", "IP Rene&w")
mainGui.Add("Button", "vButtonSave x85 y335 w80 h23", "&Save")
mainGui.Add("Button", "vButtonOK x165 y335 w80 h23", "&OK")
mainGui.Add("Button", "vButtonApply x245 y335 w80 h23", "Appl&y")

; Pridanie handlera na zatvorenie hlavného okna
mainGui.OnEvent("Close", (*) => ExitApp())

if (RCheckEma = 0) {
    symbol_save := "-"
} else {
    symbol_save := "+"
}
mainGui.Add("Checkbox", "vCheckEma x170 y145 " symbol_save "checked", 'Save subnet for "Empty"')

mainGui.Add("StatusBar", "vStatus")
mainGui["DHCP"].OnEvent("Click", Select)
mainGui["ManualIP"].OnEvent("Click", Select)
mainGui["ButtonRefreshNIC"].OnEvent("Click", RefreshNIC)
mainGui["ButtonSave"].OnEvent("Click", (*) => ButtonSave())
mainGui["ButtonIPRenew"].OnEvent("Click", (*) => ButtonIPRenew())
mainGui["ButtonOK"].OnEvent("Click", (*) => ButtonOK())
mainGui["ButtonApply"].OnEvent("Click", (*) => ButtonApply())

mainGui.Show("w330 h385")
SetTimer(UpdateOSD, 2000)
UpdateOSD()
return

UpdateOSD() {
    global mainGui
    EthN := mainGui["EthN"].Text
    str := GetIPByAdapter(EthN)
    mainGui["Status"].Text := "Current IP address " str
}

GetIPByAdapter(adapterName) {
    try
        objWMIService := ComObject("WbemScripting.SWbemLocator").ConnectServer(".", "root\\cimv2")
    catch
        return "WMI not available"
    colItems := objWMIService.ExecQuery("SELECT * FROM Win32_NetworkAdapter WHERE NetConnectionID = '" adapterName "'")
    if !IsObject(colItems)
        return "WMI query failed"
    for objItem in colItems {
        idx := objItem.InterfaceIndex
        break
    }
    if !idx
        return "No interface index"
    colItems2 := objWMIService.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration WHERE InterfaceIndex = '" idx "'")
    if !IsObject(colItems2)
        return "WMI config query failed"
    for objItem2 in colItems2 {
        return objItem2.IPAddress[0]
    }
    return ""
}

;_____________________________________________________________________________________
; Control
Select(*) {
    global mainGui
    DHCP := mainGui["DHCP"].Value
    if (DHCP = 1) {
        mainGui["Empty"].Enabled := false
        mainGui["Preset1"].Enabled := false
        mainGui["Preset2"].Enabled := false
    } else {
        mainGui["Empty"].Enabled := true
        mainGui["Preset1"].Enabled := true
        mainGui["Preset2"].Enabled := true
    }
}

ButtonSave() {
    global mainGui
    GetDataGuiControlGet()
    if (mainGui["CheckEma"].Value = 0)
        Ema := ""
    else
        Ema := mainGui["Ema"].Text
    RegWrite(Ema, "REG_SZ", "HKEY_CURRENT_USER\Software\QuickIPChanger\Empty", "Mask")
    RegWrite(mainGui["CheckEma"].Value, "REG_DWORD", "HKEY_CURRENT_USER\Software\QuickIPChanger\Empty", "Save")
    RegWrite(mainGui["P1ip"].Text, "REG_SZ", "HKEY_CURRENT_USER\Software\QuickIPChanger\Preset1", "IP")
    RegWrite(mainGui["P1ma"].Text, "REG_SZ", "HKEY_CURRENT_USER\Software\QuickIPChanger\Preset1", "Mask")
    RegWrite(mainGui["P1gw"].Text, "REG_SZ", "HKEY_CURRENT_USER\Software\QuickIPChanger\Preset1", "Gateway")
    RegWrite(mainGui["P1d1"].Text, "REG_SZ", "HKEY_CURRENT_USER\Software\QuickIPChanger\Preset1", "Primary")
    RegWrite(mainGui["P1d2"].Text, "REG_SZ", "HKEY_CURRENT_USER\Software\QuickIPChanger\Preset1", "Secondary")
    RegWrite(mainGui["P2ip"].Text, "REG_SZ", "HKEY_CURRENT_USER\Software\QuickIPChanger\Preset2", "IP")
    RegWrite(mainGui["P2ma"].Text, "REG_SZ", "HKEY_CURRENT_USER\Software\QuickIPChanger\Preset2", "Mask")
    RegWrite(mainGui["P2gw"].Text, "REG_SZ", "HKEY_CURRENT_USER\Software\QuickIPChanger\Preset2", "Gateway")
    RegWrite(mainGui["P2d1"].Text, "REG_SZ", "HKEY_CURRENT_USER\Software\QuickIPChanger\Preset2", "Primary")
    RegWrite(mainGui["P2d2"].Text, "REG_SZ", "HKEY_CURRENT_USER\Software\QuickIPChanger\Preset2", "Secondary")
    if (mainGui["CheckNIC"].Value = 0) {
        RegWrite(mainGui["CheckNIC"].Value, "REG_DWORD", "HKEY_CURRENT_USER\Software\QuickIPChanger\NIC", "Save")
        try RegDelete("HKEY_CURRENT_USER\Software\QuickIPChanger\NIC", "NIC")
    } else {
        RegWrite(mainGui["CheckNIC"].Value, "REG_DWORD", "HKEY_CURRENT_USER\Software\QuickIPChanger\NIC", "Save")
        RegWrite(mainGui["EthN"].Text, "REG_SZ", "HKEY_CURRENT_USER\Software\QuickIPChanger\NIC", "NIC")
    }
}

ButtonIPRenew() {
    global mainGui
    Run('*RunAs cmd.exe /k ipconfig /renew ' mainGui["EthN"].Text, , "Hide")
}

ButtonOK() {
    ButtonApply()
}

ButtonApply() {
    global mainGui
    GetDataGuiControlGet()
    if (mainGui["DHCP"].Value = 1) {
        Run('*RunAs cmd.exe /k netsh interface ip set address ' mainGui["EthN"].Text ' dhcp', , "Hide")
        Run('*RunAs cmd.exe /k netsh interface ip set dnsservers name=' mainGui["EthN"].Text ' source=dhcp', , "Hide")
    } else if (mainGui["ManualIP"].Value = 1) {
        if (mainGui["Empty"].Value = 1) {
            Run('*RunAs cmd.exe /k netsh interface ipv4 set address name=' mainGui["EthN"].Text ' source=static addr=' mainGui["Eip"].Text ' mask=' mainGui["Ema"].Text ' gateway=' mainGui["Egw"].Text ' 1', , "Hide")
            Run('*RunAs cmd.exe /k netsh interface ipv4 set dnsservers name=' mainGui["EthN"].Text ' static ' mainGui["Ed1"].Text, , "Hide")
            Run('*RunAs cmd.exe /k netsh interface ipv4 add dnsserver name=' mainGui["EthN"].Text ' address=' mainGui["Ed2"].Text ' index=2', , "Hide")
        } else if (mainGui["Preset1"].Value = 1) {
            Run('*RunAs cmd.exe /k netsh interface ip set address name=' mainGui["EthN"].Text ' source=static addr=' mainGui["P1ip"].Text ' mask=' mainGui["P1ma"].Text ' gateway=' mainGui["P1gw"].Text ' 1', , "Hide")
            Run('*RunAs cmd.exe /k netsh interface ipv4 set dnsservers name=' mainGui["EthN"].Text ' static ' mainGui["P1d1"].Text, , "Hide")
            Run('*RunAs cmd.exe /k netsh interface ipv4 add dnsserver name=' mainGui["EthN"].Text ' address=' mainGui["P1d2"].Text ' index=2', , "Hide")
        } else if (mainGui["Preset2"].Value = 1) {
            Run('*RunAs cmd.exe /k netsh interface ip set address name=' mainGui["EthN"].Text ' source=static addr=' mainGui["P2ip"].Text ' mask=' mainGui["P2ma"].Text ' gateway=' mainGui["P2gw"].Text ' 1', , "Hide")
            Run('*RunAs cmd.exe /k netsh interface ipv4 set dnsservers name=' mainGui["EthN"].Text ' static ' mainGui["P2d1"].Text, , "Hide")
            Run('*RunAs cmd.exe /k netsh interface ipv4 add dnsserver name=' mainGui["EthN"].Text ' address=' mainGui["P2d2"].Text ' index=2', , "Hide")
        }
    }
}

GetDataGuiControlGet() {
    global mainGui
    ; All values are accessible via mainGui["ControlName"].Value or .Text
}

RefreshNIC(*) {
    try RegDelete("HKEY_CURRENT_USER\\Software\\QuickIPChanger\\NIC", "Interfaces")
    try RegDelete("HKEY_CURRENT_USER\\Software\\QuickIPChanger\\NIC", "NIC")
    Reload()
}

#HotIf WinActive("Quick IP Changer")
NumpadDot::Send(".")
Enter::ButtonApply()
NumpadEnter::ButtonApply()
F5::Reload()
#HotIf

Esc::ExitApp()

SetInitialIPMode() {
    global mainGui
    adapter := mainGui["EthN"].Text
    dhcp := IsDHCPEnabled(adapter)
    if (dhcp = 1) {
        mainGui["DHCP"].Value := 1
        mainGui["ManualIP"].Value := 0
    } else {
        mainGui["DHCP"].Value := 0
        mainGui["ManualIP"].Value := 1
    }
}

IsDHCPEnabled(adapterName) {
    try
        objWMIService := ComObject("WbemScripting.SWbemLocator").ConnectServer(".", "root\\cimv2")
    catch
        return 0
    ; Try to match adapter by NetConnectionID, InterfaceAlias, Description, or Caption
    query := "SELECT * FROM Win32_NetworkAdapter WHERE "
        . "NetConnectionID = '" adapterName "' OR "
        . "InterfaceAlias = '" adapterName "' OR "
        . "Description = '" adapterName "' OR "
        . "Caption = '" adapterName "'"
    colItems := objWMIService.ExecQuery(query)
    idx := ""
    for objItem in colItems {
        idx := objItem.InterfaceIndex
        break
    }
    if !idx
        return 0
    colItems2 := objWMIService.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration WHERE InterfaceIndex = '" idx "'")
    for objItem2 in colItems2 {
        return objItem2.DHCPEnabled ? 1 : 0
    }
    return 0
}
