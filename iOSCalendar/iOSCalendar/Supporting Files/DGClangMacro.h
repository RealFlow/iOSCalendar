//
//  DGClangMacro.h
//  iOSCalendar
//
//  Created by Daniel Gaston
//  Copyright © 2018 DG. All rights reserved.
//

#define DGClangDiagnosticPush _Pragma("clang diagnostic push")
#define DGClangDiagnosticPop _Pragma("clang diagnostic pop")

#define DGClangDiagnosticPushOption(option) \
    DGClangDiagnosticPush \
    _Pragma(option)

#define DGClangDiagnosticPopOption DGClangDiagnosticPop
