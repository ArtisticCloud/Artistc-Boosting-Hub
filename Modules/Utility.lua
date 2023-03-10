local Utility = {}

function Utility.findGlobalPlayer( Username )
    local UserId 
    local s,e = pcall(function()
        UserId = game.Players:GetUserIdFromNameAsync( Username )
    end)
    if not s then print(e) end
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

function Utility.saveData( Data )
    makefolder( FolderName )
    writefile( FilePath )
end 

function Utility.getData()
    if isfile( FilePath ) then
        return readfile( FilePath )
    end 
end 

return Utility