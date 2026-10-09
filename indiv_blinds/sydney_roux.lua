local blind = {
    name = "Sydney Roux",
    pos = { x = 0, y = 0 },
    dollars = 8, 
    mult = 4, 
    vars = {}, 
    debuff = {},
    boss = {min = 1, max = 10},
    boss_colour = HEX('DE0B43'),
    loc_txt = {}
}

blind.press_play = function(self)
    local red_cards_in_hand = {}
    for _, v in ipairs(G.hand.cards) do
        if v:is_suit('Hearts') or v:is_suit('Diamonds') then
            red_cards_in_hand[#red_cards_in_hand+1] = v
        end
    end

    if #red_cards_in_hand > 0 then
        G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.2, func = function()
            local destroyed_any = false
            for i = 1, #red_cards_in_hand do
                if pseudorandom('sydney') < 0.25 then
                    red_cards_in_hand[i]:start_dissolve()
                    destroyed_any = true
                end
            end
            if destroyed_any then
                G.GAME.blind.triggered = true
            end
        return true end }))
        return true
    end
end

return blind
