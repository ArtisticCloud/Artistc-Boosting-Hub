local Rec = {}

local Player = game.Players.LocaPlayer 
local Storage = game:GetService( 'ReplicatedStorage' )

local Remotes = Storage:WaitForChild( 'Remotes' ) 

function Rec.new( Hub , Window )
    local self = setmetatable({},{
        __index = function( Table , Index , Value )
            if not Rec[Index] then
                return Hub[Index]
            end
            return Rec[Index]
        end,
    })

    self.RecTab = Window:AddTab( 'Rec.' )
    self.UIElements = {}

    self:LoadUI()
    self:Events()

    return self
end

function Rec:LoadUI()
    self.RecTab:AddLeftGroupbox( 'Rec. Lobby' )

end

function Rec:Events()

end

function Rec:createParty()
    return Remotes.Parties:InvokeServer( 'Start' )
end

function Rec:JoinParty( Code )
    Remotes.Parties:InvokeServer( 'Leave' )
    local Response = Remotes.Parties:InvokeServer( 'Join' , tostring(Code) )
    if Response == false then
        self.Linoria:Notify( 'there was an error joining the party..' , 10 )
        return
    end
    self.Linoria:Notify( 'Successfully joined party through code: ' .. '"' .. Code .. '"' )
end

function Rec:Update()
    local RecData = Utility.getData( Info.GDFileName )
    if RecData then
    
    end
end

return Rec