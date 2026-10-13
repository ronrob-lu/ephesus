-- Check for mod existence
local i3_mod = minetest.get_modpath("i3") and minetest.global_exists("i3")

local stairsplus_mod = minetest.get_modpath("moreblocks") and minetest.global_exists("stairsplus")
local stairsplus_compat = minetest.settings:get_bool("stairsplus_clay_compatibility") ~= false

-- Sound definitions for MTG and VoxeLibre / Mineclonia
local sound_stone = nil
local sound_wood = nil
local sound_leaves = nil

if minetest.get_modpath("mcl_sounds") and minetest.global_exists("mcl_sounds") then
	if mcl_sounds.node_sound_stone_defaults then
		sound_stone = mcl_sounds.node_sound_stone_defaults()
	end
	if mcl_sounds.node_sound_wood_defaults then
		sound_wood = mcl_sounds.node_sound_wood_defaults()
	end
	if mcl_sounds.node_sound_leaves_defaults then
		sound_leaves = mcl_sounds.node_sound_leaves_defaults()
	end
elseif minetest.get_modpath("default") and minetest.global_exists("default") then
	if default.node_sound_stone_defaults then
		sound_stone = default.node_sound_stone_defaults()
	end
	if default.node_sound_wood_defaults then
		sound_wood = default.node_sound_wood_defaults()
	end
	if default.node_sound_leaves_defaults then
		sound_leaves = default.node_sound_leaves_defaults()
	end
end



-- Shapes
local shapes = {
        { "micro", "" },
    	{ "micro", "_1" },
    	{ "micro", "_2" },
    	{ "micro", "_4" },
    	{ "micro", "_12" },
    	{ "micro", "_14" },
    	{ "micro", "_15" },
    	{ "panel", "" },
    	{ "panel", "_1" },
    	{ "panel", "_2" },
    	{ "panel", "_4" },
    	{ "panel", "_12" },
    	{ "panel", "_14" },
    	{ "panel", "_15" },
    	{ "slab",  "" },
    	{ "slab",  "_quarter" },
    	{ "slab",  "_three_quarter" },
    	{ "slab",  "_1" },
    	{ "slab",  "_2" },
    	{ "slab",  "_14" },
    	{ "slab",  "_15" },
    	{ "slab",  "_two_sides" },
    	{ "slab",  "_three_sides" },
    	{ "slab",  "_three_sides_u" },
    	{ "slope", "" },
    	{ "slope", "_half" },
    	{ "slope", "_half_raised" },
    	{ "slope", "_inner" },
    	{ "slope", "_inner_half" },
    	{ "slope", "_inner_half_raised" },
    	{ "slope", "_inner_cut" },
    	{ "slope", "_inner_cut_half" },
    	{ "slope", "_inner_cut_half_raised" },
    	{ "slope", "_outer" },
    	{ "slope", "_outer_half" },
    	{ "slope", "_outer_half_raised" },
    	{ "slope", "_outer_cut" },
    	{ "slope", "_outer_cut_half" },
    	{ "slope", "_outer_cut_half_raised" },
    	{ "slope", "_cut" },
    	{ "stair", "" },
    	{ "stair", "_half" },
    	{ "stair", "_right_half" },
    	{ "stair", "_inner" },
    	{ "stair", "_outer" },
    	{ "stair", "_alt" },
    	{ "stair", "_alt_1" },
    	{ "stair", "_alt_2" },
    	{ "stair", "_alt_4" },
    }


--- Node Registration

-- Full Blocks
local full_blocks = {
    {"marble", "Marble"},
    {"polished_marble", "Polished Marble"},
    {"grey_marble", "Grey Marble"},
    {"tiles", "Tiles"},
    {"blue_mosaic", "Blue Mosaic"},
    {"red_mosaic", "Red Mosaic"},
    {"cypress_planks", "Cypress Planks"},
    {"apricot_trunk_block", "Block of Cypres Trunk"},
    {"cypress_trunk_block", "Block of Apricot Trunk"},
    {"olive_trunk_block", "Block of Apricot Trunk"},
    {"fig_trunk_block", "Block of Fig Trunk"}
}

