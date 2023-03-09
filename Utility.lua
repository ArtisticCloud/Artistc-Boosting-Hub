local Utility = {}
Utility.__index = Utility

function Utility.new()
    local self = setmetatable({},Utility)
    
    return self
end 


return Utility