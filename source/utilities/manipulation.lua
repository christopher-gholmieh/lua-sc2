--< Written by: Christopher Gholmieh
--< Variables (Assignment):

--< Manipulation:
local Manipulation = {}

--< Functions:
function Manipulation.mask_payload(payload, mask)
    --< Variables (Assignment):
    --< Output:
    local output = {}

    --< Logic:
    for iterator = 1, #payload do
        --< Variables (Assignment):
        --< Byte:
        local byte = payload:byte(iterator)

        --< Mask:
        local byte_mask = mask:byte(((iterator - 1) % 4) + 1)

        --< Logic:
        output[iterator] = string.char(byte ~ byte_mask)
    end

    --< Output:
    return table.concat(output)
end

function Manipulation.bytes_to_hex(bytes)
    --< Validation:
    if not bytes then
        return "[!] N/A"
    end

    --< Variables (Assignment):
    --< Chunks:
    local chunks = {}

    --< Logic:
    for iterator = 1, #bytes do
        chunks[#chunks + 1] = string.format("%02X", bytes:byte(iterator))
    end

    --< Chunks:
    return table.concat(chunks, " ")
end

function Manipulation.left_rotate(value, bits)
    return ((value << bits) | (value >> (32 - bits))) & 0xFFFFFFFF
end

--< Manipulation:
return Manipulation