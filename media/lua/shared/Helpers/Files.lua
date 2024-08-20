require "SSS_Utils_Shared";

SSS = SSS or {};

-- rewrite file paths

function SSS:adjustFilePath(fileName, logChanges)
    if not SSS:getSandboxVar("UseRevisedFilePaths")
    then
        return fileName;
    end

    if not string.find(fileName, "SSS_sec/")
    then
        local mappings = {
            ["SSS_permissions/"] = "SSS_misc/permissions/",
            ["SSS_player_lists/"] = "SSS_misc/player_lists/",
            ["SSS_backup/"] = "SSS_tools/backups/",
            ["SSS_misc/starterkits/"] = "SSS_misc/starter_kits/",
            ["SSS_misc/death_loadouts/"] = "SSS_death_loadouts/",
            ["SSS_misc/"] = "SSS_misc/",
            ["SSS_chat/radio_shitlist.txt"] = "SSS_chat/radio_muted_users.txt",
            ["SSS_chat/shitlist.txt"] = "SSS_chat/muted_users.txt",
            ["SSS_chat/blocked.txt"] = "SSS_chat/blocked_messages.log",
            ["SSS_chat/full.txt"] = "SSS_chat/full.log",
            ["SSS_chat/rp_names.txt"] = "SSS_chat/rp_names.log",
            ["SSS_chat/"] = "SSS_chat/",
            ["SSS_bank/shop_by_user/"] = "SSS_economy/global_shop_sales_by_user/",
            ["SSS_bank/shop_buy.txt"] = "SSS_economy/global_shop_sales.log",
            ["SSS_bank/vending_by_user/"] = "SSS_economy/vending_machine_sales_by_user/",
            ["SSS_bank/vending_buy.txt"] = "SSS_economy/vending_machine_sales.log",
            ["SSS_bank/cash_loss.txt"] = "SSS_economy/cash_money_loss.log",
            ["SSS_bank/bank_money_loss.txt"] = "SSS_economy/bank_money_loss.log",
            ["SSS_bank/wallet_creation.txt"] = "SSS_economy/wallet_creation.log",
            ["SSS_bank/exchange.txt"] = "SSS_economy/valuables_exchange.log",
            ["SSS_bank/"] = "SSS_economy/",
            ["SSS_error.log"] = "SSS_error.log",
            ["SSS_debug.log"] = "SSS_debug.log",
        }

        for oldNameContains, newNameFragment in pairs(mappings) do
            if string.find(fileName, oldNameContains, 1, true) then
                fileName = string.gsub(fileName, oldNameContains, newNameFragment)
                break -- Exit loop early if match is found
            end
        end
    end

    return fileName;
end

-- file names and writer wrapper

function SSS:replaceCommonFileNameMarkers(fileName)
    fileName = string.gsub(fileName, "%.%.", ".")

    if string.find(fileName, "{serverIP}", 1, true) then
        local serverIP = (isCoopHost() or SSS:gameIsSP()) and "local" or getServerIP()
        fileName = string.gsub(fileName, "%{serverIP%}", serverIP)
    end

    return fileName
end

function SSS:getFileNameFallback(fileName)
	local fragments = SSS:splitString(fileName, "/");
	local newFile = table.remove(fragments) or fileName;
	local badStuff = {
		"<", ">", ":", "'", "/", "\\", "|", "?", "*", "%", ".."
	};

	for i, chr in ipairs(badStuff)
	do
		newFile = string.gsub(newFile, SSS:escapeString(chr), chr == ".."
			and "."
			or "_"
		);
	end

	table.insert(fragments, newFile);

	return table.concat(fragments, "/");
end

function SSS:getFileWriter(fileName, param1, param2)
    -- includes:
    -- SSS:appendLineToFile
    -- SSS:saveItemListInFile
    -- SSS:clearFile
    -- SSS:setFileContents
    -- SSS:appendTitleToIniFile
    -- SSS:appendObjectToIniFile
    -- SSS:appendCollectionItemsToIniFile
    fileName = SSS:adjustFilePath(fileName, false);
    fileName = string.gsub(fileName, "%{timestamp%}", Calendar.getInstance():getTimeInMillis());
    fileName = SSS:replaceCommonFileNameMarkers(fileName);

	local file = getFileWriter(fileName, param1, param2);

	if not file or not file["write"]
    then
        file = getFileWriter(SSS:getFileNameFallback(fileName), param1, param2);
    end

	if not file or not file["write"]
    then
        SSS:appendLineToFile(SSS.Files["errorLog"], string.format("Unable to create file [%s]", fileName));

		return false;
	end

	return file;
