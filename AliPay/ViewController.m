//
//  ViewController.m
//  AliPay
//
//  Created by 薛焱 on 16/1/28.
//  Copyright © 2016年 薛焱. All rights reserved.
//

#import "ViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "DataSigner.h"
#import "Order.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)pay:(UIButton *)sender {
    NSString *partner = @"2088501566833063";
    //收款账户
    NSString *seller = @"chenglianshiye@yeah.net";
    //私钥
    NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBALS8ErohdAbxj+vz4DdLksKlWi+s5yd3zCjx712emFQxEduPIm3eL1rlhtYtNEb9JfdevN3uVhWqUlzqEvkb484IRZ1DWK0pvf3vo0gXYDiaMKqxjQqPo21ByPNnvRsrxq6YkP1CoTT6w/MEV8ylaCfc7fHOgZle49Pn98Z2sub9AgMBAAECgYEArJUvOMe7GOpQqVqez4593RqybPYpYRnXPX4ROY+5HCQjTkp28P0KsTyeLiTKV8NiHr47kZ0GXPfgYFMwvOmx9C/pE6DDpNlAaWDEciQXDzBv9jAJRYgPS5qvfOSsY3Lc5lwnN+mECIwmziPW8FJHM7SgGbrd/XZCyaES8nItFU0CQQDgjuTXWUgCwUQL39Kx+qzeAAelGDeB97jyaGpPa7yaCo8UVt8iojmN7s90KdiyN3/4s3LpMcpAPJePUlvaacGnAkEAzgpcV0TaSSjrYeBZ/5xwEmBU9yVheD8TxD969gIM3mrr/WdGTg65Do+cuiANVPSjHUH54wa0+Z10j6wAFpQ+uwJATFPFrP0H4QfYHUEi2KQgBgV0k8U7eM2+64ZaPEyeeq2EHKG6jocdkQTPNujSYyFCOkKkmGb4HAV8bpbL6d1wmQJAJ+vF/HqwuKAfCzXG+km7RTQ5AjHR8tR15f5Our+m8qlQ1CZgbttXa8TTnxR6wM0tlYuk+SHhisPBQ90Vn0pV5QJAar0Ba8WIzh1Wf5YgAG+Is1j+kbaTx9ltA4pDgsUZB+HOVqpK8+9o1N2NlqzaBale+9iZqAskvjyO1IPGzFIDPQ==";
    if (partner.length == 0 || seller.length ==0 || privateKey.length == 0) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"缺少partner或者seller或者私钥。" preferredStyle:(UIAlertControllerStyleAlert)];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:YES completion:nil];
    }
    Order *order = [[Order alloc]init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = @"2349273482223";//订单号
    order.productName = @"商品名称";
    order.productDescription = @"商品描述";
    order.amount = [NSString stringWithFormat:@"%.2f", 0.01];//价格
    order.notifyURL =  @"http://blog.csdn.net/fish_yan_?viewmode=list"; //回调网址
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    NSString *appScheme = @"xueyan";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            //【callback处理支付结果】
            NSLog(@"reslut = %@",resultDic);
        }];
    }
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
