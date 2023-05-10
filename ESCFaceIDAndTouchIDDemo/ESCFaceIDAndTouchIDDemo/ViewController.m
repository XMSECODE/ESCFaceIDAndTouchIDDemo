//
//  ViewController.m
//  ESCFaceIDAndTouchIDDemo
//
//  Created by xiatian on 2023/5/10.
//

#import "ViewController.h"
#import<LocalAuthentication/LocalAuthentication.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self getLocalAuthentication];
}


- (void)getLocalAuthentication {
    
    LAContext *context = [[LAContext alloc] init];
    NSError*error =nil;
    /*
     LAPolicyDeviceOwnerAuthenticationWithBiometrics    使用TouchID 或者FaceID验证
     LAPolicyDeviceOwnerAuthentication      使用TouchID或者FaceID或者密码验证,默认是错误三次指纹或者锁定后,弹出输入密码界面
     */
    // 判断设备是否支持指纹识别
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error]) {
        
        LABiometryType type = context.biometryType;
//        类型
        if(type == LABiometryTypeTouchID){
//            TouchID
        }else if(type == LABiometryTypeFaceID){
//            FaceID
        }
        
        //支持 localizedReason为alert弹框的message内容
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请验证已有指纹" reply:^(BOOL success, NSError * _Nullable error) {
            if(success) {
                NSLog(@"面容/指纹验证通过");
                //在这里登录操作
            }else{
                NSLog(@"验证失败:%@",error.description);
                switch(error.code) {
                    case LAErrorSystemCancel:
                    {
                        NSLog(@"系统取消授权，如其他APP切入");
                        break;
                    }
                    case LAErrorUserCancel:
                    {
                        NSLog(@"用户取消验证Touch ID");
                    }
                    case LAErrorAuthenticationFailed:
                    {
                        NSLog(@"授权失败");
                        break;
                    }
                    case LAErrorPasscodeNotSet:
                    {
                        NSLog(@"系统未设置密码");
                        break;
                    }
                    case LAErrorBiometryNotAvailable:
                    {
                        NSLog(@"设备Touch ID不可用，例如未打开");
                        break;
                    }
                    case LAErrorBiometryNotEnrolled:
                    {
                        NSLog(@"设备Touch ID不可用，用户未录入");
                        break;
                    }
                    case LAErrorUserFallback:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            NSLog(@"用户选择输入密码，切换主线程处理");
                        }];
                        break;
                    }
                    default:
                    {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                        NSLog(@"其他情况，切换主线程处理");
                        }];
                    break;
                    }
                }
            }
        }];
    }else{
        LABiometryType type = context.biometryType;
        NSLog(@"未设置面容/指纹： %ld", (long)type); // 无指纹/面容 0  指纹 1 面容 2
        NSLog(@"error : %@",error.description);
    }
  
}
@end
