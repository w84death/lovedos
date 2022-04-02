----------------------------------------------
-- VORTEX 3D
-- Powered by DOS/LOVE GAME ENGINE
--
-- Krzysztof Krystian Jankowski
-- 3.2022 P1X // http://dos.p1x.in
----------------------------------------------

version = 06
game_name = "Vortex3D"

-- CHANGE LOG
--
-- 06 - graphics in menu
--    - cocpit with fake instruments
--    - new terrain
-- 05 - forked for Vortex3D game
-- 04 - directory cleanup
--    - graphics added
--    - working intro/outro
-- 03 - option to show/hide global fps
--    - single/multi game selector
-- 02 - game loop /w keyboard bindings
-- 01 - initial helper files and states

-- REQUIRES
require("req/globals")
require("req/fps")
require("req/flow")
require("req/ui")
require("req/intro")
require("req/menu")
require("req/keyboard")
require("req/game")
require("req/quit")


-- LOVE
function love.load()
  gif_p1x = love.graphics.newImage("gfx/p1x.gif")
  gif_bg_light = love.graphics.newImage("gfx/bg_light.gif")  
  gif_bg_dark = love.graphics.newImage("gfx/bg_dark.gif")  
  gif_kkj = love.graphics.newImage("gfx/kkj.gif")
  gif_cessna = love.graphics.newImage("gfx/cessna.gif")
end

function love.draw()
  drawState()
  drawFPS()
end

function love.update(dt)
  tickState(dt)
  tickFPS(dt)
end
