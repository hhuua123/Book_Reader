//
//  TWRegulaStrMacro.h
//
//  Created by hhuua on 2017/8/10.
//  Copyright © 2017年 hhuua. All rights reserved.
//

#ifndef TWRegulaStrMacro_h
#define TWRegulaStrMacro_h

#define kPhoneNumRegulaStr @"^1[34578]\\d{9}$"
#define kIsPhoneNum(str) [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", kPhoneNumRegulaStr] evaluateWithObject:str]

#endif /* TWRegulaStrMacro_h */
