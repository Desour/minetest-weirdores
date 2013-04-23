
local antigravities = {}

local is_antigravity = function(pos)
	for _, i in ipairs(antigravities) do
		if  i.x == pos.x
		and i.y < pos.y
		and i.z == pos.z then
			return true
		end
	end
	return false
end

minetest.register_node("weirdores:antigravity",{
	description = "Antigravity",
	tiles = {"weirdores_antigravity.png"},
	is_ground_content = true,
	groups = {anti=1,level=2},
	sounds = default.node_sound_stone_defaults(),
	on_construct = function(pos)
		-- Registers antigravity in abm, so no need to do it here
	end,
	on_destruct = function(pos)
		for i, a in ipairs(antigravities) do
			if a.x == pos.x and a.y == pos.y and a.z == pos.z then
				table.remove(antigravities,i)
			end
		end
	end,
})

minetest.register_globalstep(function(dtime)
	for _, p in ipairs(minetest.get_connected_players()) do
		local pos = p:getpos()
		local rpos = {
			x = math.floor(pos.x+.5),
			y = math.floor(pos.y+.5),
			z = math.floor(pos.z+.5)
		}
		if is_antigravity(rpos) then
			p:set_physics_override(nil,nil,-1)
		else
			p:set_physics_override(nil,nil,1)
		end
	end
end)

minetest.register_abm({
	nodenames={"weirdores:antigravity"},
	interval = 5,
	chance = 1,
	action = function(pos, node)
		minpos = {}
		minpos.x = pos.x - .5
		minpos.y = pos.y
		minpos.z = pos.z - .5
		maxpos = {}
		maxpos.x = pos.x + .5
		maxpos.y = pos.y
		maxpos.z = pos.z + .5
		minetest.add_particlespawner(100,10,
			minpos, maxpos,
			{x=0,y=20,z=0}, {x=0,y=20,z=0},
			{x=0,y=0,z=0}, {x=0,y=0,z=0},
			10, 10,
			.1, 1,
			false, "weirdores_particle_mese.png")
			
		if not is_antigravity({x=pos.x, y=pos.y+1, z=pos.z}) then
			table.insert(antigravities,pos)
		end
	end,
})

minetest.register_craft({
	output = 'weirdores:antigravity',
	recipe = {
		{'default:mese_crystal','default:mese_crystal','default:mese_crystal'},
		{'default:mese_crystal','weirdores:antimeseblock','default:mese_crystal'},
		{'default:mese_crystal','default:mese_crystal','default:mese_crystal'},
	}
})

minetest.register_alias("ruby:antigravity","weirdores:antigravity")

