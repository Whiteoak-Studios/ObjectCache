return function ()
    local ObjectCache = require(script.Parent)
    local ObjectTemplate: Model = workspace.Template
    local Parent: Folder = workspace.Cache

    describe("create", function()
        it("should create a new category for cached objects", function()
            local category: {} = ObjectCache:create("Framework")
            expect(category).to.be.a("table")
        end)
    end)

    describe("add", function()
        it("should create new cached templates of the object given", function()
            local success: boolean = ObjectCache:add(
                ObjectTemplate,
                2,
                Parent,
                "Framework"
            )

            expect(success).to.equal(true)
        end)
    end)

    describe("get", function()
        it("should return an object(s) from the cache", function()
            local objects: typeof(ObjectCache.objects) = ObjectCache:get("Framework")
            expect(objects).to.be.a("table")

            for _, object: Model in objects do
                object:PivotTo(CFrame.new(0, 5, 0))

                task.delay(1, function()
                    local success: boolean = ObjectCache:rebound(object)
                    expect(success).to.equal(true)
                end)
            end
        end)
    end)

    describe("remove", function()
        it("remove a object from the cache", function()
            local success: boolean = ObjectCache:remove("Framework")
            expect(success).to.equal(true)
        end)
    end)
end