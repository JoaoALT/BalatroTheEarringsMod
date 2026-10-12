local blind = {
    name = "Jackie Black",
    pos = { x = 0, y = 3 },
    dollars = 7, 
    mult = 2, 
    vars = {}, 
    debuff = {},
    boss = {min = 5, max = 10},
    boss_colour = HEX('0F0E0E'),
    loc_txt = {}
}

blind.press_play = function(self)
    -- Apply dark seal to 20% of played spades/clubs
    local dominated = false
    for _, v in ipairs(G.hand.highlighted) do
        if v:is_suit('Spades') or v:is_suit('Clubs') then
            if math.random() <= 0.2 then
                v:set_seal('earring_dark', true, true)
                dominated = true
            end
        end
    end
    if dominated then
        G.GAME.blind:wiggle()
    end
end

blind.debuff_card = function(self, card, from_blind)
    return false
end

blind.drawn_to_hand = function(self)
end

blind.disable = function(self)
end

return blind
