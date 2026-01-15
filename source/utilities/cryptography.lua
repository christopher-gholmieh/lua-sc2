--< Written by: Christopher Gholmieh
--< Variables (Assignment):

--< Manipulation:
local Manipulation = require("source.utilities.manipulation")

--< Cryptography:
local Cryptography = {}

--< Functions:
function Cryptography.base64_encode(data)
    --< Variables (Assignment):
    --< Alphabet:
    local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"

    --< Bytes:
    local bytes = {data:byte(1, -1)}

    --< Output:
    local output = {}

    --< Logic:
    for iterator = 1, #bytes, 3 do
        --< Variables (Assignment):
        --< Byte:
        local byte_1 = bytes[iterator]       or 0
        local byte_2 = bytes[iterator + 1]   or 0
        local byte_3 = bytes[iterator + 2]   or 0

        --< Triple:
        local triple = (byte_1 << 16) | (byte_2 << 8) | byte_3

        --< Chunk:
        local chunk_1 = (triple >> 18) & 0x3F
        local chunk_2 = (triple >> 12) & 0x3F
        local chunk_3 = (triple >>  6) & 0x3F
        local chunk_4 = (triple)       & 0x3F

        --< Logic:
        output[#output + 1] = alphabet:sub(chunk_1 + 1, chunk_1 + 1)
        output[#output + 1] = alphabet:sub(chunk_2 + 1, chunk_2 + 1)

        if (iterator + 1) <= #bytes then
            output[#output + 1] = alphabet:sub(chunk_3 + 1, chunk_3 + 1)
        else
            output[#output + 1] = "="
        end

        if (iterator + 2) <= #bytes then
            output[#output + 1] = alphabet:sub(chunk_4 + 1, chunk_4 + 1)
        else
            output[#output + 1] = "="
        end
    end

    --< Output:
    return table.concat(output)
end

function Cryptography.SHA1(data)
    --< Variables (Assignment):
    --< Bytes:
    local bytes = {data:byte(1, -1)}

    --< Length:
    local bit_length = #bytes * 8

    --< Logic:
    bytes[#bytes + 1] = 0x80

    while (#bytes % 64) ~= 56 do
        bytes[#bytes + 1] = 0
    end

    --< Variables (Assignment):
    --< High:
    local high = math.floor(bit_length / 0x10000000)

    --< Low:
    local low = bit_length % 0x10000000

    --< Logic:
    for iterator = 3, 0, -1 do
        bytes[#bytes + 1] = math.floor(high / (256 ^ iterator)) % 256
    end

    for iterator = 3, 0, -1 do
        bytes[#bytes + 1] = math.floor(low / (256 ^ iterator)) % 256
    end

    --< Variables (Assignment):
    --< Hash:
    local hash_0 = 0x67452301
    local hash_1 = 0xEFCDAB89
    local hash_2 = 0x98BADCFE
    local hash_3 = 0x10325476
    local hash_4 = 0xC3D2E1F0

    --< Logic:
    for iterator = 1, #bytes, 64 do
        --< Variables (Assignment):
        --< Written:
        local written = {}

        --< Logic:
        for __iterator = 0, 15 do
            --< Variables (Assignment):
            --< Index:
            local index = iterator + (__iterator * 4)

            --< Logic:
            written[__iterator] = (bytes[index] << 24) | (bytes[index + 1] << 16) |
                (bytes[index + 2] << 8) | (bytes[index + 3]) 
        end

        for __iterator = 16, 79 do
            written[__iterator] = Manipulation.left_rotate(
                written[__iterator - 3] ~ written[__iterator - 8] ~
                written[__iterator - 14] ~ written[__iterator - 16], 1
            )
        end

        --< Variables (Assignment):
        --< Hash:
        local __hash_0 = hash_0
        local __hash_1 = hash_1
        local __hash_2 = hash_2
        local __hash_3 = hash_3
        local __hash_4 = hash_4

        --< Logic:
        for __iterator = 0, 79 do
            --< Variables (Assignment):
            --< Hash:
            local __hash_5 = 0
            local __hash_6 = 0

            --< Logic:
            if __iterator < 20 then
                --< Hash:
                __hash_5 = (__hash_1 & __hash_2) | ((~__hash_2) & __hash_3)
                __hash_6 = 0x5A827999
            elseif __iterator < 40 then
                --< Hash:
                __hash_5 = __hash_1 ~ __hash_2 ~ __hash_3
                __hash_6 = 0x6ED9EBA1
            elseif __iterator < 60 then
                --< Hash:
                __hash_5 = (__hash_1 & __hash_2) | (__hash_1 & __hash_3) | (__hash_2 & __hash_3)
                __hash_6 = 0x8F1BBCDC
            else
                --< Hash:
                __hash_5 = __hash_1 ~ __hash_2 ~ __hash_3
                __hash_6 = 0xCA62C1D6
            end

            --< Variables (Assignment):
            --< Temporary:
            local temporary = (
                Manipulation.left_rotate(__hash_0, 5) +
                __hash_5 + __hash_4 + __hash_6 + written[__iterator]
            ) & 0xFFFFFFFF

            --< Hash:
            __hash_4 = __hash_3
            __hash_3 = __hash_2
            __hash_2 = Manipulation.left_rotate(__hash_1, 30)
            __hash_1 = __hash_0
            __hash_0 = temporary
        end

        --< Variables (Assignment):
        --< Hash:
        hash_0 = (hash_0 + __hash_0) & 0xFFFFFFFF
        hash_1 = (hash_1 + __hash_1) & 0xFFFFFFFF
        hash_2 = (hash_2 + __hash_2) & 0xFFFFFFFF
        hash_3 = (hash_3 + __hash_3) & 0xFFFFFFFF
        hash_4 = (hash_4 + __hash_4) & 0xFFFFFFFF
    end

    --< Output:
    return string.char(
        (hash_0 >> 24) & 0xFF, (hash_0 >> 16) & 0xFF, (hash_0 >> 8) & 0xFF, hash_0 & 0xFF,
        (hash_1 >> 24) & 0xFF, (hash_1 >> 16) & 0xFF, (hash_1 >> 8) & 0xFF, hash_1 & 0xFF,
        (hash_2 >> 24) & 0xFF, (hash_2 >> 16) & 0xFF, (hash_2 >> 8) & 0xFF, hash_2 & 0xFF,
        (hash_3 >> 24) & 0xFF, (hash_3 >> 16) & 0xFF, (hash_3 >> 8) & 0xFF, hash_3 & 0xFF,
        (hash_4 >> 24) & 0xFF, (hash_4 >> 16) & 0xFF, (hash_4 >> 8) & 0xFF, hash_4 & 0xFF
    )
end

--< Cryptography:
return Cryptography