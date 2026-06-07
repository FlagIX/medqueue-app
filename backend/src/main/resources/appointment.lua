-- 预约扣号源Lua脚本
-- KEYS[1]: appointment:stock:{scheduleId}  号源库存key
-- KEYS[2]: appointment:order:{scheduleId}  已预约用户集合key（用于一人一单判断）
-- ARGV[1]: userId                          用户id

-- 1. 判断库存是否充足
local stock = tonumber(redis.call('get', KEYS[1]))
if stock == nil or stock <= 0 then
    return 1 -- 号源不足
end

-- 2. 判断用户是否已预约（一人一单）
local isMember = redis.call('sismember', KEYS[2], ARGV[1])
if isMember == 1 then
    return 2 -- 用户已预约，不可重复预约
end

-- 3. 号源充足且用户未预约，执行扣减
redis.call('incrby', KEYS[1], -1)

-- 4. 将用户id加入已预约集合
redis.call('sadd', KEYS[2], ARGV[1])

return 0 -- 预约成功
