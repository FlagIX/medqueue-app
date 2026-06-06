-- 秒杀Lua脚本
-- KEYS[1]: seckill:stock:{voucherId}  秒杀库存key
-- KEYS[2]: seckill:order:{voucherId}  秒杀订单集合key（用于一人一单判断）
-- ARGV[1]: userId                      用户id

-- 1. 判断库存是否充足
local stock = tonumber(redis.call('get', KEYS[1]))
if stock == nil or stock <= 0 then
    return 1 -- 库存不足
end

-- 2. 判断用户是否已下单（一人一单）
local isMember = redis.call('sismember', KEYS[2], ARGV[1])
if isMember == 1 then
    return 2 -- 用户已下单，不可重复购买
end

-- 3. 库存充足且用户未下单，执行扣减库存
redis.call('incrby', KEYS[1], -1)

-- 4. 将用户id加入已下单集合
redis.call('sadd', KEYS[2], ARGV[1])

return 0 -- 秒杀成功
