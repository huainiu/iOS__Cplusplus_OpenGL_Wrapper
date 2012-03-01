#import "GLView.h"
#import "global.h"

@interface wrapper_AppDelegate : NSObject <UIApplicationDelegate, GLTriangleViewDelegate>
{
	UIWindow* window;
	GLView *glView;
	UITextView *textView;
	UIApplication *appID;
}
@property (nonatomic, retain) IBOutlet UIWindow *window;
-(void)setPantalla:(BOOL)panoramico;
-(void)write:(NSString *)cadena;
@end
