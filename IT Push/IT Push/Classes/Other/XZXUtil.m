//
//  XZXUtil.m
//  IT Express
//
//  Created by xuzx on 16/4/9.
//  Copyright © 2016年 xuzx. All rights reserved.
//

#import "XZXUtil.h"
#import <objc/runtime.h>
@implementation XZXUtil





+ (NSDictionary *)XZXModel:(id)model{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    unsigned int count;
    objc_property_t *props = class_copyPropertyList([model class], &count);
    
    for(int i = 0; i < count; i++){
        objc_property_t prop = props[i];
        
        NSString *propName = [NSString stringWithUTF8String:property_getName(prop)];
        
        id value = [model valueForKey:propName];
        
        if(value == nil){
            value = [NSNull null];
        }else{
            value = [self getObjectInternal:value];
        }
        
        [dict setValue:value forKey:[NSString stringWithFormat:@"%@", propName]];
        
        
        
        
        
    }
    
    
    
    return dict;
    
}

+
(id)getObjectInternal:(id)obj

{
    
    if([obj
        isKindOfClass:[NSString class]]
       
       ||
       [obj isKindOfClass:[NSNumber class]]
       
       ||
       [obj isKindOfClass:[NSNull class]])
        
    {
        
        return
        
        obj;
        
    }
    
    
    
    if([obj
        isKindOfClass:[NSArray class]])
        
    {
        
        NSArray
        *objarr = obj;
        
        NSMutableArray
        *arr = [NSMutableArray arrayWithCapacity:objarr.count];
        
        for(int
            i = 0;i < objarr.count; i++)
            
        {
            
            [arr
             setObject:[self getObjectInternal:[objarr objectAtIndex:i]] atIndexedSubscript:i];
            
        }
        
        return
        
        arr;
        
    }
    
    
    
    if([obj
        isKindOfClass:[NSDictionary class]])
        
    {
        
        NSDictionary
        *objdic = obj;
        
        NSMutableDictionary
        *dic = [NSMutableDictionary dictionaryWithCapacity:[objdic count]];
        
        for(NSString
            *key in
            
            objdic.allKeys)
            
        {
            
            [dic
             setObject:[self getObjectInternal:[objdic objectForKey:key]] forKey:key];
            
        }     
        
        return
        
        dic;
        
    } 
    
    return
    
    [self XZXModel:obj];
    
}

@end
