local blind = {
    name = "Léo Amarilo",
    pos = { x = 0, y = 1 },
    dollars = 5, 
    mult = 2, 
    vars = {}, 
    debuff = {},
    boss = {min = 3, max = 10},
    boss_colour = HEX('F5C30F'),
    loc_txt = {}
}

blind.recalc_debuff = function(self, card, from_blind)
    if card.area ~= G.jokers and card.config.center ~= G.P_CENTERS.c_base then
        return true
    end
    return false
end

return blind
