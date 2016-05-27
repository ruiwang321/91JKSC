//
//  ShareSheetView.m
//  91健康商城
//
//  Created by 商城 阜新 on 16/3/23.
//  Copyright © 2016年 商城 阜新. All rights reserved.
//

#import "ShareSheetView.h"
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "TencentOpenAPI/QQApiInterface.h"
#import "UIView+ViewController.h"
@implementation ShareSheetView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createSheet];
    }
    return self;
}
-(void)createSheet{
    UILabel *shareTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(SYS_SCALE(10), SYS_SCALE(10), SYS_WIDTH-SYS_SCALE(20), SYS_SCALE(30))];
    shareTitleLabel.font = [UIFont systemFontOfSize:16];

    shareTitleLabel.textColor = [UIColor blackColor];
    shareTitleLabel.text = @"分享到:";
    [self addSubview:shareTitleLabel];
    
    UILabel * lineLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0,SYS_SCALE(50), (SYS_WIDTH-SYS_SCALE(20)), 1)];
    lineLabel1.backgroundColor = BACKGROUND_COLOR;
    [self addSubview:lineLabel1];
    
    
    
//    if ([WXApi isWXAppInstalled]&&[WXApi isWXAppSupportApi]) {
//        UIButton *wxBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        wxBtn.frame = CGRectMake(((SYS_WIDTH-20)/3 *i+(SYS_WIDTH-20)/3-36)/2, 70, 40, 40);
//        [wxBtn setImage:[UIImage imageNamed:@"wechat"] forState:UIControlStateNormal];
//        [wxBtn addTarget:self action:@selector(shareWeixin) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:wxBtn];
//        
//        UILabel *wxLabel = [[UILabel alloc]initWithFrame:CGRectMake((SYS_WIDTH-20)/3 *i, 123, (SYS_WIDTH-20)/3, 20)];
//        wxLabel.font = [UIFont systemFontOfSize:14];
//        wxLabel.textAlignment = UITextAlignmentCenter;
//        wxLabel.textColor = [UIColor grayColor];
//        wxLabel.text = @"微信好友";
//        [self addSubview:wxLabel];
//        i = i+1;
//        
//        UIButton *wx_pyqBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        wx_pyqBtn.frame = CGRectMake((SYS_WIDTH-20)/3*i+((SYS_WIDTH-20)/3-36)/2, 70, 40, 40);
//        [wx_pyqBtn setImage:[UIImage imageNamed:@"friend"] forState:UIControlStateNormal];
//        [wx_pyqBtn addTarget:self action:@selector(shareWeixinPyq) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:wx_pyqBtn];
//        
//        UILabel *wx_pyqLabel = [[UILabel alloc]initWithFrame:CGRectMake((SYS_WIDTH-20)/3*i, 123, (SYS_WIDTH-20)/3, 20)];
//        wx_pyqLabel.font = [UIFont systemFontOfSize:14];
//        wx_pyqLabel.textAlignment = UITextAlignmentCenter;
//        wx_pyqLabel.textColor = [UIColor grayColor];
//        wx_pyqLabel.text = @"微信朋友圈";
//        [self addSubview:wx_pyqLabel];
//        i = i+1;
//        
//    }
//    if ([WeiboSDK isWeiboAppInstalled]) {
//        UIButton *wbBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        wbBtn.frame = CGRectMake((SYS_WIDTH-20)/3*i+((SYS_WIDTH-20)/3-36)/2, 70, 40, 40);
//        [wbBtn setImage:[UIImage imageNamed:@"weibo"] forState:UIControlStateNormal];
//        [wbBtn addTarget:self action:@selector(shareWeibo) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:wbBtn];
//        
//        UILabel *wbLabel = [[UILabel alloc]initWithFrame:CGRectMake((SYS_WIDTH-20)/3*i, 123, (SYS_WIDTH-20)/3, 20)];
//        wbLabel.font = [UIFont systemFontOfSize:14];
//        wbLabel.textAlignment = UITextAlignmentCenter;
//        wbLabel.textColor = [UIColor grayColor];
//        wbLabel.text = @"新浪微博";
//        [self addSubview:wbLabel];
//        i = i+1;
//    }
//    
//    NSLog(@"%d",i);
//
//    UIButton *qqZoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    qqZoneBtn.frame = CGRectMake((SYS_WIDTH-20)/3*(i-3)+((SYS_WIDTH-20)/3-36)/1, 220, 40, 40);
//    [qqZoneBtn setImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
//    [qqZoneBtn addTarget:self action:@selector(shareqqZone) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:qqZoneBtn];
//    
//    UILabel *qqZoneLabel = [[UILabel alloc]initWithFrame:CGRectMake((SYS_WIDTH-20)/3*(i-3), 273, (SYS_WIDTH-20)/3, 20)];
//    qqZoneLabel.font = [UIFont systemFontOfSize:14];
//    qqZoneLabel.textAlignment = UITextAlignmentCenter;
//    qqZoneLabel.textColor = [UIColor grayColor];
//    qqZoneLabel.text = @"QQ空间";
//    [self addSubview:qqZoneLabel];
//    i = i+1;
//   
    UILabel * lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, SYS_WIDTH-SYS_SCALE(51), (SYS_WIDTH-SYS_SCALE(20)), 1)];
    lineLabel.backgroundColor = BACKGROUND_COLOR;
    [self addSubview:lineLabel];
    
    UIButton *shareCancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareCancelBtn.frame = CGRectMake(0, SYS_WIDTH-SYS_SCALE(50), (SYS_WIDTH-SYS_SCALE(20)), SYS_SCALE(50));
    shareCancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [shareCancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [shareCancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [shareCancelBtn addTarget:self action:@selector(shareCancel) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:shareCancelBtn];
    
    NSMutableArray *imageArr = [NSMutableArray arrayWithArray:@[@"wechat-1",@"friend",@"weibo",@"qq",@"qq-space",@"copy"]];
    NSMutableArray *nameArr = [NSMutableArray arrayWithArray:@[@"微信",@"微信朋友圈",@"新浪微博",@"QQ",@"QQ空间",@"复制链接"]];
    
    if (![WXApi isWXAppInstalled]&&![WXApi isWXAppSupportApi]) {
        [imageArr removeObject:@"wechat-1"];
        [imageArr removeObject:@"friend"];
        [nameArr removeObject:@"微信"];
        [nameArr removeObject:@"微信朋友圈"];
    }

    if (![WeiboSDK isWeiboAppInstalled]) {
        [imageArr removeObject:@"weibo"];
        [nameArr removeObject:@"新浪微博"];
    }
    
    for (int i=0; i<imageArr.count; i++) {
    
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(i<3?(SYS_WIDTH-SYS_SCALE(20))/3*i+SYS_SCALE(25):(SYS_WIDTH-SYS_SCALE(20))/3*(i-3)+SYS_SCALE(25), i<3?SYS_SCALE(70):SYS_SCALE(210), SYS_SCALE(60), SYS_SCALE(60));
        
        btn.backgroundColor = [UIColor clearColor];
        [btn setBackgroundImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        btn.tag =  100+i;
        [btn addTarget:self action:@selector(shareWithSomething:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        UILabel *label = [[UILabel alloc]initWithFrame:i<3?CGRectMake((SYS_WIDTH-SYS_SCALE(20))/3*i, SYS_SCALE(140), (SYS_WIDTH-SYS_SCALE(20))/3, SYS_SCALE(20)):CGRectMake((SYS_WIDTH-SYS_SCALE(20))/3*(i-3),SYS_SCALE(280), (SYS_WIDTH-SYS_SCALE(20))/3, SYS_SCALE(20))];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = nameArr[i];
        label.font = SYS_FONT(15);
        [self addSubview:label];
        
        
    }
    
    
    
}
-(void)shareWithSomething:(UIButton *)btn{
    if ([WXApi isWXAppInstalled]&&[WXApi isWXAppSupportApi]) {
        if (![WeiboSDK isWeiboAppInstalled]) {
            if (btn.tag == 100) {
                [self shareWeixin];
            }else if(btn.tag == 101){
                [self shareWeixinPyq];
            }else if(btn.tag == 102){
                [self shareQQ];
            }else if(btn.tag == 103){
                [self shareqqZone];
            }else{
                [self copyText];
            }
        }else{
            if (btn.tag == 100) {
                [self shareWeixin];
            }else if(btn.tag == 101){
                [self shareWeixinPyq];
            }else if(btn.tag == 102){
                [self shareWeibo];
            }else if(btn.tag == 103){
                [self shareQQ];
            }else if(btn.tag == 104){
                [self shareqqZone];
            }else {
                [self copyText];
            }
            
        }
    }else{
        if ([WeiboSDK isWeiboAppInstalled]) {
            if (btn.tag == 100) {
                [self shareWeibo];
            }else if(btn.tag == 101){
                [self shareQQ];
            }else if(btn.tag == 102){
                [self shareqqZone];
            }else {
                [self copyText];
            }
        }else{
            if (btn.tag == 100) {
                [self shareQQ];
            }else if(btn.tag == 101){
                 [self shareqqZone];
            }else{
                [self copyText];
            }
        }
    }
    
    
    
}
-(void)shareWeixin{
    [self sendwx:0];
}
-(void)shareWeixinPyq{
    [self sendwx:1];
}
-(UIImage*) OriginImage:(UIImage *)image scaleToSize:(CGSize)size{ UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext(); UIGraphicsEndImageContext();
    return scaledImage;
}
-(void)sendwx:(int)index{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title =_detailmodel.goods_name;

    NSLog(@"%@",UIImageJPEGRepresentation([UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,_detailmodel.goods_image]]]], 0.001));
 
    [message setThumbImage:[self OriginImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,_detailmodel.goods_image]]]] scaleToSize:CGSizeMake(80, 80)]];
