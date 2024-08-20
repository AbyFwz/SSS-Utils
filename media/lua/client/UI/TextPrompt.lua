require "SSS_Base_Client"

-- Function to show a text prompt
function SSS:showTextPrompt(text, defaultValue, btnFn, minLength)
    -- Create the modal text box
    local modal = ISTextBox:new(
        (getCore():getScreenWidth() / 2) - 130,
        (getCore():getScreenHeight() / 2) - 60,
        260, 120,
        text,
        tostring(defaultValue),
        self,
        function(self, button)
            if button.internal == "OK" then
                if btnFn then
                    local text = button.parent.entry:getText()

                    -- Check if the text meets the minimum length requirement
                    if not minLength or (minLength > 0 and string.len(text) >= minLength) then
                        btnFn(text)
                    else
                        SSS:say(getText("IGUI_SSS_ErrTextTooShort"))
                    end
                end
            end
        end,
        nil
    )

    -- Initialize and add modal to UI manager
    modal:initialise()
    modal:addToUIManager()

    return modal
end
