local Utility = {}
Utility.__index = Utility

function Utility.new()
    local self = setmetatable({},Utility)
    
    print( 'was called')
    return self
end 


return Utility