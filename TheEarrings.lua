--- STEAMODDED HEADER
--- MOD_NAME: The Earrings
--- MOD_ID: Earrings
--- PREFIX: earring
--- MOD_AUTHOR: [MinCout]
--- MOD_DESCRIPTION: A pack of Blinds featuring The Earrings characters by MinCout
--- DISPLAY_NAME: The Earrings
--- BADGE_COLOUR: EDA9D3
--- VERSION: 1.0.0

local blind_list = {
    "sydney_roux",
    "leo_amarilo",
    "vida_fox",
    "jackie_black",
    "bea_the_bunny",
}

-- Set of earring blind keys for fast lookup
local earring_blind_keys = {}
for _, v in ipairs(blind_list) do
    earring_blind_keys["bl_earring_" .. v] = true
end

local mod_path = SMODS.current_mod.path

SMODS.Atlas({ 
    key = "TheEarrings", 
    atlas_table = "ANIMATION_ATLAS", 
    path = "EarringsBlindsmod.png", 
    px = 34, 
    py = 34, 
    frames = 21 
})

SMODS.Atlas({
    key = "modicon",
    path = "earrings_icon.png",
    px = 34,
    py = 34
})

SMODS.Atlas({
    key = "blackseal_icon",
    path = "blackseal_icon.png",
    px = 71,
    py = 95
})

-- Deck back atlas
SMODS.Atlas({
    key = "earrings_deck_atlas",
    path = "earrings_deck.png",
    px = 71,
    py = 95
})

-- Sound atlas
SMODS.Sound({
    key = "sydney_slash",
    path = "sydney_slash.wav",
})

SMODS.Sound({
    key = "jackie_click",
    path = "jackie_click.wav",
})

for k, v in ipairs(blind_list) do
    local blind = NFS.load(mod_path .. "indiv_blinds/" .. v .. ".lua")()

    if not blind then
        sendErrorMessage("[Earrings] Cannot find blind with shorthand: " .. v)
    else
        blind.key = v
        blind.atlas = "TheEarrings"

        -- Add in_pool: always available when earrings deck is active
        local orig_in_pool = blind.in_pool
        blind.in_pool = function(self)
            if G.GAME and G.GAME.modifiers and G.GAME.modifiers.earrings_deck then
                return true
            end
            if orig_in_pool then
                return orig_in_pool(self)
            end
            return true
        end

        local blind_obj = SMODS.Blind(blind)

        for k_, v_ in pairs(blind) do
            if type(v_) == 'function' then
                blind_obj[k_] = blind[k_]
            end
        end
    end
end

-- The Earrings Deck: only earring blinds appear as bosses
SMODS.Back({
    key = "earrings_deck",
    name = "Earrings Deck",
    atlas = "earrings_deck_atlas",
    pos = { x = 0, y = 0 },
    config = {},
    loc_txt = {
        name = "Earrings Deck",
        text = {
            "Only {C:attention}Earrings{} bosses",
            "appear as {C:attention}Boss Blinds{}",
        }
    },
    apply = function(self)
        G.GAME.modifiers.earrings_deck = true
    end,
})

-- Hook SMODS.add_to_pool to filter out non-earring boss blinds when the deck is active
local orig_add_to_pool = SMODS.add_to_pool
function SMODS.add_to_pool(prototype_obj, args)
    if G.GAME and G.GAME.modifiers and G.GAME.modifiers.earrings_deck then
        -- Only filter boss blinds (objects with a .boss field), leave everything else alone
        if prototype_obj and prototype_obj.boss then
            local key = prototype_obj.key
            if key and not earring_blind_keys[key] then
                return false
            end
        end
    end
    return orig_add_to_pool(prototype_obj, args)
end

if SMODS.Seal then
    SMODS.Seal {
        key = 'dark',
        atlas = 'blackseal_icon',
        pos = {x=0, y=0},
        badge_colour = HEX('202020'),
        loc_txt = {
            name = 'Dark Seal',
            text = {
                "Decreases level of",
                "played poker hand"
            }
        },
        calculate = function(self, card, context)
            if context.main_scoring and context.cardarea == G.play then
                local hand_name = context.scoring_name
                if G.GAME.hands[hand_name] and G.GAME.hands[hand_name].level > 1 then
                    level_up_hand(card, hand_name, nil, -1)
                    return {
                        message = 'Level Down!',
                        colour = HEX('202020')
                    }
                end
            end
        end
    }
end

sendInfoMessage("Loaded Earrings mod")

local apply_to_runref = Back.apply_to_run
function Back.apply_to_run(self)
    apply_to_runref(self)
end

-- Hook for Vida Fox and any other blind that defines 'update'
local game_update_ref = Game.update
function Game.update(self, dt)
    game_update_ref(self, dt)
    if G.GAME and G.GAME.blind and G.GAME.blind.config and G.GAME.blind.config.blind and G.GAME.blind.config.blind.key then
        local blind_key = G.GAME.blind.config.blind.key
        local blind_obj = G.P_BLINDS[blind_key]
        if blind_obj and blind_obj.update and not G.GAME.blind.disabled then
            -- Make sure the blind size hasn't been surpassed yet, or if it has, we can still scale it?
            -- Cryptid's The Clock stops scaling if you have more chips than the blind.
            local chips = to_big and to_big(G.GAME.chips) or G.GAME.chips
            local blind_chips = to_big and to_big(G.GAME.blind.chips) or G.GAME.blind.chips
            if chips < blind_chips and not G.SETTINGS.paused then
                blind_obj:update(dt)
            end
        end
    end
end