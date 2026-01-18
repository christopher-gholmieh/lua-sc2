--< Written by: Christopher Gholmieh
--< Variables (Assignment):

--< Utilities:
local Logger = require("source.utilities.logger")

--< Utilities:
local function is_windows_operating_system()
    return package.config:sub(1, 1) == "\\"
end

local function is_absolute_path(path)
    --< Windows:
    if is_windows_operating_system() then
        return path:match("^%a:[/\\]") or path:match("^[/\\][/\\]")
    end

    --< UNIX:
    return path:sub(1, 1) == "/"
end

--< Functions:
local function path_join(...)
    --< Variables (Assignment):
    --< Separator:
    local separator = package.config:sub(1, 1)

    --< Logic:
    return table.concat({ ... }, separator)
end

local function normalize(path)
    return (path:gsub("\\", "/"))
end

local function clean_path(path)
    --< Variables (Assignment):
    --< Cleaned:
    local cleaned_path = normalize(path)

    --< Logic:
    cleaned_path = cleaned_path:gsub("/%./", "/")
    cleaned_path = cleaned_path:gsub("/%.$", "")

    --< Cleaned:
    return cleaned_path
end

local function get_current_working_directory()
    --< Variables (Assignment):
    --< Command:
    local command = is_windows_operating_system() and "cmd /c cd" or "pwd"

    --< Process:
    local process = io.popen(command)

    if not process then
        return "."
    end

    --< Line:
    local line = process:read("*l")

    --< Process:
    process:close()

    --< Validation:
    if not line or line == "" then
        return "."
    end

    --< Line:
    return line
end

local function to_absolute(path)
    if is_absolute_path(path) then
        return clean_path(path)
    end

    return clean_path(path_join(get_current_working_directory(), path))
end

local function mkdir_path(path)
    if is_windows_operating_system() then
        --< Windows:
        os.execute('mkdir "' .. path .. '" >nul 2>nul')
    else
        --< UNIX:
        os.execute('mkdir -p "' .. path .. '" >/dev/null 2>&1')
    end
end

local function list_files(root)
    --< Variables (Assignment):
    --< Command:
    local command

    --< Logic:
    if is_windows_operating_system() then
        command = string.format('cmd /c dir /b /s "%s"', root)
    else
        command = string.format('find "%s" -type f', root)
    end

    --< Process:
    local process = io.popen(command)

    if not process then
        return {}
    end

    --< Files:
    local files = {}

    --< Logic:
    for line in process:lines() do
        --< Variables (Assignment):
        --< Line:
        line = line:gsub("\r$", "")

        --< Logic:
        table.insert(files, line)
    end

    --< Process:
    process:close()

    --< Files:
    return files
end

local function read_file(path, binary)
    --< Variables (Assignment):
    --< Mode:
    local mode = binary and "rb" or "r"

    --< File:
    local file = assert(io.open(path, mode))

    --< Data:
    local data = assert(file:read("*a"))

    --< File:
    file:close()

    --< Data:
    return data
end

local function quote_long_string(value)
    --< Variables (Assignment):
    --< Equal:
    local equal = 0

    --< Logic:
    while value:find("%]" .. string.rep("=", equal) .. "%]") do
        equal = equal + 1
    end

    --< Logic:
    return "[" .. string.rep("=", equal) .. "[" .. value .. "]" .. string.rep("=", equal) .. "]"
end


--< Variables (Assignment):
--< Root:
local project_root = arg[1] or "."
local project_root_absolute = to_absolute(project_root)

--< Output:
local output_path = arg[2] or path_join(project_root, "distribution", "bundle.lua")

--< Protobuf:
local protobuf_directory = path_join(project_root_absolute, "s2clientprotocol")

--< Source:
local source_directory = path_join(project_root_absolute, "source")

--< Entry:
local entry_path = path_join(project_root_absolute, "main.lua")

