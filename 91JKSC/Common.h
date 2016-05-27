//
//  Common.h
//  model
//
//  Created by 商城 阜新 on 16/1/4.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#ifndef Common_h
#define Common_h



#define SYS_WIDTH   [UIScreen mainScreen].bounds.size.width 
#define SYS_HEIGHT  [UIScreen mainScreen].bounds.size.height
#define SYS_BOUNDS  [UIScreen mainScreen].bounds

#define BackGreenColor [UIColor colorWithRed:0.01f green:0.48f blue:0.22f alpha:1.00f]

//带有RGBA的颜色设置
#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]

// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)


#define RGBAF(r,g,b,a) [UIColor colorWithRed:r green:g blue:b alpha:a]
#define RGBFloat(r,g,b) RGBAF(r,g,b,1.0f)
//背景色
#define BACKGROUND_COLOR [UIColor colorWithRed:0.92f green:0.92f blue:0.93f alpha:1.00f]



//定义UIImage对象
#define ImageNamed(_pointer) [UIImage imageNamed:[NSString stringWithFormat:_pointer]]

#define API_URL @"http://api.91jksc.com"


//接口
#define API_Login [NSString stringWithFormat:@"%@/index/login/",API_URL]

#define API_CART [NSString stringWithFormat:@"%@/index/Cart/",API_URL]

#define API_CLASS [NSString stringWithFormat:@"%@/index/Classes/",API_URL]

#define API_GOODS [NSString stringWithFormat:@"%@/index/goods/",API_URL]

#define API_ADDRESS [NSString stringWithFormat:@"%@/index/address/",API_URL]

#define API_ORDER [NSString stringWithFormat:@"%@/index/Order/",API_URL]

#define API_MyFavourites [NSString stringWithFormat:@"%@/index/myfavorites/",API_URL]

#define API_PAYMENT [NSString stringWithFormat:@"%@/index/Payment/",API_URL]

#define API_USER [NSString stringWithFormat:@"%@/index/user/",API_URL]

#define API_EVALUATE [NSString stringWithFormat:@"%@/index/Evaluate/",API_URL]
#define API_REFUND [NSString stringWithFormat:@"%@/index/refund/",API_URL]

#define API_HELP [NSString stringWithFormat:@"%@/index/Help/",API_URL]


//当前设备型号http://192.168.188.175/index/Payment/
#define DEVICE  [UIDevice currentDevice].model
//当前设备MAC地址
//#define MAC_ADDRESS [[UIDevice currentDevice] uuid]
#define MAC_ADDRESS @"002324A10097"

#define SYS_FONT(num) [UIFont systemFontOfSize:num/375.0f*SYS_WIDTH]
#define SYS_SCALE(num) num/375.0f*SYS_WIDTH


#define ImageURL @"http://img.91jksc.com/"
#define ImageWithUrl(imageV,_urlStr) [imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,_urlStr]] placeholderImage:[UIImage imageNamed:@"nopic"]];

#define kResponse @"kResponse"
#define kAddShareResponse @"addShareResponse"
/*微信APPID*/
#define WeChatAPPID @"wx729696289e6fa905"
#define WeiBoAPPKEY @"1637715499"
#define AlipayPrivateKey @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBALjUJYDVp2N0TMaccYkOUlz4DQ/fMk2TrKVgXS39gvEcwSbJYWvJjRpI/H7OG/ggFYpPRTtS5w2w+7R8Y4dshozNYn0iUcCXpCBwjyMJ5y0SU18UPEnS736DRPdeC9BrFao3V0dm+mpj48zPdWDV8vrvzbgHL1S1twq5alVUqP1nAgMBAAECgYEArDA/7CGfeuD7McDHaPbltmUEzjeSRoGAQuVeiZz24yd1rmvIDcHMaaN7T6s2lVdWme61wcm/JZsvM3r6wkxRn78KdYYmgzDLDKR9fI9p0+aRnmCxiuiQ6rozlF43hbZgBI+jj5hws+p8zBN1V7GpJf7uUTKxAN5S192+Ycb8YBkCQQDn5oEoCfbAYR1OL2lAVMATZFLOpp63/aRUkX/T2vPqiBVkxZf+u3F1nh0h5hRFOoaJrp33BOz0178O2DTFfx0FAkEAzAlXvNQakPdS2jZ/D709ErOJqiLJpFkfiH3YYX2OAa0A5aNYSUnK+a6yMmUCKVxquKVIpHo9oCSzVZQwG/ucewJAZCnQsY2UMcYAlWuvB2VTzUxw4+dd+NSqbQincMdKwYtjyjH6k8E8oXPY23J4YOqFf+SXQEG1Y4/oay4BpShhTQJARZRGDEnUiW0eHvYInIhvJEp/frqAQwB1hWlM+eoEHEQwEx+CAvQcOMs/T3oso4g1iKQswpJBI7SAR4XSZiiGswJAYjCyKGDbCMwlCTACEOFmCPIS4SQ+5B9E8K6TfKl5mnaZRh+Kse9QjtsCkKEJqvRIhbbYxqj5ka3+GLC/ELoNRg=="



#endif /* Common_h */
