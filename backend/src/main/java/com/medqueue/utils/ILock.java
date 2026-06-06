package com.medqueue.utils;

public interface ILock {
    //获取锁
    public boolean tryLock(long timeoutSec);
    //释放锁
    public void unlock();
}
