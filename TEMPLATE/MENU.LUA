-- MAIN MENU
local menu_start = 0
local menu_options = 1
local menu_quit = 2

-- OPTIONS MENU
local menu_sound = 0
local menu_back = 1

-- MENU SETTINGS
local menu_last_position = menu_quit
local menu_position = menu_start
local menu_x, menu_y = 24, 64

-- MENU STATES
local menu_state_main = 0
local menu_state_options = 1
local menu_state = menu_state_main

function drawMenu()
  drawHeader("Welcome to the DOS/LOVE Game Engine")
  
  if menu_state == menu_state_main then
    love.graphics.print("NEW GAME", menu_x,menu_y)
    love.graphics.print("OPTIONS", menu_x,menu_y+8)  
    love.graphics.print("QUIT", menu_x,menu_y+16)
  end
  
  if menu_state == menu_state_options then
    love.graphics.print("SOUND ENABLED", menu_x,menu_y)
    love.graphics.print("BACK TO MENU", menu_x,menu_y+8)
  end
  
  love.graphics.print("->", menu_x-12, menu_y+menu_position*8)
  drawFooter("Version "..version)
end

function menuUp()
  menu_position = menu_position - 1
  if menu_position < 0 then
    menu_position = menu_last_position
  end
end

function menuDown()
  menu_position = menu_position + 1
  if menu_position > menu_last_position then
    menu_position = 0
  end  
end

function menuExecute()
  if menu_state == menu_state_main then
    if menu_position == menu_start then
      state = state_game
    end	
    if menu_position == menu_options then
      showOptions()
    end
    if menu_position == menu_quit then
      state = state_quit
    end
  end
  
  if menu_state == menu_state_options then
    if menu_position == menu_back then
      showMainMenu()
    end
  end
end

function showOptions()
  menu_position = menu_sound
  menu_state = menu_state_options
  menu_last_position = menu_back
end

function showMainMenu()
  menu_position = menu_start
  menu_state = menu_state_main
  menu_last_position = menu_quit
end