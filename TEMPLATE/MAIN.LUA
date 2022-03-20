----------------------------------------------
-- DOS/LOVE GAME ENGINE
--
-- Krzysztof Krystian Jankowski
-- 3.2022 P1X // http://dos.p1x.in
----------------------------------------------

version = 02
game_name = "Sample Game"

-- HISTORY
-- 
-- 02 - game loop /w keyboard bindings
-- 01 - initial helper files and states

-- REQUIRES
require("globals")
require("flow")
require("ui")
require("intro")
require("menu")
require("keyboard")
require("game")

-- LOVE
function love.load()
  
end

function love.draw()
  drawState()
end

function love.update(dt)
  tickState(dt)
end