--< Program:
mkdir_path(path_join(project_root, "distribution"))


--< Variables (Assignment):
--< Modules:
local modules = {}

--< Assets:
local assets = {}

--< Logic:
do
    --< Variables (Assignment):
    --< Source:
    local source_directory_normalized = normalize(source_directory)

    if source_directory_normalized:sub(-1) ~= "/" then
        source_directory_normalized = source_directory_normalized .. "/"
    end

    --< Logic:
    for _, file in ipairs(list_files(source_directory)) do
        if file:sub(-4):lower() == ".lua" then
            --< Variables (Assignment);
            --< File:
            local file_normalized = normalize(file)
            if file_normalized:sub(1, #source_directory_normalized) == source_directory_normalized then
                --< Variables (Assignment):
                --< Relative:
                local relative = file_normalized:sub(#source_directory_normalized + 1)

                --< Module:
                local module_name = "source." .. relative:sub(1, -5):gsub("/", ".")

                --< Logic:
                modules[module_name] = read_file(file, false)
            end
        end
    end
end

--< Logic:
do
    --< Variables (Assignment):
    --< Protobuf:
    local protobuf_directory_normalized = normalize(protobuf_directory)

    if protobuf_directory_normalized:sub(-1) ~= "/" then
        protobuf_directory_normalized = protobuf_directory_normalized .. "/"
    end

    --< Logic:
    for _, file in ipairs(list_files(protobuf_directory)) do
        if file:sub(-6):lower() == ".proto" then
            --< Variables (Assignment):
            --< File:
            local file_normalized = normalize(file)

            if file_normalized:sub(1, #protobuf_directory_normalized) == protobuf_directory_normalized then
                --< Variables (Assignment):
                --< Relative:
                local relative = file_normalized:sub(#protobuf_directory_normalized + 1)

                --< Asset:
                local asset_name = "s2clientprotocol/" ..relative

                --< Logic:
                assets[asset_name] = read_file(file, true)
            end
        end
    end
end

--< Variables (Assignment):
--< Entry:
local entry_source = read_file(entry_path, false)

--< Output:
local output = assert(io.open(output_path, "w"))

--< Logic:
output:write("--< Auto-generated by: tools/bundle.lua\n")
output:write("--< Variables (Assignment):\n")
output:write("local BUNDLE = { modules = {}, assets = {} }\n")

--< Logic:
for module_name, source in pairs(modules) do
    output:write(string.format("BUNDLE.modules[%q] = %s\n", module_name, quote_long_string(source)))
end

for asset_name, content in pairs(assets) do
    output:write(string.format("BUNDLE.assets[%q] = %s\n", asset_name, quote_long_string(content)))
end

output:write([[
--< Variables (Assignment):
--< Function:
local load_function = loadstring or load

--< Functions:
local function bundle_loader(name)
    --< Variables (Assignment):
    --< Source:
    local source = BUNDLE.modules[name]

    if not source then
        return "\n\tno bundled module: " .. name
    end

    --< Chunk:
    local chunk, error = load_function(source, "@" .. name, "t")

    if not chunk then
        return "\n\tbundle load error: " .. error 
    end

    --< Chunk:
    return chunk
end

--< Variables (Assignment):
--< Searcherse:
local searchers = package.searchers or package.loaders

--< Logic:
table.insert(searchers, 1, bundle_loader)

--< Variables (Assignment):
--< Assets:
_G.__BUNDLE_ASSETS = BUNDLE.assets

--< Source:
local entry_source = ]])

--< Logic:
output:write(quote_long_string(entry_source))
output:write([[

--< Entry:
local entry_chunk, entry_error = load_function(entry_source, "@main.lua", "t")

if not entry_chunk then
    error(entry_error)
end

--< Chunk:
return entry_chunk(...)
]])

--< Output:
output:close()

--< Logger:
Logger.log_information("[+] Wrote bundle to: " .. output_path)