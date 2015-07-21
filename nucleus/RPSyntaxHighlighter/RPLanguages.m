//
//  RPLanguages.m
//  nucleus
//
//  Created by Jeremy Templier on 20/07/15.
//  Copyright (c) 2015 Jeremy Templier. All rights reserved.
//

#import "RPLanguages.h"

@implementation RPLanguages

+ (NSString *)languageForFileExtension:(NSString *)ext {
    if ([ext isEqualToString:@"hx"]) {
        return @"haxe";
    } else if ([ext isEqualToString:@"jack"]) {
        return @"jack";
    } else if ([ext isEqualToString:@"nix"]) {
        return @"nix";
    } else if ([ext isEqualToString:@"abap"]) {
        return @"abap";
    } else if ([ext isEqualToString:@"abc"]) {
        return @"abc";
    } else if ([ext isEqualToString:@"as"]) {
        return @"actionscript";
    } else if ([ext isEqualToString:@"ada"]) {
        return @"ada";
    } else if ([ext isEqualToString:@"asciidoc"]) {
        return @"asciidoc";
    } else if ([ext isEqualToString:@"asm"]) {
        return @"asm-x86";
    } else if ([ext isEqualToString:@"ahk"]) {
        return @"batch";
    } else if ([ext isEqualToString:@"bat"]) {
        return @"batch";
    } else if ([ext isEqualToString:@"c9search_results"]) {
        return @"jack";
    } else if ([ext isEqualToString:@"cpp"]) {
        return @"cpp";
    } else if ([ext isEqualToString:@"cpp"]) {
        return @"cpp";
    } else if ([ext isEqualToString:@"cirru"]) {
        return @"cirru";
    } else if ([ext isEqualToString:@"clj"]) {
        return @"closure";
    } else if ([ext isEqualToString:@"cbl"]) {
        return @"cobol";
    } else if ([ext isEqualToString:@"coffee"]) {
        return @"coffeescript";
    } else if ([ext isEqualToString:@"cfm"]) {
        return @"coldfusion";
    } else if ([ext isEqualToString:@"cs"]) {
        return @"csharp";
    } else if ([ext isEqualToString:@"css"]) {
        return @"css";
    } else if ([ext isEqualToString:@"curly"]) {
        return @"curly";
    } else if ([ext isEqualToString:@"c"]) {
        return @"c";
    } else if ([ext isEqualToString:@"dart"]) {
        return @"dart";
    } else if ([ext isEqualToString:@"dot"]) {
        return @"dot";
    } else if ([ext isEqualToString:@"e"]) {
        return @"eiffel";
    } else if ([ext isEqualToString:@"ejs"]) {
        return @"ejs";
    } else if ([ext isEqualToString:@"ex"]) {
        return @"elixir";
    } else if ([ext isEqualToString:@"elm"]) {
        return @"elm";
    } else if ([ext isEqualToString:@"erl"]) {
        return @"erl";
    } else if ([ext isEqualToString:@"frt"]) {
        return @"fortran";
    } else if ([ext isEqualToString:@"ftl"]) {
        return @"ftl";
    } else if ([ext isEqualToString:@"gcode"]) {
        return @"gcode";
    } else if ([ext isEqualToString:@"feature"]) {
        return @"gherkin";
    } else if ([ext isEqualToString:@"gls"]) {
        return @"gls";
    } else if ([ext isEqualToString:@"go"]) {
        return @"golang";
    } else if ([ext isEqualToString:@"groovy"]) {
        return @"groovy";
    } else if ([ext isEqualToString:@"haml"]) {
        return @"haml";
    } else if ([ext isEqualToString:@"hbs"]) {
        return @"handlebars";
    } else if ([ext isEqualToString:@"hs"]) {
        return @"haskell";
    } else if ([ext isEqualToString:@"htaccess"]) {
        return @"htaccess";
    } else if ([ext isEqualToString:@"html"]) {
        return @"html";
    } else if ([ext isEqualToString:@"erb"]) {
        return @"html";
    } else if ([ext isEqualToString:@"ini"]) {
        return @"apache";
    } else if ([ext isEqualToString:@"io"]) {
        return @"javascript";
    } else if ([ext isEqualToString:@"jade"]) {
        return @"jade";
    } else if ([ext isEqualToString:@"java"]) {
        return @"java";
    } else if ([ext isEqualToString:@"js"]) {
        return @"javascript";
    } else if ([ext isEqualToString:@"json"]) {
        return @"json";
    } else if ([ext isEqualToString:@"jq"]) {
        return @"json";
    } else if ([ext isEqualToString:@"jsp"]) {
        return @"jsp";
    } else if ([ext isEqualToString:@"jsx"]) {
        return @"javafx";
    } else if ([ext isEqualToString:@"jl"]) {
        return @"julia";
    } else if ([ext isEqualToString:@"tex"]) {
        return @"latex";
    } else if ([ext isEqualToString:@"lean"]) {
        return @"lean";
    } else if ([ext isEqualToString:@"less"]) {
        return @"css";
    } else if ([ext isEqualToString:@"liquid"]) {
        return @"liquid";
    } else if ([ext isEqualToString:@"lisp"]) {
        return @"lisp";
    } else if ([ext isEqualToString:@"ls"]) {
        return @"livescript";
    } else if ([ext isEqualToString:@"logic"]) {
        return @"logiql";
    } else if ([ext isEqualToString:@"lsl"]) {
        return @"lsl";
    } else if ([ext isEqualToString:@"lua"]) {
        return @"lua";
    } else if ([ext isEqualToString:@"lp"]) {
        return @"lua";
    } else if ([ext isEqualToString:@"lucene"]) {
        return @"lucene";
    } else if ([ext isEqualToString:@"md"]) {
        return nil;
    } else if ([ext isEqualToString:@"mask"]) {
        return @"mask";
    } else if ([ext isEqualToString:@"matlab"]) {
        return @"matlab";
    } else if ([ext isEqualToString:@"mz"]) {
        return nil;
    } else if ([ext isEqualToString:@"mel"]) {
        return @"mel";
    } else if ([ext isEqualToString:@"mc"]) {
        return nil;
    } else if ([ext isEqualToString:@"mysql"]) {
        return @"mysql";
    } else if ([ext isEqualToString:@"m"]) {
        return @"objectivec";
    } else if ([ext isEqualToString:@"ml"]) {
        return @"objectivecaml";
    } else if ([ext isEqualToString:@"pas"]) {
        return @"pascal";
    } else if ([ext isEqualToString:@"pl"]) {
        return @"perl";
    } else if ([ext isEqualToString:@"pgsql"]) {
        return @"mysql";
    } else if ([ext isEqualToString:@"php"]) {
        return @"php";
    } else if ([ext isEqualToString:@"txt"]) {
        return nil;
    } else if ([ext isEqualToString:@"ps1"]) {
        return nil;
    } else if ([ext isEqualToString:@"praat"]) {
        return nil;
    } else if ([ext isEqualToString:@"plg"]) {
        return @"prolog";
    } else if ([ext isEqualToString:@"properties"]) {
        return nil;
    } else if ([ext isEqualToString:@"proto"]) {
        return nil;
    } else if ([ext isEqualToString:@"py"]) {
        return @"python";
    } else if ([ext isEqualToString:@"r"]) {
        return @"r";
    } else if ([ext isEqualToString:@"Rd"]) {
        return @"html";
    } else if ([ext isEqualToString:@"Rhtml"]) {
        return @"html";
    } else if ([ext isEqualToString:@"rb"]) {
        return @"ruby";
    } else if ([ext isEqualToString:@"rs"]) {
        return nil;
    } else if ([ext isEqualToString:@"sass"]) {
        return @"css";
    } else if ([ext isEqualToString:@"scad"]) {
        return nil;
    } else if ([ext isEqualToString:@"scala"]) {
        return @"scala";
    } else if ([ext isEqualToString:@"scm"]) {
        return nil;
    } else if ([ext isEqualToString:@"scss"]) {
        return @"css";
    } else if ([ext isEqualToString:@"sh"]) {
        return @"shell";
    } else if ([ext isEqualToString:@"sjs"]) {
        return nil;
    } else if ([ext isEqualToString:@"smarty"]) {
        return nil;
    } else if ([ext isEqualToString:@"snippets"]) {
        return nil;
    } else if ([ext isEqualToString:@"soy"]) {
        return nil;
    } else if ([ext isEqualToString:@"space"]) {
        return nil;
    } else if ([ext isEqualToString:@"sql"]) {
        return @"sql";
    } else if ([ext isEqualToString:@"sqlserver"]) {
        return @"sql";
    } else if ([ext isEqualToString:@"svg"]) {
        return nil;
    } else if ([ext isEqualToString:@"styl"]) {
        return nil;
    } else if ([ext isEqualToString:@"tcl"]) {
        return @"tcltk";
    } else if ([ext isEqualToString:@"tex"]) {
        return nil;
    } else if ([ext isEqualToString:@"textile"]) {
        return nil;
    } else if ([ext isEqualToString:@"toml"]) {
        return nil;
    } else if ([ext isEqualToString:@"twig"]) {
        return nil;
    } else if ([ext isEqualToString:@"ts"]) {
        return nil;
    } else if ([ext isEqualToString:@"vala"]) {
        return nil;
    } else if ([ext isEqualToString:@"vbs"]) {
        return @"vb";
    } else if ([ext isEqualToString:@"vm"]) {
        return nil;
    } else if ([ext isEqualToString:@"v"]) {
        return @"verilog";
    } else if ([ext isEqualToString:@"vhd"]) {
        return @"vhdl";
    } else if ([ext isEqualToString:@"xml"]) {
        return @"xml";
    } else if ([ext isEqualToString:@"xq"]) {
        return nil;
    } else if ([ext isEqualToString:@"yaml"]) {
        return nil;
    }
    return nil;
}

@end
