//
//  DGWeakifyStongifyMacro.h
//  iOSCalendar
//
//  Created by Daniel Gaston
//  Copyright © 2018 DG. All rights reserved.
//
#import "DGClangMacro.h"

#define DGEmpty

#define DGWeakify(obj) \
    __weak typeof(obj) __weak_##obj = obj

#define DGStrongify(obj) \
    DGClangDiagnosticPushOption("clang diagnostic ignored \"-Wshadow\"") \
    __strong typeof(obj) obj = __weak_##obj \
    DGClangDiagnosticPopOption

#define DGStrongifyAndReturnValueIfNil(obj, returnValue) \
    DGStrongify(obj); \
    if (!obj) { \
        return returnValue; \
    }

#define DGStrongifyAndReturnNilIfNil(obj) \
    DGStrongifyAndReturnValueIfNil(obj, nil)

#define DGStrongifyAndReturnIfNil(obj) \
    DGStrongifyAndReturnValueIfNil(obj, DGEmpty)
