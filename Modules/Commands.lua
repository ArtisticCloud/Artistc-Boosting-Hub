local Commands = {}
local Utility = loadstring(game:HttpGet(("https://raw.githubusercontent.com/ArtisticCloud/Artistc-Boosting-Hub/master/Modules/Utility.lua"),true))()
local Info = loadstring(game:HttpGet(("https://raw.githubusercontent.com/ArtisticCloud/Artistc-Boosting-Hub/master/Modules/Info.lua"),true))()

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

local Storage = game:GetService( 'ReplicatedStorage' ) 
local Tween = game:GetService( 'TweenService' )

local Remotes = Storage:WaitForChild( 'Remotes' ) 
local GameEvents = Storage:WaitForChild( 'GameEvents' )

Player.CharacterAdded:Connect(function( NewCharacter )
    Character = NewCharacter
end)

Commands.AutoPass = function( PassingTo )
    
end

Commands.AutoShoot = function()
    
end

function Commands.new( Hub )
    local self = setmetatable({},{
        __index = function( Table , Index , Value )
            if not Commands[Index] then
                return Hub[Index]
            end
            return Commands[Index]
        end,
    })    
    
    self.OnBall = ''
    self.OffBall = ''

    return self
end

function Commands:SwitchTask()

end


return Commands