-- Leaves Blocks
local leave_blocks = {
    {"cypres1", "Cypress Leaves 1"},
    {"cypres2", "Cypress Leaves 2"},
    {"cypres3", "Cypress Leaves 3"},
    {"apricot_leaves", "Apricot Leaves"},
    {"olive_leaves", "Olive Leaves"},
    {"fig_leaves", "Fig Leaves"}
}

-- Brickslabs
local brick_slab = {
    {"marble","marble", "Marble"},
    {"polished_marble","polished_marble", "Polished Marble"},
    {"grey_marble","grey_marble", "Grey Marble"},
    {"default_clay","clay","Clay"},
    {"default_tin_block","tin","Tin"}
}

-- Brickslabs Corner
local brick_slab_corner = {
    {"marble","marble", "Marble"},
    {"polished_marble","polished_marble", "Polished Marble"},
    {"grey_marble","grey_marble", "Grey Marble"},
    {"default_clay","clay","Clay"},
    {"default_tin_block","tin","Tin"}
}

-- Special Slab Blocks
local full_blocks_special_slab = {
    {"marble", "Marble"},
    {"polished_marble", "Polished Marble"},
    {"grey_marble", "Grey Marble"}
}

-- Trunk Blocks
local trunk_blocks = {
    {"cypress_trunk", "Cypress Trunk", "cypress_trunk_top.png", "cypress_trunk_top.png", "cypress_trunk.png"},
    {"apricot_trunk", "Apricot Trunk", "apricot_trunk_top.png", "apricot_trunk_top.png", "apricot_trunk.png"},
    {"olive_trunk", "Olive Trunk", "olive_trunk_top.png", "olive_trunk_top.png", "olive_trunk.png"},
    {"fig_trunk", "Fig Trunk", "fig_trunk_top.png", "fig_trunk_top.png", "fig_trunk.png"},
}



---Register 

-- Register Full Blocks
for _, full_block in pairs(full_blocks) do
    local is_wood = full_block[1]:find("planks") or full_block[1]:find("trunk")
    local block_groups = {cracky = 3, ephesus = 1, building_block = 1}
    local block_sounds = sound_stone
    if is_wood then
        block_groups.choppy = 2
        block_groups.axey = 1
        block_groups.material_wood = 1
        block_sounds = sound_wood or sound_stone
    else
        block_groups.pickaxey = 1
        block_groups.material_stone = 1
        block_sounds = sound_stone
    end

    minetest.register_node("ephesus:" .. full_block[1], {
        description = full_block[2],
        tiles = {full_block[1] .. ".png"},
        groups = block_groups,
        sounds = block_sounds
    })

    if stairsplus_mod then
        stairsplus:register_all("ephesus", full_block[1], "ephesus:" .. full_block[1], {
            description = full_block[2],
            tiles = {full_block[1] .. ".png"},
            groups = block_groups,
            sounds = block_sounds
        })

        -- Compression pour les blocs pleins
        if i3_mod then
            for _, shape in pairs(shapes) do
                i3.compress("ephesus:" .. full_block[1], {
                    replace = full_block[1],
                    by = {shape[1] .. "_" .. full_block[1] .. shape[2]}
                })
            end
        end
    elseif minetest.get_modpath("mcl_stairs") and minetest.global_exists("mcl_stairs") and mcl_stairs.register_stair_and_slab then
        pcall(mcl_stairs.register_stair_and_slab, full_block[1], "ephesus:" .. full_block[1], block_groups, {full_block[1] .. ".png"}, full_block[2] .. " Stair", full_block[2] .. " Slab", block_sounds)
    elseif minetest.get_modpath("stairs") and minetest.global_exists("stairs") and stairs.register_stair_and_slab then
        pcall(stairs.register_stair_and_slab, full_block[1], "ephesus:" .. full_block[1], block_groups, {full_block[1] .. ".png"}, full_block[2] .. " Stair", full_block[2] .. " Slab", block_sounds)
    end
