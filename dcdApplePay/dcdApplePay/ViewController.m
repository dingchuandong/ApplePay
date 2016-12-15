//
//  ViewController.m
//  dcdApplePay
//
//  Created by 丁传东 on 16/4/21.
//  Copyright © 2016年 上海千叶网络科技有限公司. All rights reserved.
//

#import "ViewController.h"
#import <PassKit/PassKit.h>
#import <AddressBook/AddressBook.h>
//#import "dcdApplePay-TestSwift.h"
#import "dcdApplePay-Bridging-Header.h"

@interface ViewController ()<PKPaymentAuthorizationViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIButton *ApplePay;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)Pay:(UIButton *)sender {
   // 判断是否支持支付功能
    if ([PKPaymentAuthorizationViewController canMakePayments]) {
        
        //初始化订单请求对象
        PKPaymentRequest *requst = [[PKPaymentRequest alloc]init];
        
        //设置商品订单信息对象
        PKPaymentSummaryItem *widget1 = [PKPaymentSummaryItem summaryItemWithLabel:@"火锅" amount:[NSDecimalNumber decimalNumberWithString:@"0.01"]];
        
        requst.paymentSummaryItems = @[widget1 ];
        
        //设置国家地区编码
        requst.countryCode = @"CN";
        //设置国家货币种类 :人民币
        requst.currencyCode = @"CNY";
        //支付支持的网上银行支付方式
        requst.supportedNetworks =  @[PKPaymentNetworkChinaUnionPay, PKPaymentNetworkMasterCard, PKPaymentNetworkVisa];

        //设置的支付范围限制
        requst.merchantCapabilities = PKMerchantCapabilityEMV;
        // 这里填的是就是我们创建的merchat IDs
        requst.merchantIdentifier = @"merchant.dcdApplePay";
        
        //设置支付窗口
        PKPaymentAuthorizationViewController * payVC = [[PKPaymentAuthorizationViewController alloc]initWithPaymentRequest:requst];
        //设置代理
        payVC.delegate = self;
        if (!payVC) {
            //有问题  直接抛出异常
            @throw  [NSException exceptionWithName:@"CQ_Error" reason:@"创建支付显示界面不成功" userInfo:nil];
        }else{
            //支付没有问题,则模态出支付创口
            [self presentViewController:payVC animated:YES completion:nil];
        }
       
    }
}

-(void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didAuthorizePayment:(PKPayment *)payment completion:(void (^)(PKPaymentAuthorizationStatus))completion{
    
    //在这里将token和地址发送到自己的服务器，有自己的服务器与银行和商家进行接口调用和支付将结果返回到这里
    //我们根据结果生成对应的状态对象，根据状态对象显示不同的支付结构
    //状态对象
    NSLog(@"%@",payment.token);
    
    //在这里了 为了测试方便 设置为支付失败的状态
    //可以选择枚举值PKPaymentAuthorizationStatusSuccess   (支付成功)
    PKPaymentAuthorizationStatus staus = PKPaymentAuthorizationStatusFailure;
    completion(staus);
}


//支付完成的代理方法
-(void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"支付完成");
}

@end
