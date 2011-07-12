//
//  PickerAppDelegate.m
//  Picker
//
//  Created by Steven Troughton-Smith on 25/09/2009.
//  Copyright 2009 Steven Troughton-Smith. All rights reserved.
//

#import "PickerAppDelegate.h"

/* A few private APIs we need */

@interface NSToolbarView : NSView // Private API!

-(NSToolbar *)toolbar;

@end

@interface NSColorPanel (_STS_PickerExtras)

-(NSView *)_toolbarView;

@end

@interface NSStatusItem (_STS_PickerExtras)

-(NSWindow *)_window;

@end

@implementation PickerAppDelegate

@synthesize mainView;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	
	_statusItem = [[[NSStatusBar systemStatusBar]
					statusItemWithLength:NSSquareStatusItemLength] retain];

	[_statusItem setImage:[NSImage imageNamed:@"wheel"]];
	
	[_statusItem setTarget:self];
	[_statusItem setAction:@selector(menuWillOpen:)];

	NSColorPanel *picker = [NSColorPanel sharedColorPanel];
	NSToolbarView *toolbar = [picker _toolbarView];  // Private API
	NSView *content = [picker contentView];
	
	NSToolbar *tb = nil;
	
	if ([toolbar respondsToSelector:@selector(toolbar)])
	{
		/* Private API ! */
		tb = [toolbar toolbar];
	}
	
	if (tb)
	{		
		BOOL insert = YES;
		
		for (NSToolbarItem *item in [tb items])
		{
			if ([[item itemIdentifier] isEqualToString:@"com.steventroughtonsmith.picker.settings"])
				insert = NO;
		}
		
		if (insert)
		{	
			NSToolbarItem *settingsMenuItem = [[NSToolbarItem alloc] initWithItemIdentifier:@"com.steventroughtonsmith.picker.settings"];
			[settingsMenuItem setLabel:@"Settings"];
			
			
			NSPopUpButton *sb = [[NSPopUpButton alloc] initWithFrame:NSMakeRect(0, 0, 42, 29) pullsDown:NO];
			[sb setImage:[NSImage imageNamed:@"NSAdvanced"]];
			//[sb setBezelStyle:NSRecessedBezelStyle];
			[sb setBordered:NO];
			
			NSMenu *settingsMenu = [[NSMenu	alloc] initWithTitle:@"Settings"];
			
			[sb setMenu:[self createSettingsMenu]];
			
			
			[settingsMenuItem setView:sb];
			
			[tb _insertItem:settingsMenuItem atIndex:0 notifyDelegate:YES notifyView:YES notifyFamilyAndUpdateDefaults:YES]; // Private API
			[settingsMenuItem release];	
		}
	}
}


-(void)menuWillOpen:(NSMenu *)s
{
	NSColorPanel *colorPanel = [NSColorPanel sharedColorPanel];
	if ([colorPanel isVisible]) {
		[colorPanel close];
	} else {
		NSRect frame = NSMakeRect(0, 0, 320, 410);
		frame.origin.x = [[_statusItem _window] frame].origin.x-5;
		frame.origin.y = [[_statusItem _window] frame].origin.y - frame.size.height;

		[colorPanel setFrame:frame display:YES];
		[colorPanel setFloatingPanel:YES];
		[colorPanel setWorksWhenModal:YES];
		[colorPanel setHidesOnDeactivate:NO];
		[NSApp orderFrontColorPanel:self];
	}
}


- (NSMenu *) createSettingsMenu {
	NSZone *menuZone = [NSMenu menuZone];
	NSMenu *menu = [[NSMenu allocWithZone:menuZone] init];
	NSMenuItem *menuItem;
	
	menuItem = [menu addItemWithTitle:@""
					action:nil
			 keyEquivalent:@""];
	
	[menuItem setHidden:YES];
	
	NSImage *gearImg = [NSImage imageNamed:@"NSAdvanced"];
	[gearImg setSize:NSMakeSize(16., 16.)];
	
	[menuItem setImage:gearImg];
	
	
	menuItem = [menu addItemWithTitle:@"Quit"
							   action:@selector(quit)
						keyEquivalent:@""];
	[menuItem setTarget:self];
	
	
	return [menu autorelease];
}


-(void)quit
{
	[[NSApplication sharedApplication] terminate:self];
}


- (NSMenu *) createMenu {
	NSZone *menuZone = [NSMenu menuZone];
	NSMenu *menu = [[NSMenu allocWithZone:menuZone] init];
	NSMenuItem *menuItem;
	
	menuItem = [menu addItemWithTitle:@"Picker"
							   action:nil
						keyEquivalent:@""];
	[menuItem setTarget:self];
	

	return [menu autorelease];
}


@end
