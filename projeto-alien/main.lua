-- Copyright (C) [2026]  [gus_kruz]

--    This program is free software: you can redistribute it and/or modify
--    it under the terms of the GNU General Public License as published by
--    the Free Software Foundation, either version 3 of the License, or
--    (at your option) any later version.
--
--    This program is distributed in the hope that it will be useful,
--    but WITHOUT ANY WARRANTY; without even the implied warranty of
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--    GNU General Public License for more details.

--    You should have received a copy of the GNU General Public License
--    along with this program.  If not, see <https://www.gnu.org/licenses/>.

-- title:  Zorp goes to earth
-- author: Gus Kruz
-- desc:   disguise guessing game for Livre Game Jam
-- script: lua

-- lista de partes
local parts = {
    eyes = {
        { id = 260, name = "Quadrangular" },
        { id = 256, name = "Normal" },
        { id = 262, name = "Elegante" },
        { id = 258, name = "Olhos de Pato" },
        { id = 264, name = "Olhos Medonhos" },
    },
    nose = {
        { id = 324, name = "Bico de Pato" },
        { id = 320, name = "Normal" },
        { id = 322, name = "Triangulo" },
        { id = 326, name = "Bico Charmoso" },
        { id = 328, name = "Nariz Espantoso" },
    },
    mouth = {
        { id = 386, name = "Retangulo" },
        { id = 390, name = "Bico Libre" },
        { id = 384, name = ";-;" },
        { id = 388, name = "Bico de Pato" },
        { id = 392, name = "Boca do Mal" },
    }
}

-- lista de niveis
local levels = {
    {
        target = "Matematico",
        briefing = "Para que possamos conhecer a cultura humanos devemos desvendar como eles usam a linguagem mais fundamental: a matematica. Para isso voce deve ganhar a confianca do seu lider em matematica.",
        solution = { eyes = 1, nose = 3, mouth = 1 },
        success_msg = "Como seu rosto seguia a proporcao aurea, ele achou de bom tom te convidar para  sua sala!",
        fail_msg = "Ele achou sua cara mais feia que dividir por 0."
    },
    {
        target = "Galinha",
        briefing = "Agora precisamos entender a origem dos humanos. Segundo nossos pesquisadores trouxeram, as galinhas existiam antes mesmo dos humanos surgirem. Portanto voce deve se disfarcar como um colega delas.",
        solution = { eyes = 4, nose = 1, mouth = 4 },
        success_msg = "A galinha te achou tao resenha que se sentiu a vontade pra dividir os segredos dos humanos.",
        fail_msg = "O conselho do galinheiro te achou tao estranho que te baniram para sempre."
    },
    {
        target = "Fantasma",
        briefing = "Alem disso precisamos entender o que acontece quando os humanos terminam seus processos de vida, para isso voce deve se infiltrar no mundo fantasma. Se torne amigo de um poltergeist e investigue o pos-vida humano.",
        solution = {eyes = 5, nose = 5, mouth = 5},
        success_msg = "Voce ficou tao assustador que intimidou o fantasma a contar tudo sobre o plano sobrenatural!",
        fail_msg = "Voce nao engana ninguem com essa cara de gente viva, sai daqui!"
    },
    {
        target = "Programador Livre",
        briefing = "Nossos pesquisadores revelaram que alguns humanos produzem tecnologia aberta, escolha um disfarce elegante para se aproximar deles.",
        solution = { eyes = 3, nose = 4, mouth = 2 },
        success_msg = "Ele te achou tao elegante que vai dividir seus repositorios com voce.",
        fail_msg = "Ele achou que tem uma carinha de quem paga pela licenca do windows."
    }
}

local state = "TITLE" -- TITLE, BRIEFING, GAME, SUCCESS, FAIL, ENDING
local current_level = 1

local current_disguise = { eyes = 2, nose = 2, mouth = 3 }

local selected_category = 1 -- 1: olhos, 2: nariz, 3: boca, 4: confirmar
local categories = {"eyes", "nose", "mouth"}

local t = 0 -- contador de tempo

-- funcoes de estilizacao
function draw_text_centered(text, y, color)
    local width = print(text, -100, -100)
    print(text, (240 - width) / 2, y, color)
end

function print_wrap(text, x, y, max_w, color)
    local words = {}
    for word in text:gmatch("%S+") do
        table.insert(words, word)
    end
    
    local line = ""
    local cur_y = y
    for _, word in ipairs(words) do
        local test_line = line == "" and word or (line .. " " .. word)
        local w = print(test_line, -100, -100)
        if w > max_w and line ~= "" then
            print(line, x, cur_y, color)
            cur_y = cur_y + 10
            line = word
        else
            line = test_line
        end
    end
    if line ~= "" then
        print(line, x, cur_y, color)
        cur_y = cur_y + 10
    end
    return cur_y
