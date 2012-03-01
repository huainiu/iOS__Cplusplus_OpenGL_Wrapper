#import "wrapper.h"

int main(int argc, char *argv[]) {
	NSAutoreleasePool *pool = [NSAutoreleasePool new];
	UIApplicationMain(argc, argv, nil, nil);
	[pool release];
	return 0;
}

//Puntero al wrapper
void *wrapper;

Fase uiphase2wrapfase(UITouchPhase phase);
@implementation GLView (wrap)
-(void)wrapTouches:(UIEvent *)event {
	NSSet *setAllTouches = [event allTouches];
	NSArray *allTouches = [setAllTouches allObjects];
	int nTouches = MULTITOUCH ? [setAllTouches count] : 1;
	Touch *vTouches = malloc(sizeof(Touch)*nTouches);
	
	for(int i = 0; i < nTouches; i++) {
		vTouches[i].fase = uiphase2wrapfase([[allTouches objectAtIndex:i] phase]);
		vTouches[i].nTaps = [[allTouches objectAtIndex:i] tapCount];
		vTouches[i].x = (int)[[allTouches objectAtIndex:i] locationInView:self].x;
		vTouches[i].y = (int)[[allTouches objectAtIndex:i] locationInView:self].y;
	}
	getTouches(vTouches, nTouches);
	
	[delegate write:[NSString stringWithFormat:@"x:%i  y:%i\nnTouches:%i", vTouches[0].x, vTouches[0].y, nTouches]];
	
	free(vTouches);
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[self wrapTouches:event];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[self wrapTouches:event];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	[self wrapTouches:event];
}
@end


@implementation wrapper_AppDelegate
@synthesize window;

- (void)drawView:(GLView*)view;
{
	loop();
}

-(void)setupView:(GLView*)view
{
	setup(view.bounds.size.width, view.bounds.size.height);
}

- (void)applicationDidFinishLaunching:(UIApplication*)application
{
	wrapper = self;
	appID = application;
	
	init();
	
	textView = [[UITextView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, 320.0f, 60.0f)];
    [textView setText:@"Esto es una prueba de texto"];
    
    window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    glView = [[GLView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [window addSubview:glView];
	
	[glView setDelegate:self];
	[glView setAnimationInterval:(1.0 / kRenderingFrequency)];
	[glView addSubview:textView];
		
	[window makeKeyAndVisible];
	
	[self setPantalla:PANORAMICO];
}

-(void)setPantalla:(BOOL)panoramico {
	CGRect rect;
	if(panoramico) {
		[appID setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft animated:NO];
		[[UIDevice currentDevice] setOrientation:UIInterfaceOrientationLandscapeLeft];
		rect = CGRectMake(0.0, 0.0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width);
		[window setFrame:rect];
		[glView setFrame:rect];
		//Rotamos
		int translateDistance = ([[UIScreen mainScreen] bounds].size.width-[[UIScreen mainScreen] bounds].size.height)/2;
		CGAffineTransform landscapeTransform = CGAffineTransformRotate(CGAffineTransformIdentity, -90 / 180.0 * M_PI );
		landscapeTransform = CGAffineTransformTranslate(landscapeTransform, translateDistance, translateDistance);
		[window setTransform:landscapeTransform];
	}
	else {
		[appID setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
		[[UIDevice currentDevice] setOrientation:UIInterfaceOrientationPortrait];
		rect = [[UIScreen mainScreen] bounds];
		[window setFrame:rect];
		[glView setFrame:rect];
		[window setTransform:CGAffineTransformIdentity];
	}
}

-(void)write:(NSString *)cadena {
	[textView setText:[NSString stringWithFormat:@"%@",cadena]];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
	[glView stopAnimation];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application
{
	[textView setText:@"eyyyyyy sin memoria"];
}

-(void)applicationDidBecomeActive:(UIApplication *)application
{
	[glView startAnimation];
}

-(void)applicationWillTerminate:(UIApplication *)application
{
	[glView stopAnimation];
}


- (void)dealloc
{
	[glView release];
	[window release];
	[super dealloc];
}
@end

void wrapSetPantalla(bool panoramico) {
	[(id)wrapper setPantalla:panoramico];
}

Fase uiphase2wrapfase(UITouchPhase phase) {
	switch(phase) {
		case UITouchPhaseBegan:
			return INICIADO;
		case UITouchPhaseStationary:
			return ESTACIONADO;
		case UITouchPhaseMoved:
			return MOVIDO;
		case UITouchPhaseEnded:
			return LEVANTADO;
		case UITouchPhaseCancelled:
		default:
			return CANCELADO;
	}
}