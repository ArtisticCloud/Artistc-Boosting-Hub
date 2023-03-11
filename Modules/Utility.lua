local Utility = {}
local Info = loadstring(game:HttpGet(("https://raw.githubusercontent.com/ArtisticCloud/Artistc-Boosting-Hub/master/Modules/Info.lua"),true))()
local Http = game:GetService( 'HttpService' )

--// Services // --
local Storage = game:GetService( 'ReplicatedStorage' ) 

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
        return Http:JSONDecode(readfile( FilePath ))
    end 
end 

function Utility.hasBall( Player )
    return Player.Parent and Player.Character and Player.Character:FindFirstChild( 'ball.weld' )
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
    return 'Invalid Plce'
end

function Utility.tableLen( Table )
    local n = 0
    for _,item in pairs(Table) do
        n += 1
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

return Utility