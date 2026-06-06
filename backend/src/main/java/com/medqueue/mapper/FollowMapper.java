package com.medqueue.mapper;

import com.medqueue.entity.Follow;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface FollowMapper extends BaseMapper<Follow> {

    int countFollow(@Param("userId") Long userId,
                    @Param("followId") Long followId,
                    @Param("followType") Integer followType);

    List<Follow> queryMyFollows(@Param("userId") Long userId, @Param("followType") Integer followType);
}