//    message.thumbData =UIImageJPEGRepresentation([UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,_detailmodel.goods_image]]]], 0.01);
    
    message.description =_detailmodel.goods_jingle;
    WXWebpageObject *webpage = [[WXWebpageObject alloc]init];
    webpage.webpageUrl =[NSString stringWithFormat:@"mobile.91jksc.com/goods-%@.html",_detailmodel.goods_id];
    message.mediaObject = webpage;
    SendMessageToWXReq *req = [SendMessageToWXReq  alloc];
    req.bText = NO;
    req.message = message;
    req.scene = index;
    [WXApi sendReq:req];
    NSLog(@"%d",[WXApi sendReq:req]);
    
    
}
-(void)shareWeibo{
    WBMessageObject *message = [WBMessageObject message];
    message.text = _detailmodel.goods_jingle;

    WBImageObject *image = [WBImageObject object];
    image.imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,_detailmodel.goods_image]]];
    message.imageObject = image;
    WBSendMessageToWeiboRequest *req = [WBSendMessageToWeiboRequest requestWithMessage:message];
    [WeiboSDK sendRequest:req];
}
-(void)shareqqZone{
    TencentOAuth * tencentOAuth = [[TencentOAuth alloc]initWithAppId:@"1104986692" andDelegate:self];
    NSString *url =[NSString stringWithFormat:@"mobile.91jksc.com/goods-%@.html",_detailmodel.goods_id];
 
    QQApiNewsObject *imgObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:url] title:_detailmodel.goods_name description:_detailmodel.goods_jingle previewImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,_detailmodel.goods_image]]];
    [imgObj setCflag:[self shareControlFlags]];
