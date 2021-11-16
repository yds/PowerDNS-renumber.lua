local nets = {}
nets['10.16.169'] = newNetmask('172.16.169.0/25')
nets['10.168.42'] = newNetmask('192.168.42.128/25')
function postresolve(dq)
	local records = dq:getRecords()
	for a,r in pairs(records) do
		if r.type == pdns.A then
			a = r:getContent()
			for lan,wan in pairs(nets) do
				if wan:match(a) then
					a = a:gsub('%d+%.%d+%.%d+(%.%d+)', lan .. '%1')
					r:changeContent(a)
				end
			end
		end
	end
	dq:setRecords(records)
	return true
end
