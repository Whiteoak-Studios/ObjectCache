--[[
    Allows users to cache both 2D and 3D instance
    which can be easily retrieved and removed.
--]]

--!strict
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages

local Promise = require(Packages.Promise)

local HUGE: number = math.huge
local LARGE_CFRAME: CFrame = CFrame.new(HUGE, HUGE, HUGE)

export type object = (Model | BasePart | Instance) | nil

export type category = {
    items: {object | nil}
}

export type inUse = {
    object: object | nil,
    category: string | nil
}

local Module = {
    cache = {} :: {string: {}},
    inUse = {} :: inUse -- Stores the objects being used
}

--[[
    Create a cache category to store cached items into, an example
    of this would be a `Sound` or `Weapons` cache

    @category: The name of the category you want to create, you use this - 
    to retrieve an item from a specific category
--]]

function Module:create(category: string) : category | nil
    if not Module.cache[category] then
        Module.cache[category] = {
            items = {}
        }

        return Module.cache[category]
    else
        warn(`{category} Category already exists!`)
    end
end

--[[
    Add an object to the cache which can be retrieved using `get`
    
    @object: The model or basepart you want to cache
    @count: The number of times the object should be cached
    @parent: The parent of the cached items (Workspace only)
--]]

function Module:add(
    object: object | nil,
    count: number?,
    parent: Folder?,
    category: string?
) : boolean

    assert(object ~= nil, `{object} passed through object parameter is nil!`)
    assert(object:IsDescendantOf(game), `{object} passed through object parameter is not a descendant of game!`)
    assert(parent ~= nil, `{parent} passed through parent parameter is nil!`)
    assert(Module.cache[category] ~= nil, `Category does not exist!`)

    -- Clone objects and add them to their categories cache
    local cacheCategory: category = Module.cache[category]
    Promise.new(function()
        for _ = 0, count or 1, 1 do
            local clone: object = object:Clone()
            Module:_reset(object)
            clone.Parent = parent

            table.insert(cacheCategory.items, clone)
        end
    end)

    return true
end

--[[
    Attempts to "get" (return) a cached item that was added to a
    specific category
    
    @category: The category to attempt to find a cached item
    @count: The amount of items you want to get, defaults to 1, returns
    an array of objects if count is greater than 1
--]]

function Module:get(category: string, count: number?) : ({object}) | nil
    assert(Module.cache[category] ~= nil, `"{category}" Category does not exist`)

    local cacheCategory: category = Module.cache[category]
    local items: typeof(category.items) = cacheCategory.items

    if next(items) ~= nil then
        if count then
            local itemsToReturn: {Instance} = {}
            local newCount: number = if #items >= count then count else #items

            for index = 0, newCount, 1 do
                local object: object = items[index]
                if not object then
                    continue
                end

                Module.inUse[object] = {
                    instance = object,
                    category = category,
                }

                table.insert(itemsToReturn, object)
                table.remove(items, index)
            end

            return itemsToReturn
        else
            local object: Instance = items[1]
            Module.inUse[object] = {
                instance = object,
                category = category,
            }

            table.remove(items, 1) -- We've taken the object out of the cache, since it's being used (needs to be returned)
            return {object}
        end
    end
end

--[[
    Removes an item from the categories cache, removes only items that
    are not currently within use

    @category: The category of the cached item to remove
    @count: The amount of cached items to remove, defaults to 1
--]]

function Module:remove(category: string, count: number?) : boolean | nil
    assert(Module.cache[category] ~= nil, `"{category}" Category does not exist`)

    local cacheCategory: category = Module.cache[category]
    local items: typeof(category.items) = cacheCategory.items

    if next(items) ~= nil then
        if count then
            for _ = 0, count, 1 do
                if
                    items[1]
                then
                    table.remove(items, 1)
                end
            end
            return true
        else
            if items[1] then
                table.remove(items, 1)
                return true
            else
                warn(`Failed to find items within the category!`)
            end
        end
    end
end

--[[
    Returns the cached part back into the cache, and positions
    very far away to move out out of render. Would've been called
    "return" but that's a syntax statement.
--]]

function Module:rebound(object: object| nil) : boolean | nil
    if not Module.inUse[object] then
        warn(`Failed to find cached object data for {object}!`)
        return
    end

    local category: string = Module.inUse[object].category

    if not Module.cache[category] then
        warn(`Failed to find category {category}!`)
        return
    end

    local cacheCategory: category = Module.cache[category]
    local items: typeof(category.items) = cacheCategory.items

    Module.inUse[object] = nil
    table.insert(items, object)

    Module:_reset(object)
    return true
end

--[[
    Positions cached objects to their default position
--]]

function Module:_reset(object: object | nil)
    if not object then
        warn(`Failed to find object {object}!`)
        return
    end

    -- Move object back to very far away
    if object:IsA("Model") then
        object:PivotTo(LARGE_CFRAME)
    else
        object.CFrame = LARGE_CFRAME
    end
end

return Module