end



-- ...

-- Register Trunk Blocks
for _, trunk_block in pairs(trunk_blocks) do
    local trunk_groups = {
        cracky = 3,
        choppy = 2,
        tree = 1,
        flammable = 2,
        ephesus = 1,
        axey = 1,
        handy = 1,
        building_block = 1,
        material_wood = 1,
    }
    local trunk_sounds = sound_wood or sound_stone

    minetest.register_node("ephesus:" .. trunk_block[1], {
        description = trunk_block[2],
        tiles = {
            trunk_block[3], -- Texture pour la face supérieure
            trunk_block[4], -- Texture pour la face inférieure 
            trunk_block[5], -- Texture pour les côtés
            trunk_block[5], -- Texture pour les côtés
            trunk_block[5], -- Texture pour les côtés
            trunk_block[5], -- Texture pour les côtés
        },
        paramtype2 = "facedir",
        groups = trunk_groups,
        sounds = trunk_sounds,
    })

    if stairsplus_mod then
        stairsplus:register_all("ephesus", trunk_block[1], "ephesus:" .. trunk_block[1], {
            description = trunk_block[2],
            tiles = {
                trunk_block[3], -- Texture pour la face supérieure
                trunk_block[4], -- Texture pour la face inférieure
                trunk_block[5], -- Texture pour les côtés
                trunk_block[5], -- Texture pour les côtés
                trunk_block[5], -- Texture pour les côtés
                trunk_block[5], -- Texture pour les côtés
            },
            paramtype2 = "facedir",
            groups = trunk_groups,
            sounds = trunk_sounds,
        })
    end

    -- Compression pour les blocs de tronc
    if i3_mod then
        for _, shape in pairs(shapes) do
            i3.compress("ephesus:" .. trunk_block[1], {
                replace = trunk_block[1],
                by = {shape[1] .. "_" .. trunk_block[1] .. shape[2]}
            })
        end
    end
end



-- Register Leave Blocks

for _, leave_block in pairs(leave_blocks) do
    minetest.register_node("ephesus:" .. leave_block[1], {
        description = leave_block[2],
        drawtype = "allfaces_optional",
        paramtype = "light",
        waving = 1,
        tiles = {leave_block[1] .. ".png"},
        sunlight_propagates = true,
        is_ground_content = true,
        groups = {
            snappy = 2,
            leafdecay = 3,
            flammable = 2,
            leaves = 1,
            sheary = 1,
            swordy = 1,
            handy = 1,
            deco_block = 1,
            material_leaves = 1,
        },
        sounds = sound_leaves,
    })
end


-- Register Special Slabs and Special Slab Corners

for _, special_slab in pairs(full_blocks_special_slab) do

    minetest.register_node("ephesus:" .. special_slab[1] .. "_special_slab", {
        description = special_slab[2] .. " 15/16 Slab",
        tiles = {special_slab[1] .. ".png"},
        paramtype = "light",
        drawtype = "nodebox",
        paramtype2 = "facedir",
        node_box = {type = "fixed", fixed = {{-0.5, -0.5, -0.5, 0.5, 0.4375, 0.5}}},
        selection_box = {type = "fixed", fixed = {{-0.5, -0.5, -0.5, 0.5, 0.4375, 0.5}}},
        groups = {cracky = 2, oddly_breakable_by_hand = 1, pickaxey = 1, building_block = 1, material_stone = 1},
        sounds = sound_stone,
    })

    minetest.register_node("ephesus:" .. special_slab[1] .. "_special_slab_corner", {
        description = special_slab[2] .. " 15/16 Slab Corner",
        tiles = {special_slab[1] .. ".png"},
        paramtype = "light",
        drawtype = "nodebox",
        paramtype2 = "facedir",
        node_box = {type = "fixed", fixed = {{-0.5, -0.5, -0.5, 0.5, 0.4375, 0.4375}}},
        selection_box = {type = "fixed", fixed = {{-0.5, -0.5, -0.5, 0.5, 0.4375, 0.4375}}},
        groups = {cracky = 2, oddly_breakable_by_hand = 1, pickaxey = 1, building_block = 1, material_stone = 1},
        sounds = sound_stone,
    })
