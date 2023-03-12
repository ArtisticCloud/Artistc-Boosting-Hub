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

Commands[ 'Auto Pass' ] = function( PassingTo )
    
end

Commands[ 'Auto Shoot' ] = function()
    
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
    self.CommandData = {OnBall={},OffBall={}}

    print( "Art's Hub Debug: | Command set created" )

    return self
end

function Commands:CharacterEvents( Character )
    Character.ChildAddded:Connect(function( Child )
        if Child.Name == 'Basketball' and Commands[self.OnBall] then
            Commands[self.OnBall](self.CommandData.OnBall)
        end 
    end)
end

function Commands:Listen()
    --// Check if the alt is in account control //--
    local AccountControlData = Utility.getData( Info.ACFileName )
    local AccountData = AccountControlData and AccountControlData.Accounts[Player.Name]
    if AccountData then
        self.OnBall = AccountData.CurrentTasks.OnBall 
        self.OffBall = AccountData.CurrentTasks.OffBall
    end
end

function Commands:Update()
    if Commands[ self.OffBall ] and not Utility.hasBall() and Player.Character then
        Commands[ self.OffBall ](self.CommandData.OffBall) 
    end
end

return Commands