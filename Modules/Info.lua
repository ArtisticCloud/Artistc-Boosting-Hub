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

Info.Snitches = { --// Automatically kick out the game if one of these joins
    'gunchowda' , 
    'isitjokes' , 
    'ljokes' ,
    'xv_nike' , 
    'errorchekz' ,
    'superfluousbacon' , 
    'zornage' , 
    'luadimer' , 
    'cooiius' , 
    'ashleydaballer' , 
    'zevroo' , 
    'kiricali' ,
    'rrhen101' , 
    'woodall25' ,
    'apathedic' ,
    'applecow14' , 
}

Info.ACAccountData = {
    Online = false , 
    Teleporting = '' , 
    CurrentPlace = '' , 
    CurrentTasks = {OnBall='',OffBall=''} ,
    TaskData = {OnBall={},OffBall={}} , 
}

--// Ingame stuff //--
Info.Places = {
    Park = 10107441386 , 
    RecLobby = 10207014047,
    Plaza = 8448881160 ,
    MainMenu = 7899881670,
    RecQ = 10217709305 , 
    RecGame = 0 ,
}

Info.CommandTypes = {
    OnBall = {
        'Auto Shoot' , 
        'Auto Pass' , 
        'Auto Post Fade' , 
        'Auto Post Hook' , 
        'Auto Off Dribble' ,
        'Auto Acro' , 
        'Auto Post Tech' ,  
    } , 
    OffBall = {
        'Auto Guard' , 
        'Auto Post Anchor' , 
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