//    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
//    //将内容分享到qq
//    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    //将内容分享到qzone
//    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
    QQApiSendResultCode sent =0;
    sent = [QQApiInterface SendReqToQZone:req];//空间分享
    [self handleSendResult:sent];
}
-(void)shareQQ{
    TencentOAuth * tencentOAuth = [[TencentOAuth alloc]initWithAppId:@"1104986692" andDelegate:self];
    NSString *url =[NSString stringWithFormat:@"mobile.91jksc.com/goods-%@.html",_detailmodel.goods_id];
    
    QQApiNewsObject *imgObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:url] title:_detailmodel.goods_name description:_detailmodel.goods_jingle previewImageURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ImageURL,_detailmodel.goods_image]]];
    [imgObj setCflag:[self shareControlFlags]];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
    //将内容分享到qq
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    //将内容分享到qzone
    //    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    //    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
    //    QQApiSendResultCode sent =0;
    //        sent = [QQApiInterface SendReqToQZone:req];//空间分享
    [self handleSendResult:sent];
}
-(void)copyText{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:[NSString stringWithFormat:@"%@%@",ImageURL,_detailmodel.goods_image]];
    [MBProgressHUD showSuccess:@"复制成功"];
}
- (uint64_t)shareControlFlags
{
    NSDictionary *context = [self currentNavContext];
    __block uint64_t cflag = 0;
    [context enumerateKeysAndObjectsUsingBlock:^(id key,id obj, BOOL *stop) {
        if ([obj isKindOfClass:[NSNumber class]] &&
            [key isKindOfClass:[NSString class]] &&
            [key hasPrefix:@"kQQAPICtrlFlag"])
        {
            cflag |= [obj unsignedIntValue];
        }
    }];
    
    return cflag;
}

- (NSMutableDictionary *)currentNavContext
{
    UINavigationController *navCtrl = [self.viewController navigationController];
    NSMutableDictionary *context = objc_getAssociatedObject(navCtrl,objc_unretainedPointer(@"currentNavContext"));
    if (nil == context)
    {
        context = [NSMutableDictionary dictionaryWithCapacity:3];
        objc_setAssociatedObject(navCtrl,objc_unretainedPointer(@"currentNavContext"), context,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return context;
}


- (void)handleSendResult:(QQApiSendResultCode)sendResult
{
    switch (sendResult)
    {
        case EQQAPIAPPNOTREGISTED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIQQNOTINSTALLED:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        case EQQAPISENDFAILD:
        {
            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
            [msgbox show];
            
            break;
        }
        default:
        {
            break;
        }
    }
}
- (void)addShareResponse:(APIResponse*) response
{
    NSLog(@"%@",response.jsonResponse);
}
-(void)shareCancel{
    
    self.hidden =YES;
    self.block();
    
}
-(void)dissmissForSuper:(superDissmiss)block{
    self.block = block;
}

@end
