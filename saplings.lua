-- Ephesus saplings and tree growth
-- Same approach as default / mcl_core: a plantlike sapling node with a node timer;
-- when the timer fires (and light/space allow) the sapling is replaced by a tree.
-- Trees are generated procedurally, so no schematic (.mts) files are required.

local S = "ephesus:"

local function is_replaceable(pos)
    local name = minetest.get_node(pos).name
    if name == "air" or name == "ignore" then
        return true
    end
    local def = minetest.registered_nodes[name]
    if not def then return false end
    return def.buildable_to
        or minetest.get_item_group(name, "leaves") > 0
        or minetest.get_item_group(name, "sapling") > 0
end

local function can_grow(pos, height)
    local below = {x = pos.x, y = pos.y - 1, z = pos.z}
    local g = function(n) return minetest.get_item_group(minetest.get_node(below).name, n) end
    if g("soil") == 0 and g("dirt") == 0 and g("grass_block") == 0 and g("sand") == 0 then
        return false
    end
    for y = 0, height do
        if not is_replaceable({x = pos.x, y = pos.y + y, z = pos.z}) then
            return false
        end
    end
    return true
end

local function put(pos, name, only_replaceable)
    if is_replaceable(pos) then
        minetest.set_node(pos, {name = name})
    end
end

local function trunk(pos, name, h)
    for y = 0, h - 1 do
        minetest.set_node({x = pos.x, y = pos.y + y, z = pos.z}, {name = name})
    end
end

-- Fills an ellipsoid of leaves. Random gaps make the crown look natural.
local function crown(center, rx, ry, rz, leaf, gap)
    for dx = -rx, rx do
    for dy = -ry, ry do
    for dz = -rz, rz do
        local d = (dx * dx) / (rx * rx + 0.5) + (dy * dy) / (ry * ry + 0.5) + (dz * dz) / (rz * rz + 0.5)
        if d <= 1 and math.random() > (gap or 0) then
            put({x = center.x + dx, y = center.y + dy, z = center.z + dz}, leaf)
        end
    end
    end
    end
end

local tree_defs = {
    olive = {
        height = function() return math.random(4, 5) end,
        grow = function(pos, h)
            trunk(pos, S .. "olive_trunk", h)
            local top = {x = pos.x, y = pos.y + h - 1, z = pos.z}
            crown({x = top.x, y = top.y + 1, z = top.z}, 3, 2, 3, S .. "olive_leaves", 0.15)
            crown({x = top.x + 1, y = top.y, z = top.z}, 2, 1, 2, S .. "olive_leaves", 0.25)
            crown({x = top.x - 1, y = top.y, z = top.z}, 2, 1, 2, S .. "olive_leaves", 0.25)
        end,
    },
    apricot = {
        height = function() return math.random(5, 6) end,
        grow = function(pos, h)
            trunk(pos, S .. "apricot_trunk", h)
            crown({x = pos.x, y = pos.y + h, z = pos.z}, 3, 3, 3, S .. "apricot_leaves", 0.1)
        end,
    },
    cypress = {
        height = function() return math.random(7, 10) end,
        grow = function(pos, h)
            trunk(pos, S .. "cypress_trunk", h - 1)
            local leaves = {S .. "cypres1", S .. "cypres2", S .. "cypres3"}
            -- narrow, flame-shaped crown: widest in the lower third, pointed top
            local start = 2
            for y = start, h do
                local t = (y - start) / (h - start)
                local r = (t < 0.35) and 1 + math.floor(t * 4) or (t < 0.75 and 1 or 0)
                if r > 1 then r = 1 end
                for dx = -r, r do
                for dz = -r, r do
                    if r == 0 or (math.abs(dx) + math.abs(dz) <= r + (t < 0.5 and 1 or 0)) then
                        put({x = pos.x + dx, y = pos.y + y, z = pos.z + dz}, leaves[math.random(1, 3)])
                    end
                end
                end
            end
        end,
    },
    fig = {
        height = function() return math.random(3, 4) end,
        grow = function(pos, h)
            trunk(pos, S .. "fig_trunk", h)
            crown({x = pos.x, y = pos.y + h, z = pos.z}, 4, 2, 4, S .. "fig_leaves", 0.12)
        end,
    },
}