end

function SSS:saveItemListInFile(fileName, listItems, kvPairs)
	local file = SSS:getFileWriter(fileName, true, false);

	if not file
	then
		return;
	end

	if kvPairs
	then
		local tmpList = {};

		for k, v in pairs(listItems)
		do
			table.insert(tmpList, tostring(k) .. "=" .. tostring(v));
		end

		listItems = tmpList;
	end

    for i, item in ipairs(listItems)
    do
        if type(item) ~= "function" and type(item) ~= "table" and item ~= nil
        then
            file:write(tostring(item) .. "\n");
        end
    end

    file:close();
end

function SSS:appendLineToFile(fileName, line)
	local file = SSS:getFileWriter(fileName, true, true);

	if not file
	then
		return;
	end

    for i, line in ipairs(SSS:tableIfNotTable(line))
    do
        if type(line) ~= "function" and type(line) ~= "table"
        then
            file:write(tostring(line) .. "\n");
        end
    end

    file:close();
end

function SSS:clearFile(fileName)
    SSS:setFileContents(fileName, nil);
end

-- convenience methods

function SSS:getItemListFromFile(fileName, addEOF)
    -- includes:
    -- SSS:listItemIsInFile
    -- SSS:getFileContents
    -- SSS:appendLineToFileIfNot
    -- SSS:appendUniqueLineToFile
    -- SSS:replaceLinesInFileByFn
    -- SSS:removeLinesInFileBy
    -- SSS:lineIsInFile
    -- SSS:readObjectsFromIniFile
    -- SSS:readObjectsFromIniFileSegmented
    fileName = SSS:adjustFilePath(fileName, false);
    fileName = SSS:replaceCommonFileNameMarkers(fileName);

	local listItems = {};
	local file = getFileReader(fileName, false);

	if file
	then
		while true
		do
			local line = file:readLine();

			if line == nil
			then
				if addEOF
				then
					table.insert(listItems, "[__EOF__]");
				end

				break;
			end

			if line ~= "" or includeEmpty
			then
				table.insert(listItems, line);
			end
		end

		file:close();
	end

	return listItems;
end

function SSS:removeLineFromFile(fileName, text)
    fileName = SSS:adjustFilePath(fileName, false);

    local listItems = {};
	local file = getFileReader(fileName, false);

	if file
	then
		while true
		do
			local line = file:readLine();

			if line == nil
			then
				break;
			end

			if line ~= text
			then
				table.insert(listItems, line);
			end
		end

		file:close();

        SSS:saveItemListInFile(fileName, listItems, false);
	end

	return listItems;
end

function SSS:listItemIsInFile(fileName, text)
	for i, line in ipairs(SSS:getItemListFromFile(fileName))
    do
        if line == text
        then
            return true;
        end
    end

	return false;
end

function SSS:getFileContents(fileName)
    return table.concat(SSS:getItemListFromFile(fileName), "");
end

function SSS:setFileContents(fileName, content)
    SSS:saveItemListInFile(fileName, {
        content
    });
end

function SSS:appendLineToFileIfNot(fileName, line, checkFn)
    for i, chkLine in ipairs(SSS:getItemListFromFile(fileName))
    do
        if checkFn(chkLine)
        then
            return false;
        end
    end

    SSS:appendLineToFile(fileName, line);

    return true;
end

function SSS:appendUniqueLineToFile(fileName, line)
    SSS:appendLineToFileIfNot(fileName, line, function(checkLine)
        return checkLine == line;
    end);
end