end


-- Register Bricks and Bricks Corners

for _, b_slab in pairs(brick_slab) do
    local is_default_texture = b_slab[1]:find("^default_")
    if not is_default_texture or minetest.get_modpath("default") then
        minetest.register_node("ephesus:" .. b_slab[2] .. "_brick_slab", {
            description = "Brick Slab " .. b_slab[3],
            tiles = {b_slab[1] .. ".png"},
            drawtype = "nodebox",
            paramtype = "light",
            paramtype2 = "facedir",
            groups = {cracky = 2, ephesus_blocks = 6, pickaxey = 1, building_block = 1, material_stone = 1},
            sounds = sound_stone,
            node_box = {type = "fixed", fixed = {-0.5, -0.5, 0.4375, 0.5, 0.4375, 0.5}},
            selection_box = {type = "fixed", fixed = {-0.5, -0.5, 0.4375, 0.5, 0.4375, 0.5}},
            collision_box = {type = "fixed", fixed = {-0.5, -0.5, 0.4375, 0.5, 0.4375, 0.5}},
        })

        minetest.register_node("ephesus:" .. b_slab[2] .. "_brick_slab_corner", {
            description = "Brick Slab Corner " .. b_slab[3],
            tiles = {b_slab[1] .. ".png"},
            drawtype = "nodebox",
            paramtype = "light",
            paramtype2 = "facedir",
            groups = {cracky = 2, ephesus_blocks = 6, pickaxey = 1, building_block = 1, material_stone = 1},
            sounds = sound_stone,
            node_box = {type = "fixed", fixed = {-0.4375, -0.5, 0.4375, 0.5, 0.4375, 0.5}},
            selection_box = {type = "fixed", fixed = {-0.4375, -0.5, 0.4375, 0.5, 0.4375, 0.5}},
            collision_box = {type = "fixed", fixed = {-0.4375, -0.5, 0.4375, 0.5, 0.4375, 0.5}},
        })
    end
end




-- Registration of other node types

-- Column
minetest.register_node("ephesus:marble_column", {
    description = "Marble Column",
    tiles = {"marble.png"},
    drawtype = "mesh",
    mesh = "large_column.obj",
    groups = {cracky = 2, ephesus_blocks = 6, pickaxey = 1, deco_block = 1, material_stone = 1},
    sounds = sound_stone,
})

-- Column Top
minetest.register_node("ephesus:hat_column", {
    description = "Marble Column Top",
    tiles = {"marble.png"},
    drawtype = "mesh",
    mesh = "hat_column.obj",
    paramtype2 = "facedir",
    groups = {cracky = 2, ephesus_blocks = 6, pickaxey = 1, deco_block = 1, material_stone = 1},
    sounds = sound_stone,
})

-- Medium Column
minetest.register_node("ephesus:hat_medium", {
    description = "Medium Column",
    tiles = {"marble.png"},
    drawtype = "mesh",
    mesh = "medium_column.obj",
    paramtype2 = "facedir",
    groups = {cracky = 2, ephesus_blocks = 6, pickaxey = 1, deco_block = 1, material_stone = 1},
    sounds = sound_stone,
    selection_box = {type = "fixed", fixed = {{-0.25, -0.5, -0.25, 0.25, 0.5, 0.25}}},
    collision_box = {type = "fixed", fixed = {{-0.25, -0.5, -0.25, 0.25, 0.5, 0.25}}},
})

-- Medium-Column Top
minetest.register_node("ephesus:medium_column_top", {
    description = "Medium Column Top",
    tiles = {"marble.png"},
    drawtype = "mesh",
    mesh = "medium_hat_column.obj",
    paramtype2 = "facedir",
    groups = {cracky = 2, ephesus_blocks = 6, pickaxey = 1, deco_block = 1, material_stone = 1},
    sounds = sound_stone,
    selection_box = {type = "fixed", fixed = {{-0.25, -0.5, -0.25, 0.25, 0.5, 0.25}}},
    collision_box = {type = "fixed", fixed = {{-0.25, -0.5, -0.25, 0.25, 0.5, 0.25}}},
})

