state_intro = 0
state_menu = 1
state_game = 2
state_win = 3
state_lose = 4
state_quit = 5

show_fps = false
game_demo = 0
game_play = 1
game_mode = game_demo

local state_first = state_menu
local state_last = state_lose

state = state_intro

function stateNext(new_state)
  state = state + 1
  if state > state_last then 
    state = state_first  
    resetMenu()
  end
end

function isState(test_state)
  return test_state == state
end

function drawState()
  if isState(state_intro) then
    drawIntro()
  end
  if isState(state_quit) then
    drawQuit()
  end
  if isState(state_menu) then
    drawMenu()
  end
  if isState(state_game) then
    drawGame()
  end
  if isState(state_win) then
    drawGameOver(true)
  end
  if isState(state_lose) then
    drawGameOver(false)
  end
end

function tickState(dt)
  if isState(state_intro) then
    tickIntro(dt)
  end
  if isState(state_game) then
    tickGame(dt)
  end
  if isState(state_quit) then
    tickQuit(dt)
  end                  
end
