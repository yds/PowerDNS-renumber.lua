local wan = newNetmask('169.254.42.0/25')
local lan = '192.168.42'
function postresolve(dq)
	local records = dq:getRecords()
	for a,r in pairs(records) do
		if r.type == pdns.A and wan:match(r:getContent()) then
			a = r:getContent():gsub('%d+%.%d+%.%d+(%.%d+)', lan .. '%1')
			r:changeContent(a)
		end
	end
	dq:setRecords(records)
	return true
end
