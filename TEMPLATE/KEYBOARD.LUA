function love.keypressed(key)
  if key == "escape" then
    if state > state_menu then
      state = state_menu
    else
      love.event.quit()
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
    if key == "space" then
      menuExecute()  
    end
  elseif state >= state_game then
    -- DELETE THIS
    if key == "space" then
      stateNext()
    end
  end
    
  
end