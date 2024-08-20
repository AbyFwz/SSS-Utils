require "SSS_Utils_Client"

-- Function to show a number prompt
function SSS:showNumberPrompt(text, defaultValue, btnFn, minValue, maxValue)
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
                local number = tonumber(button.parent.entry:getText())

                -- Ensure the number is within the specified range
                if minValue and number < minValue then
                    number = minValue
                end

                if maxValue and number > maxValue then
                    number = maxValue
                end

                -- Call the button function with the number
                if btnFn then
                    btnFn(number)
                end
            end
        end,
        nil
    )

    -- Initialize and add modal to UI manager
    modal:initialise()
    modal:addToUIManager()
    modal:setOnlyNumbers(true)

    return modal
end
