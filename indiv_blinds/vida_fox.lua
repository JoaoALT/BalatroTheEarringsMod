local blind = {
    name = "Vida Fox",
    pos = { x = 0, y = 2 },
    dollars = 8, 
    mult = 4, 
    vars = {}, 
    debuff = {},
    boss = {min = 8, max = 10, showdown=true},
    boss_colour = HEX('FF0D0D'),
    loc_txt = {
        name = "Vida Fox",
        text = { "+0.005x blind requirements", "every second"}
    }
}

blind.update = function(self, dt)
    if G.GAME.blind and not G.GAME.blind.disabled then
        -- Changed x factor to a lower one. 0.005
        local scale_factor = (1 / 200) * dt * (G.SETTINGS.GAMESPEED or 1)
        
        -- To avoid getting stuck due to floating point and small numbers, we don't floor it immediately.
        -- In Balatro, G.GAME.blind.chips can be a float.
        G.GAME.blind.chips = G.GAME.blind.chips + (G.GAME.blind.chips * scale_factor)
        G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
    end
end

return blind
