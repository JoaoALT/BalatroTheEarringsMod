local blind = {
    name = "Bea the bunny",
    pos = { x = 0, y = 4 },
    dollars = 5, 
    mult = 2, 
    vars = {}, 
    debuff = {},
    boss = {min = 1, max = 10},
    boss_colour = HEX('FC9D9D'),
    loc_txt = {}
}

-- 1. Store the original vanilla defeat function
local blind_defeat_ref = Blind.defeat

-- 2. Override the global Blind.defeat
function Blind.defeat(self, kwargs)
    -- 3. Check if the defeated blind is Bea
    local is_bea = (self.name == "bl_earring_bea_the_bunny") or 
                   (self.name == "Bea the bunny") or 
                   (self.config and self.config.blind and self.config.blind.key == "bl_earring_bea_the_bunny")

    if is_bea then
        local current_chips = type(G.GAME.chips) == "table" and G.GAME.chips:to_number() or G.GAME.chips
        local bonus_dollars = math.floor(current_chips / 1000)
        
        if bonus_dollars > 0 then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    ease_dollars(bonus_dollars)
                    play_sound('coin1')
                    attention_text({
                        text = 'Bea paws you +$'..tostring(bonus_dollars),
                        scale = 1.3, 
                        hold = 1.4,
                        major = self,
                        colour = G.C.MONEY
                    })
                    return true
                end
            }))
        end
    end
    
    -- 4. Execute the original function so the game can continue to the shop
    return blind_defeat_ref(self, kwargs)
end

return blind
