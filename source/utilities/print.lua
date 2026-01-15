--< Written by: Christopher Gholmieh
--< Variables (Assignment):

--< Print:
local Print = {}

--< Functions:
function Print.recursive_print_implementation(table, indent, visited)
    --< Variables (Assignment):
    --< Indent:
    indent = indent or 4

    --< Visited:
    visited = visited or {}

    --< Validation:
    if visited[table] then
        --< Log:
        print(string.rep(" ", indent) .. "*CIRCULAR REFERENCE*")

        --< Logic:
        return
    end

    --< Visited:
    visited[table] = true

    --< Logic:
    for key, value in pairs(table) do
        --< Variables (Assignment):
        --< Prefix:
        local prefix = string.rep(" ", indent)

        --< Logic:
        if type(value) == "table" then
            --< Log:
            print(prefix .. tostring(key) .. " = {")

            --< Logic:
            Print.recursive_print_implementation(value, indent + 4, visited)
            
            --< Log:
            print(prefix .. "}")
        else
            --< Log:
            print(prefix .. tostring(key) .. " = " .. tostring(value))
        end
    end
end

--< Functions:
function Print.recursive_print(table)
    --< Log:
    print("{")

    --< Logic:
    Print.recursive_print_implementation(table, 4, {})

    --< Log:
    print("}")
end

--< Print:
return Print