end

function check_solution()
    local lvl = levels[current_level]
    if current_disguise.eyes == lvl.solution.eyes and
       current_disguise.nose == lvl.solution.nose and
       current_disguise.mouth == lvl.solution.mouth then
        return true
    end
    return false
end

-- papo de maquina de estados
function update_title()
    if btnp(4) then -- Botao Z
        state = "BRIEFING"
    end
end

function draw_title()
    cls(0)
    draw_text_centered("MISSION FACE DISGUISE: Zorp goes to earth", 30, 6)
    draw_text_centered("SIMULATOR ENGINE", 45, 6)
    
    -- Animacao de texto
    if (t // 30) % 2 == 0 then
        draw_text_centered("Pressione Z para iniciar", 90, 12)
    end
end

function update_briefing()
    if btnp(4) then
        state = "GAME"
    end
end

function draw_briefing()
    cls(0)
    local lvl = levels[current_level]
    draw_text_centered("ALVO: " .. lvl.target, 12, 6)
    line(20, 22, 220, 22, 6)
    
    -- Desenha briefing quebrando automaticamente as linhas
    print_wrap(lvl.briefing, 15, 32, 210, 12)
    
    if (t // 30) % 2 == 0 then
        draw_text_centered("Pressione Z para simular", 120, 12)
    end
end

function update_game()
    -- navegacao vertical
    if btnp(0) then -- cima
    				sfx(62, "F-5", 20)
        selected_category = selected_category - 1
        if selected_category < 1 then selected_category = 4 end
    end
    if btnp(1) then -- baixo
    				sfx(62, "F-5", 20)
        selected_category = selected_category + 1
        if selected_category > 4 then selected_category = 1 end
    end
    
    -- navegacao horizontal
    if selected_category <= 3 then
        local cat_name = categories[selected_category]
        local num_options = #parts[cat_name]
        
        if btnp(2) then -- esquerda
       					sfx(63, "F-4" , 20)
            current_disguise[cat_name] = current_disguise[cat_name] - 1
            if current_disguise[cat_name] < 1 then current_disguise[cat_name] = num_options end
        end
        if btnp(3) then -- direita
        				sfx(63, "F-4", 20)
            current_disguise[cat_name] = current_disguise[cat_name] + 1
            if current_disguise[cat_name] > num_options then current_disguise[cat_name] = 1 end
        end
    else
        -- clicou em confirmar
        if btnp(4) then
            if check_solution() then
                state = "SUCCESS"
            else
                state = "FAIL"
            end
        end
    end
end

function draw_game()
    cls(13) -- fundo cinza claro
    
    -- desenhar rosto do alien (base) como sprite 32x32
    -- o sprite ID 448 (linha 13) sera o rosto liso.
    spr(448, 112, 19, 0, 3, 0, 0, 4, 4)
    
    -- pegar IDs das partes
    local eye_id = parts.eyes[current_disguise.eyes].id
    local nose_id = parts.nose[current_disguise.nose].id
    local mouth_id = parts.mouth[current_disguise.mouth].id
    
    -- desenhar as sprites (transparencia=0, scale=2, width=2, height=2)
    spr(eye_id, 144, 40, 0, 2, 0, 0, 2, 2)
    spr(nose_id, 144, 60, 0, 2, 0, 0, 2, 2)
    spr(mouth_id, 144, 80, 0, 2, 0, 0, 2, 2)

    -- menu lateral
    rect(0, 0, 90, 136, 0)
    print("DISFARCE", 5, 5, 6)
    line(5, 13, 80, 13, 6)
    
    local menu_y = 25
    local colors = {12, 12, 12, 12}
    colors[selected_category] = 6 -- verde para destacar
    
    -- renderizar opcoes de menu
    print("< Olhos >", 5, menu_y, colors[1])
    print(parts.eyes[current_disguise.eyes].name, 5, menu_y + 10, 12)
    
    print("< Nariz >", 5, menu_y + 30, colors[2])
    print(parts.nose[current_disguise.nose].name, 5, menu_y + 40, 12)
    
    print("< Boca >", 5, menu_y + 60, colors[3])
    print(parts.mouth[current_disguise.mouth].name, 5, menu_y + 70, 12)
    
    print("CONFIRMAR", 5, menu_y + 95, colors[4])
    
    if selected_category == 4 and (t // 15) % 2 == 0 then
        print("CONFIRMAR", 5, menu_y + 95, 12)
    end
end

function update_success()
    if btnp(4) then
        if current_level >= #levels then
            state = "ENDING"
        else
            current_level = current_level + 1
            state = "BRIEFING"
            current_disguise = {eyes=2, nose=2, mouth=3}
        end
    end
end

function draw_success()
    cls(0)
    draw_text_centered("SUCESSO NO SIMULADOR!", 40, 6)
    
    local lvl = levels[current_level]
    local msg = lvl and lvl.success_msg or "Sucesso!"
    print_wrap(msg, 20, 60, 200, 12)
    
    if (t // 30) % 2 == 0 then
        draw_text_centered("Pressione Z para continuar", 110, 12)
    end
end

function update_fail()
    if btnp(4) then
        state = "GAME"
    end
end

function draw_fail()
    cls(0)
    draw_text_centered("FALHA NO DISFARCE!", 40, 2)
    
    local msg = levels[current_level].fail_msg
    print_wrap(msg, 20, 60, 200, 12)
    
    if (t // 30) % 2 == 0 then
        draw_text_centered("Pressione Z para tentar de novo", 110, 12)
    end
end

function update_ending()
    if btnp(4) then
        current_level = 1
        current_disguise = {eyes=2, nose=2, mouth=3}
        state = "TITLE"
    end
end

function draw_ending()
    cls(0)
    draw_text_centered("MISSAO REAL INICIADA", 15, 6)
    line(20, 25, 220, 25, 6)
    
    print_wrap("Agora que Zorp tem o treinamento necessario ele desce a Terra...", 20, 35, 200, 12)
    
    print_wrap("Alguns humanos olham esquisito... Os niveis de desconfianca estao em 100%!", 20, 65, 200, 12)
    
    if (t // 10) % 6 > 2 then
        draw_text_centered("FALHA NA MISSAO!", 95, 2)
        draw_text_centered("ZORP QUEBROU A CARA! :(", 105, 2)
    end
    
    draw_text_centered("Pressione Z para reiniciar", 125, 12)
end

-- atualizacao da maquina de estados
function TIC()
    t = t + 1
    if state == "TITLE" then
        update_title()
        draw_title()
    elseif state == "BRIEFING" then
        update_briefing()
        draw_briefing()
    elseif state == "GAME" then
        update_game()
        draw_game()
    elseif state == "SUCCESS" then
        update_success()
        draw_success()
    elseif state == "FAIL" then
        update_fail()
        draw_fail()
    elseif state == "ENDING" then
        update_ending()
        draw_ending()
    end
end

-- <SPRITES>
-- 000:00000000000000000000000000ccc0000ccccc000ccccc00ccfcccc0ccfffcc0
-- 001:000000000000000000000000000ccc0000ccccc000ccccc00ccccfcc0ccfffcc
-- 002:00004444004444444444444444eeee444eaaaae4eaaaaaaeeaaaaaaeeaffaaae
-- 003:44440000444444004444444444eeee444eaaaae4eaaaffaeeaaaffaeeaaaaaae
-- 004:00000000000000000000000000000000fffffff0f44444f0f44444f0f44f44f0
-- 005:000000000000000000000000000000000fffffff0f44444f0f44444f0f44f44f
-- 006:0000000000000000000000000fffffffffcccffffcccccffccccccffcccfcccf
-- 007:000000000000000000000000fffffff0fffcccffffcccccfffccccccfcccfccc
-- 008:0000000000000000000ccccc00ccfffc00ccfffc0ccffffc0ccffffcccfffffc
-- 009:0000000000000000ccccc000cfffcc00cfffcc00cffffcc0cffffcc0cfffffcc
-- 016:ccfffcc0ccfcccc00ccccc0000ccc00000000000000000000000000000000000
-- 017:0ccfffcc0ccccfcc00ccccc0000ccc0000000000000000000000000000000000
-- 018:eaffaaae4eaaaae444eeee440444444404444444044444440044444400044444
-- 019:eaaaaaae4eaaaae444eeee444444444044444440444444404444440044444000
-- 020:f44444f0f44444f0fffffff00000000000000000000000000000000000000000
-- 021:0f44444f0f44444f0fffffff0000000000000000000000000000000000000000
-- 022:ccfffccfccfffccfccfffccfffffffffffffffffffffffff0000000000000000
-- 023:fccfffccfccfffccfccfffccffffffffffffffffffffffff0000000000000000
-- 024:cffffffccfffffcccfffcccccccccccccccccccc0ccccccc00cccccc000ccccc
-- 025:cffffffcccfffffcccccfffcccccccccccccccccccccccc0cccccc00ccccc000
-- 066:00000000000000000000000f000000f5000000f500000f550000f5550000f555
-- 067:0000000000000000f00000005f0000005f00000055f00000555f0000555f0000
-- 068:0000000000044444004444440444444404444433044443330444333304443333
-- 069:0000000044444000444444004444444033444440333444403333444033334440
-- 070:0000000000000000000fffff0fffffffffffffffffff4444fff44f44ff444444
-- 071:0000000000000000fffff000fffffff0ffffffff4444ffff44f44fff444444ff
-- 072:0000000000000000000000000000cccc0ccccccf00ccccff00cccfff00cccfff
-- 073:000000000000000000000000cccc0000fcccccc0ffcccc00fffccc00fffccc00
-- 080:00000f0000000000000000000000000000000000000000000000000000000000
-- 081:00f0000000000000000000000000000000000000000000000000000000000000
-- 082:000f5555000f555500f555550f55555500ffffff000000000000000000000000
-- 083:5555f0005555f00055555f00555555f0ffffff00000000000000000000000000
-- 084:44433f334433333344f33333044fffff00044444000000000000000000000000
-- 085:33f334443333334433333f44fffff44044444000000000000000000000000000
-- 086:ff4f44440f44ffff0ff44444000fffff00000000000000000000000000000000
-- 087:4444f4ffffff44f044444f00fffff00000000000000000000000000000000000
-- 088:00cccffc00cccccc000ccccc0000000000000000000000000000000000000000
-- 089:cffccc00cccccc00ccccc0000000000000000000000000000000000000000000
-- 130:000000000000000000000000000000000000000000ffffff00f9999900f99999
-- 131:0000000000000000000000000000000000000000ffffff0099999f0099999f00
-- 132:0400000004300000044333330444333300444444000044440000000000000000
-- 133:0000004000000340333334403333444044444400444400000000000000000000
-- 134:0f3000000ff3333300ff33330000ffff00000000000000000000000000000000
-- 135:000003f033333ff03333ff00ffff000000000000000000000000000000000000
-- 136:000ccccc000cccff000ccfff000cffff000ccfff000ccfff0000cfff0000cfff
-- 137:ccccc000ffccc000fffcc000ffffc000fffcc000fffcc000fffc0000fffc0000
-- 144:00000000000fffff000000000000000000000000000000000000000000000000
-- 145:00000000fffff000000000000000000000000000000000000000000000000000
-- 146:00f9999900f9ffff00f9999900ffffff00000000000000000000000000000000
-- 147:99999f00ffff9f0099999f00ffffff0000000000000000000000000000000000
-- 152:0000ccff00000cff00000ccf000000cf0000000c000000000000000000000000
-- 153:ffcc0000ffc00000fcc00000fc000000c0000000000000000000000000000000
-- 192:0000000000000000000000000000000000000000000000000000000f000000f6
-- 193:0000000000000fff000ff66600f666660f666666f66666666666666666666666
-- 194:00000000fff00000666ff00066666f00666666f06666666f6666666666666666
-- 195:000000000000000000000000000000000000000000000000f00000006f000000
-- 208:00000f6600000f660000f666000f6666000f6666000f6666000f6666000f6666
-- 209:6666666666666666666666666666666666666666666666666666666666666666
-- 210:6666666666666666666666666666666666666666666666666666666666666666
-- 211:66f0000066f00000666f00006666f0006666f0006666f0006666f0006666f000
-- 224:0000f6660000f6660000f66600000f6600000f66000000f6000000f60000000f
-- 225:6666666666666666666666666666666666666666666666666666666666666666
-- 226:6666666666666666666666666666666666666666666666666666666666666666
-- 227:666f0000666f0000666f000066f0000066f000006f0000006f000000f0000000
-- 240:0000000f00000000000000000000000000000000000000000000000000000000
-- 241:66666666f6666666f6666666f66666660f66666600ff66660000ffff00000000
-- 242:666666666666666f6666666f6666666f666666f06666ff00ffff000000000000
-- 243:f000000000000000000000000000000000000000000000000000000000000000
-- </SPRITES>

-- <WAVES>
-- 000:00000020000022220000414000000000
-- </WAVES>

-- <SFX>
-- 000:708f7080708070807080708070807080708070807080708070807080708070807080708070807080708070807080708070807080708070807080f080437000000000
-- 062:9000902090309040905090709080908090909090909090a090a090b090b090b090b090b090b090b090b090b090b090b090b090b090b090b090b0f0b0435000000000
-- 063:a003a005a012a010a021a020a03fa041a053a062a071a070a082a093a091a0a6a0a7a0b1a0b3a0c4a0d2a0d2a0e1a0e2a0f6a0f2a0f3a0f5a0f4f0f5325000000000
-- </SFX>

-- <PATTERNS>
-- 000:500014000000000010700012000010000010600012000010000010000010800012000010000010000010500012000010000010600014000010000010000010000010600014900014000010000010600014000010800012000010700014000000000010000000700014000010900014000010000010000010600012000010700012000010500010000010000010000010700014000010600012000000000010000000600012000010800012000000000010000010600014800012000010600012
-- </PATTERNS>

-- <TRACKS>
-- 000:1c0340100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 001:100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000ce0000
-- </TRACKS>

-- <PALETTE>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE>

