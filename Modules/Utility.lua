local Utility = {}

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
        return Exists
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