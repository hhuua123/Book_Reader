//
//  HYHigherOrderFunc.h
//  hzcz_zh
//
//  Created by hhuua on 2018/1/18.
//  Copyright © 2018 hhuua All rights reserved.
//

/* 实现一些其他语言中常见的高阶函数*/

#ifndef HYHigherOrderFunc_h
#define HYHigherOrderFunc_h

/**
 * 常见的map函数,传入一个数组,对数组中的所有对象执行同一方法,并返回一个新的数组
 * 示例:
 NSArray* ddd = kMap(@[@"A", @"B", @"C", @"D", @"E", @"F"], ^id(id obj) {
    return ((NSString*)obj).lowercaseString;
 });
 
 输出: ddd = @[@"a",@"b",@"c",@"d",@"e",@"f"]
 */
static inline NSArray* kMap(NSArray* arr, id(^func)(id obj)){
    NSMutableArray* array = [[NSMutableArray alloc] init];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:func(obj)];
    }];
    return array;
}

/**
 * 常见的filter函数,传入一个数组,对数组中的元素按照判定值进行筛选,并返回一个新的数组
 * 示例:
 NSArray* ddd = kFilter(@[@"1", @"2", @"3", @"4", @"5", @"6", @"7"], ^BOOL(NSString* obj) {
    return [obj integerValue] >= 4;
 });
 
 输出: ddd = @[@"4", @"5", @"6", @"7"]
 */
static inline NSArray* kFilter(NSArray* arr, BOOL(^result)(id obj)){
    NSMutableArray* array = [NSMutableArray array];
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       if (result(obj))
           [array addObject:obj];
    }];
    return array;
}

/**
 * 常见的排序函数,给出一个数组,返回一个按照iOS默认规则排序的新数组
 * 示例:
 NSArray* ddd = kSort(@[@"123", @"143", @"abc", @"bbc", @"110", @"Abc", @"aBc"], ^id(id obj) {
    // 返回值为排序的字段,例如按照user对象的name属性进行排序:return user.name;
    return obj;
 });
 
 输出: ddd = @[110,123,143,Abc,aBc,abc,bbc]
 */
static inline NSArray* kSort(NSArray* arr, id(^result)(id obj)){
    NSArray* sortArr = [arr sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [result(obj1) compare:result(obj2)];
    }];
    return sortArr;
}

/**
 * 常用的reduce函数
 示例:
 double ddd = kReduce(@[@1, @2, @3, @4, @5, @6], ^double(double Tvalue, double Nvalue) {
    return Tvalue * Nvalue;
 });
 
 输出: ddd = 720.000000
 */
static inline double kReduce(NSArray* arr, double(^func)(double Tvalue, double Nvalue)){
    __block double va;
    [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        va = idx==0?[obj doubleValue] : func(va, [obj doubleValue]);
    }];
    
    return va;
}


#endif /* HYHigherOrderFunc_h */
