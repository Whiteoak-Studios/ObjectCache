
## Setup (Roblox)
1. Set up a Wally project.
2. Add ObjectCache as a dependency in your `Wally.toml` file.
3. Run `wally install`.

🎉 Congratulations! You've installed ObjectCache.

# API
Valid search modes:
- "Tag"
- "ClassName"

### create

```lua
--[[
Create a cache category to store cached items into, an example
of this would be a `Sound` or `Weapons` cache
--]]
ObjectCache:create(
    category: string
)
```

### add

```lua
--[[
Add an object to the cache which can be retrieved using `get`
Can create multiple objects by adjusting count
--]]
ObjectCache:add(
    object: object | nil,
    count: number?,
    parent: Folder?,
    category: string?
)
```

### get

```lua
--[[
Attempts to "get" (return) a cached item that was added to a
specific category
--]]
ObjectCache:get(
    category: string,
    count: number?
)
```

### remove

```lua
--[[
Removes an item from the categories cache, removes only items that
are not currently within use
--]]
ObjectCache:remove(
    category: string,
    count: number?
)
```

### rebound

```lua
--[[
Returns the cached part back into the cache, and positions
very far away to move out out of render. Would've been called
"return" but that's a syntax statement.
--]]
ObjectCache:rebound(
    object: object| nil
)
```