local CollectionService = game:GetService("CollectionService")

return function(tag, callback)
	local destructors = {}

	local function added(instance)
		destructors[instance] = callback(instance)
	end

	for _, instance in ipairs(CollectionService:GetTagged(tag)) do
		task.spawn(added, instance)
	end

	CollectionService:GetInstanceAddedSignal(tag):Connect(added)

	CollectionService:GetInstanceRemovedSignal(tag):Connect(function(instance)
		local destructor = destructors[instance]
		if destructor then
			destructor()
		end
	end)
end
