//
//  GLView.h
//  NeHe Lesson 02
//
//  Created by Jeff LaMarche on 12/11/08.
//  Copyright Jeff LaMarche Consulting 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

@protocol GLTriangleViewDelegate;

@interface GLView : UIView
{
	@private
	// The pixel dimensions of the backbuffer
	GLint backingWidth;
	GLint backingHeight;
	
	EAGLContext *context;
	GLuint viewRenderbuffer, viewFramebuffer;
	GLuint depthRenderbuffer;
	BOOL displayLinkSupported;
	id displayLink;
	NSTimer *animationTimer;
	NSTimeInterval animationInterval;

	id<GLTriangleViewDelegate> delegate;
	BOOL delegateSetup;
}

@property(nonatomic, assign) id<GLTriangleViewDelegate> delegate;

-(void)startAnimation;
-(void)stopAnimation;
-(void)drawView;

@property NSTimeInterval animationInterval;

@end

//Implementado en el wrapper
@interface GLView (wrap)
-(void)wrapTouches:(UIEvent *)event;
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
@end

@protocol GLTriangleViewDelegate<NSObject>

@required
-(void)drawView:(GLView*)view;

@optional
-(void)setupView:(GLView*)view;
-(void)write:(NSString *)cadena;

@end