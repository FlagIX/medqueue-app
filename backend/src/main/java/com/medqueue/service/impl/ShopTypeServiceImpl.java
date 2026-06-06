package com.medqueue.service.impl;

import cn.hutool.core.util.StrUtil;
import cn.hutool.json.JSONUtil;
import com.medqueue.dto.Result;
import com.medqueue.entity.Shop;
import com.medqueue.entity.ShopType;
import com.medqueue.mapper.ShopTypeMapper;
import com.medqueue.service.IShopTypeService;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import com.medqueue.utils.RedisConstants;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.ArrayList;
import java.util.List;

import static com.medqueue.utils.RedisConstants.CACHE_SHOP_TYPE_KEY;

/**
 * <p>
 * 服务实现类
 * </p>
 *
 * @author 虎哥
 * @since 2021-12-22
 */
@Service
public class ShopTypeServiceImpl extends ServiceImpl<ShopTypeMapper, ShopType> implements IShopTypeService {
    @Resource
    private StringRedisTemplate stringRedisTemplate;

    @Override
    public Result queryTypeListWithCache() {
        String key = CACHE_SHOP_TYPE_KEY;
        //1.从redis查询    缓存
        List<String> typeJsonList = stringRedisTemplate.opsForList().range(key, 0, -1);
        //2,判断是否存在
        if (typeJsonList != null && !typeJsonList.isEmpty()) {
            //3.存在，直接返回
            List<ShopType> typeList = new ArrayList<>();
            for (String JSON : typeJsonList) {
                typeList.add(JSONUtil.toBean(JSON,ShopType.class));
            }
            return Result.ok(typeList);
        }
        //4,不存在，根据类型查询数据库
        List<ShopType> typeList = query().orderByAsc("sort").list();
        //5.不存在，返回错误
        if (typeList == null || typeList.isEmpty()) {
            return Result.fail("商铺类型不存在");
        }
        //6.存在，写入redis
        List<String>jsonList = new ArrayList<>();
        for (ShopType shopType : typeList) {
            jsonList.add(JSONUtil.toJsonStr(shopType));
        }
        stringRedisTemplate.opsForList().rightPushAll(key,jsonList);
        //7.返回
        return Result.ok(typeList);
    }
}
