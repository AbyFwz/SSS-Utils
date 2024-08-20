require "SSS_Utils_Client"

-- Function to create a titlebar button
function SSS:createTitlebarButton(panel, buttonName, title, handler, posRefButton, positionToRef)
    -- Get the title bar height
    local th = panel:titleBarHeight()
    -- Get the X position of the reference button
    local xPos = panel[posRefButton]:getX()

    -- Adjust X position based on the reference position
    if not positionToRef or positionToRef == "right" then
        xPos = xPos + panel[posRefButton]:getWidth() + 5
    elseif positionToRef == "left" then
        xPos = xPos - panel[posRefButton]:getWidth() - 5
    end

    -- Create the button
    panel[buttonName] = ISButton:new(xPos, 0, th, th, title, panel, handler)
    panel[buttonName].anchorRight = false
    panel[buttonName].anchorLeft = true
    panel[buttonName]:initialise()
    panel[buttonName].borderColor.a = 0.0
    panel[buttonName].backgroundColor.a = 0
    panel[buttonName].backgroundColorMouseOver.a = 0
    -- panel[buttonName]:setImage(getTexture("media/ui/Panel_Icon_Gear.png"))
    panel[buttonName]:setUIName("PAChat_" .. buttonName)

    -- Add the button to the panel
    panel:addChild(panel[buttonName])

    -- Ensure the button is visible
    panel[buttonName]:setVisible(true)
end