local descriptions = {
    olive = "Olive Sapling",
    apricot = "Apricot Sapling",
    cypress = "Cypress Sapling",
    fig = "Fig Sapling",
}

function ephesus_grow_tree(pos, kind)
    local def = tree_defs[kind]
    if not def then return false end
    local h = def.height()
    if not can_grow(pos, h + 3) then
        return false
    end
    minetest.remove_node(pos)
    def.grow(pos, h)
    return true
end

local sound_plant = nil
if minetest.get_modpath("default") and default.node_sound_leaves_defaults then
    sound_plant = default.node_sound_leaves_defaults()
elseif minetest.get_modpath("mcl_sounds") and mcl_sounds.node_sound_leaves_defaults then
    sound_plant = mcl_sounds.node_sound_leaves_defaults()
end

for kind, desc in pairs(descriptions) do
    local name = S .. kind .. "_sapling"

    minetest.register_node(name, {
        description = desc,
        drawtype = "plantlike",
        tiles = {kind .. "_sapling.png"},
        inventory_image = kind .. "_sapling.png",
        wield_image = kind .. "_sapling.png",
        paramtype = "light",
        sunlight_propagates = true,
        walkable = false,
        selection_box = {type = "fixed", fixed = {-4 / 16, -0.5, -4 / 16, 4 / 16, 7 / 16, 4 / 16}},
        groups = {
            snappy = 2, dig_immediate = 3, flammable = 2, attached_node = 1,
            sapling = 1, plant = 1, dig_by_water = 1, destroy_by_lava_flow = 1,
            deco_block = 1, handy = 1, ephesus = 1,
        },
        sounds = sound_plant,

        on_construct = function(pos)
            minetest.get_node_timer(pos):start(math.random(300, 1500))
        end,

        on_timer = function(pos)
            local light = minetest.get_node_light(pos)
            if not light or light < 9 then
                return true -- too dark, retry later
            end
            if not ephesus_grow_tree(pos, kind) then
                return true -- blocked or bad soil, retry later
            end
            return false
        end,

        on_place = function(itemstack, placer, pointed_thing)
            itemstack = minetest.item_place(itemstack, placer, pointed_thing)
            return itemstack
        end,
    })

    -- Saplings drop from the matching leaves in the wild, but crafting is also offered.
end

-- Bone meal support (default / farming / VoxeLibre-style hook, if available)
if minetest.get_modpath("mcl_bone_meal") and mcl_bone_meal and mcl_bone_meal.register_on_bone_meal_apply then
    mcl_bone_meal.register_on_bone_meal_apply(function(pos)
        local n = minetest.get_node(pos).name
        for kind in pairs(descriptions) do
            if n == S .. kind .. "_sapling" then
                return ephesus_grow_tree(pos, kind)
            end
        end
    end)
end

-- Leaves drop saplings (1/20) when dug / decayed
local leaf_to_kind = {
    olive_leaves = "olive",
    apricot_leaves = "apricot",
    fig_leaves = "fig",
    cypres1 = "cypress",
    cypres2 = "cypress",
    cypres3 = "cypress",
}
for leaf, kind in pairs(leaf_to_kind) do
    minetest.override_item(S .. leaf, {
        drop = {
            max_items = 1,
            items = {
                {items = {S .. kind .. "_sapling"}, rarity = 20},
                {items = {S .. leaf}},
            },
        },
    })
end

-- Leaf decay when no trunk is nearby (MTG)
if minetest.get_modpath("default") and default.register_leafdecay then
    default.register_leafdecay({
        trunks = {S .. "olive_trunk", S .. "apricot_trunk", S .. "cypress_trunk", S .. "fig_trunk"},
        leaves = {S .. "olive_leaves", S .. "apricot_leaves", S .. "fig_leaves",
                  S .. "cypres1", S .. "cypres2", S .. "cypres3"},
        radius = 3,
    })
end

-- Natural mapgen-free alternative: craft saplings from leaves isn't needed; creative gives them.