function SSS:replaceLinesInFileByFn(fileName, checkFn)
	local newContents = {};
	local changeDone = false;

    for i, chkLine in ipairs(SSS:getItemListFromFile(fileName))
    do
		local result = checkFn(chkLine);

        if result
        then
			chkLine = result;
            changeDone = true;
        end

		table.insert(newContents, chkLine);
    end

	if changeDone
	then
        SSS:saveItemListInFile(fileName, newContents);
	end

    return changeDone;
end

function SSS:removeLinesInFileBy(fileName, checkFn)
	local newContents = {};
    local changed = false;

    for i, chkLine in ipairs(SSS:getItemListFromFile(fileName))
    do
        if not checkFn(chkLine)
        then
			table.insert(newContents, chkLine);
        else
            changed = true;
        end
    end

    if changed
    then
	    SSS:saveItemListInFile(fileName, newContents);
    end

    return changed;
end

function SSS:lineIsInFile(fileName, searchLine)
    for i, line in ipairs(SSS:getItemListFromFile(fileName))
    do
        if line == searchLine
        then
            return true;
        end
    end

    return false;
end

-- ini stuff

function SSS:appendTitleToIniFile(file, title)
    SSS:appendLineToFile(file, "[" .. title .. "]");
end

function SSS:appendObjectToIniFile(file, kvObject, title)
    if title
    then
        SSS:appendTitleToIniFile(file, title);
    end

    for key, value in pairs(kvObject)
    do
        SSS:appendLineToFile(file, key .. "=" .. tostring(value));
    end
end

function SSS:appendCollectionItemsToIniFile(file, collection, key)
    for j = 0, collection:size() - 1
    do
        local item = collection:get(j);

        if item
        then
            SSS:appendLineToFile(file, key .. "=" .. item);
        end
    end
end

function SSS:readObjectsFromIniFile(file)
    local lines = SSS:getItemListFromFile(file, true);
    local objects = {};
    local title = nil;
    local data = {};

    for i, line in ipairs(lines)
    do
        title, data, objects = SSS:parseIniLine(lines[i], title, data, objects);
    end

    return objects;
end

function SSS:parseIniLine(line, title, data, objects)
    local titleChk = SSS:getFirstMatch(line, "^%[(.+)%]$");
    local key = SSS:getFirstMatch(line, "^(.+)%=");

    if key
    then
        local value = SSS:getFirstMatch(line, "%=(.+)$");

        if data[key] and type(data[key]) ~= "table"
        then
            data[key] = {
                data[key]
            };
        end

        if type(data[key]) == "table"
        then
            table.insert(data[key], value);
        else
            data[key] = value;
        end
    elseif titleChk
    then
        if data ~= {} and title ~= nil
        then
            data["_type"] = title;

            table.insert(objects, data);
        end

        title = titleChk;
        data = {};
    end

    return title, data, objects;
end

function SSS:readObjectsFromIniFileSegmented(file, queueVar, callback, batchSize)
    if not queueVar
    then
        callback(SSS:readObjectsFromIniFile(file));

        return true;
    end

    local lines = SSS:getItemListFromFile(file, true);
    local objects = {};
    local title = nil;
    local data = {};

    local function processBatch(from, to, tasksLeft)
        SSS:getPlayer():setHaloNote(getText("IGUI_SSS_ReadingXRemaining", tasksLeft), 119, 221, 119, 300);

        for i = from, to
        do
            title, data, objects = SSS:parseIniLine(lines[i], title, data, objects);
        end
    end

    local lineCount = #lines;
    local batchSize = batchSize or 50;
    local index = 1;

    while index - batchSize < lineCount
    do
        local nextIndex = index + batchSize;

        if nextIndex < lineCount
        then
            table.insert(queueVar, function(tasksLeft)
                processBatch(nextIndex - batchSize, nextIndex, tasksLeft);
            end);
        else
            table.insert(queueVar, function(tasksLeft)
                processBatch(index, lineCount, tasksLeft);
            end);

            break;
        end

        index = nextIndex + 1;
    end

    table.insert(queueVar, function(tasksLeft)
        SSS:getPlayer():setHaloNote(getText("IGUI_SSS_WarnLagFreeze", #objects), 119, 221, 119, 300);
    end);

    table.insert(queueVar, function()
        callback(objects);
    end);
end