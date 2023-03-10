local AccountControl = {}
local Info = loadstring(game:HttpGet(("https://raw.githubusercontent.com/ArtisticCloud/Artistc-Boosting-Hub/master/Modules/Info.lua"),true))()
local Utility = loadstring(game:HttpGet(("https://raw.githubusercontent.com/ArtisticCloud/Artistc-Boosting-Hub/master/Modules/Utility.lua"),true))()

function AccountControl.new( Hub )
    local self = setmetatable({},{
        __index = function(t,index,value)
            if not AccountControl[index] then
                return Hub[index]
            end
            return AccountControl[index]
        end,
    })
    return self
end 

function AccountControl:registerAccount( Username , Userid )
    local AccountControlData = Utility.getData( Info.ACFileName ) or {}
    print( 'Data' , unpack(AccountControlData) )
end 

function AccountControl:unregisterAccount( Username , UserId )
    local Data = Utility.getData( Info.ACFileName ) or {}
end     

return AccountControl