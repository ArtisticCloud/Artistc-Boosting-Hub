local Rec = {}

local Player = game.Players.LocaPlayer 
local Storage = game:GetService( 'ReplicatedStorage' )

local Remotes = Storage:WaitForChild( 'Remotes' ) 

function Rec.new( Hub , Main1 , Main2 )
    local self = setmetatable({},{
        __index = function( Table , Index , Value )
            if not Rec[Index] then
                return Hub[Index]
            end
            return Rec[Index]
        end,
    })

    self.Main1 = Main1 
    self.Main2 = Main2

    return self
end

function Rec:CreateCodes()
    
end

function Rec:JoinParty( Code )

end

function Rec:Update()

end

return Rec