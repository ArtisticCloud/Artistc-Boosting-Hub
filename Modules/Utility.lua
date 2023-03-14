local Utility = {}
local Info = loadstring(game:HttpGet(("https://raw.githubusercontent.com/ArtisticCloud/Artistc-Boosting-Hub/master/Modules/Info.lua"),true))()
local Http = game:GetService( 'HttpService' )

--// Services // --
local Storage = game:GetService( 'ReplicatedStorage' ) 
local JDIO = 2

function Utility.findGlobalPlayer( Username )
    local UserId 
    local s,e = pcall(function()
        UserId = game.Players:GetUserIdFromNameAsync( Username )
    end)
    if UserId then
        local Exists 
        local s,e = pcall(function()
            Exists = game.Players:GetNameFromUserIdAsync( UserId )
        end)
        return Exists , UserId
    end 
end 

function Utility.findLocalPlayer( Username )
    for _,Player in game:GetService( 'Players' ):GetPlayers() do
        if Player.Name:lower():find( Username:lower() ) then
            return Player
        end 
        continue
    end 
end 

function Utility.saveData( FileName , Data )
    makefolder( Info.FolderName )
    writefile( Info.FolderName .. '/' .. FileName .. '.txt' , Http:JSONEncode( Data ) )
end 

function Utility.getData( FileName )
    local FilePath = Info.FolderName .. '/' .. FileName .. '.txt'
    if isfile( FilePath ) then
        local Data 
        local Success,Error = pcall(function()
            Data = Http:JSONDecode(readfile( FilePath ))
        end)
        return Data , Error
    end 
end 

function Utility.hasBall( Player )
    return Player.Parent and Player.Character and Player.Character:FindFirstChild( 'ball.weld' )
end  

function Utility.isValidAlt( Username )
    local AccountControlData = Utility.getData( Info.ACFileName )
    if AccountControlData and AccountControlData.Accounts[Username] then
        return AccountControlData.Accounts[Username] , AccountControlData
    end
end

function Utility.followPlayer( Player , UserId , UseData )
    local CurrentPlace = Utility.findIndexFromValue( Info.Places , game.PlaceId )
    if CurrentPlace then
        if CurrentPlace == 'Main Menu' then
            Storage.Remotes.Teleport:InvokeServer( 'Plaza' , {Slot=UseData.Slot} )
        else
            Storage.SocialFunctions.Follow:InvokeServer( UserId )
        end 
        return 
    end
    return 'Invalid Place'
end 

function Utility.teleportTo( Place , Slot )
    local Player = game:GetService( 'Players' ).LocalPlayer 
    local CurrentPlace = Utility.findIndexFromValue( Info.Places , game.PlaceId )
    if CurrentPlace and CurrentPlace:lower() ~= Place:lower() then
        if CurrentPlace == 'Main Menu' then 
            
        end
        return true
    end
    return 'Invalid Place'
end

function Utility.findOpenIndex( Table )
    for index,item in pairs(Table) do
        if item == ''  then
            return index,item
        end
        continue
    end
end 

function Utility.tableLen( Table )
    local n = 0
    for _,item in pairs(Table) do
        n = n + 1
    end
    return n
end

function Utility.findIndexFromValue( Table , Value )
    for index,value in pairs( Table ) do
        if value == Value then
            return index 
        end
    end 
end 

function Utility.sendMessageThroughBot( content , message )
    local Http = game:GetService( 'HttpService' )
    local Data = {
        username = Info.BotUsername , 
        content = content , 
        embeds = {{
            author = {name=''} , 
            title = '' , 
            description = message , 
            ['type'] = 'rich' , 
            color = 16737300 ,
        }} , 
    }
    local request = http_request or request or HttpPost or syn.request
    print( 'WEBHOOK' , Info.Webhook)
    request({
        Url = Info.Webhook,
        Body = Http:JSONEncode(Data),
        Method = "POST",
        Headers = {
            ["content-type"] = "application/json"
        }
    })
end

function Utility.Teleport( Place , Slot )
    local CurrentPlace = Utility.findIndexFromValue( game.PlaceId )

    local function tp( Place )
        Remotes.Teleport:InvokeServer( Place )
    end

    if Place == 'Rec Lobby' or Place == 'Park' or Place == 'My Gym' then
        if CurrentPlace == 'MainMenu' then
            
        end
    end
end

return Utility