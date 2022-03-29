function love.keypressed(key)
  if key == "escape" then
    if state >= state_menu and state < state_quit then
      resetMenu()
      state = state_menu
    end
  
  elseif state == state_intro then
    if key == "space" then
      stateNext()
    end
  
  elseif state == state_menu then
    if key == "w" then
      menuUp()  
    end
    if key == "s" then
      menuDown()  
    end
    if key == "return" then
      menuExecute()  
    end
  end  
  
end