-- Upper Corner
minetest.register_node("ephesus:hat_angle", {
    description = "Upper Corner",
    tiles = {"marble.png"},
    drawtype = "mesh",
    mesh = "haut_angle.obj",
    paramtype2 = "facedir",
    groups = {cracky = 2, ephesus_blocks = 6, pickaxey = 1, deco_block = 1, material_stone = 1},
    sounds = sound_stone,
})

-- Top
minetest.register_node("ephesus:hat", {
    description = "Top",
    tiles = {"marble.png"},
    drawtype = "mesh",
    mesh = "haut.obj",
    paramtype2 = "facedir",
    groups = {cracky = 2, ephesus_blocks = 6, pickaxey = 1, deco_block = 1, material_stone = 1},
    sounds = sound_stone,
})

-- Pedestal
minetest.register_node("ephesus:pedestal", {
    description = "Pedestal",
    tiles = {"marble.png"},
    drawtype = "mesh",
    mesh = "socle.obj",
    groups = {cracky = 2, ephesus_blocks = 6, pickaxey = 1, deco_block = 1, material_stone = 1},
    sounds = sound_stone,
})

-- Braces
minetest.register_node("ephesus:braces", {
    description = "Braces",
    tiles = {"braces.png"},
    drawtype = "nodebox",
    paramtype = "light",
    paramtype2 = "facedir",
    groups = {cracky = 2, ephesus_blocks = 6, pickaxey = 1, deco_block = 1, material_stone = 1},
    sounds = sound_stone,
    node_box = {type = "fixed", fixed = {-0.5, -0.5, -0.25, 0.5, 0.5, 0.25}},
    selection_box = {type = "fixed", fixed = {-0.5, -0.5, -0.25, 0.5, 0.5, 0.25}},
    collision_box = {type = "fixed", fixed = {-0.5, -0.5, -0.125, 0.5, 0.5, 0.125}},
})



--- Compressions lists

-- Compress Leaves for i3 mod

if i3_mod then
    i3.compress("ephesus:cypres1", {
        replace = "cypres1",
        by = {"cypres2", "cypres3", "apricot_leaves", "olive_leaves", "fig_leaves"}
    })
end


-- Compress Bricks for i3 mod
if i3_mod then
    if minetest.registered_nodes["ephesus:clay_brick_slab"] then
        i3.compress("ephesus:clay_brick_slab", {
            replace = "clay_brick_slab",
            by = {  "marble_brick_slab","polished_marble_brick_slab","grey_marble_brick_slab", "tin_brick_slab", 
                    "marble_brick_slab_corner","polished_marble_brick_slab_corner","grey_marble_brick_slab_corner", "clay_brick_slab_corner", "tin_brick_slab_corner" }
        })
    elseif minetest.registered_nodes["ephesus:marble_brick_slab"] then
        i3.compress("ephesus:marble_brick_slab", {
            replace = "marble_brick_slab",
            by = {  "polished_marble_brick_slab","grey_marble_brick_slab", 
                    "marble_brick_slab_corner","polished_marble_brick_slab_corner","grey_marble_brick_slab_corner" }
        })
    end
end



-- Compress Others Types of Blocks for i3 mod

if i3_mod then
    i3.compress("ephesus:marble_column", {
        replace = "marble_column",
        by = {"hat_column", "hat_medium", "medium_column_top", "hat_angle", "hat", "pedestal", "braces"}
    })
end


-- Compress Special Slab for i3 mod

if i3_mod then
    for _, special_slab in pairs(full_blocks_special_slab) do
        i3.compress("ephesus:" .. special_slab[1], {
            replace = special_slab[1],
            by = {special_slab[1] .. "_special_slab", special_slab[1] .. "_special_slab_corner"}
        })
    end
end








-- Saplings and tree growth
dofile(minetest.get_modpath("ephesus") .. "/saplings.lua")
