
-- Configuration
-- Remove the modules you do not want to load
local MODULES = {
	"ruby",
	"anticrystal",
	"antigravity",
}

-- End of configuration

local MODPATH = minetest.get_modpath("ruby")
for i, m in ipairs(MODULES) do
	dofile(MODPATH.."/"..m..".lua")
end
