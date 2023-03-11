local Info = {}

--// Account Manager stuff //--
Info.MaxAlts = 5

--// Files stuff //--
Info.FolderName = "Art's Hub"
Info.ACFileName = "Account Control" 
Info.GDFileName = 'General Data'
Info.GDFileTemplate = {
    Main = '' , 
    Alts = {} , 
    TeleportingTo = '' , 
    Boosting = false ,
}
Info.ACFileTemplate = {
    Accounts = {} , 
}
Info.ACAccountData = {
    Online = false , 
    Teleporting = '' , 
    CurrentPlace = '' , 
    CurrentTask = {OnBall='',OffBall=''} ,
}

--// Ingame stuff //--
Info.Places = {
    Park = 0 , 
    RecLobby = 0,
    Plaza = 0 ,
    MainMenu = 0,
}

Info.CommandTypes = {
    OnBall = {
        'Auto Shoot' , 
        'Auto Pass' , 
    } , 
    OffBall = {
        'Auto Guard'
    } , 
}

Info.AimbotSliderSettings = {
    Min = 0.25 ,
    Max = 0.85 
}

--// UI Stuff //--
Info.DefaultKeybind = 'Left Alt'

--// Misc. //--


return Info