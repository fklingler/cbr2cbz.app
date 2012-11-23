//
//  main.m
//  cbr2cbz-app
//
//  Created by François KLINGLER on 23/11/12.
//  Copyright (c) 2012 François KLINGLER. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import <MacRuby/MacRuby.h>

int main(int argc, char *argv[])
{
    return macruby_main("rb_main.rb", argc, argv);
}
