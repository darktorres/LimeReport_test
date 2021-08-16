equals(QT_MAJOR_VERSION, 5):greaterThan(QT_MINOR_VERSION, 12){
DEFINES *= QT_NO_DEPRECATED_WARNINGS
}

isEmpty(BINARY_RESULT_DIR) {
    BINARY_RESULT_DIR = $${PWD}
}

!contains(CONFIG, no_build_translations){
    CONFIG += build_translations
}


!contains(CONFIG, no_zint){
    CONFIG *= zint
}

!contains(CONGIG, no_svg){
    QT *= svg
    CONFIG *= svg
    DEFINES += HAVE_SVG
}

INCLUDEPATH += $$PWD/3rdparty/easyprofiler/easy_profiler_core/include
DEPENDPATH += $$PWD/3rdparty/easyprofiler/easy_profiler_core/include

#CONFIG *= easy_profiler

contains(CONFIG, easy_profiler){
    message(EasyProfiler)
    unix|win32: LIBS += -L$$PWD/3rdparty/easyprofiler/build/bin/ -leasy_profiler
    equals(QT_MAJOR_VERSION, 5){
        DEFINES += BUILD_WITH_EASY_PROFILER
    }
}

!contains(CONFIG, qtscriptengine){
    equals(QT_MAJOR_VERSION, 4){
        CONFIG *= qtscriptengine
    }
    equals(QT_MAJOR_VERSION, 5){
        lessThan(QT_MINOR_VERSION, 6){ # 5.0 to 5.5
            CONFIG *= qtscriptengine
        }
        greaterThan(QT_MINOR_VERSION, 5){ # 5.6 to 5.15
            CONFIG *= qjsengine
        }
    }
}

contains(CONFIG, qtscriptengine){
    CONFIG -= qjsengine
    QT *= script
    DEFINES *= USE_QTSCRIPTENGINE
    message(qtscriptengine)
}

!contains(CONFIG, no_formdesigner){
    CONFIG *= dialogdesigner
}

!contains(CONFIG, no_embedded_designer){
    CONFIG *= embedded_designer
    DEFINES += HAVE_REPORT_DESIGNER
    message(embedded designer)
}

contains(CONFIG, zint){
    ZINT_PATH = $$PWD/3rdparty/zint-2.6.1
    ZINT_VERSION = 2.6.1
    DEFINES *= HAVE_ZINT
    INCLUDEPATH += $$ZINT_PATH/backend $$ZINT_PATH/backend_qt
    DEPENDPATH += $$ZINT_PATH/backend $$ZINT_PATH/backend_qt
}

equals(QT_MAJOR_VERSION, 4){
    CONFIG *= uitools
}

equals(QT_MAJOR_VERSION, 5){
    QT *= uitools
}

CONFIG(release, debug|release){
    message(Release)
    BUILD_TYPE = release
}else{
    message(Debug)
    BUILD_TYPE = debug
}

BUILD_DIR = $${BINARY_RESULT_DIR}/build/$${QT_VERSION}

DEST_INCLUDE_DIR = $$PWD/include

unix{
    ARCH_DIR = $${OUT_PWD}/unix
    ARCH_TYPE = unix
    macx{
        ARCH_DIR = $${OUT_PWD}/macx
        ARCH_TYPE = macx
    }
    linux{
        !contains(QT_ARCH, x86_64){
            message("Compiling for 32bit system")
            ARCH_DIR = $${OUT_PWD}/linux32
            ARCH_TYPE = linux32
        }else{
            message("Compiling for 64bit system")
            ARCH_DIR = $${OUT_PWD}/linux64
            ARCH_TYPE = linux64
        }
    }
}

win32 {
    !contains(QT_ARCH, x86_64) {
        message("Compiling for 32bit system")
        ARCH_DIR = $${OUT_PWD}/win32
        ARCH_TYPE = win32
    } else {
        message("Compiling for 64bit system")
        ARCH_DIR = $${OUT_PWD}/win64
        ARCH_TYPE = win64
    }
}

DEST_LIBS = $${BUILD_DIR}/$${ARCH_TYPE}/$${BUILD_TYPE}/lib
DEST_BINS = $${BUILD_DIR}/$${ARCH_TYPE}/$${BUILD_TYPE}/$${TARGET}

MOC_DIR        = $${ARCH_DIR}/$${BUILD_TYPE}/moc
UI_DIR         = $${ARCH_DIR}/$${BUILD_TYPE}/ui
UI_HEADERS_DIR = $${ARCH_DIR}/$${BUILD_TYPE}/ui
UI_SOURCES_DIR = $${ARCH_DIR}/$${BUILD_TYPE}/ui
OBJECTS_DIR    = $${ARCH_DIR}/$${BUILD_TYPE}/obj
RCC_DIR        = $${ARCH_DIR}/$${BUILD_TYPE}/rcc

LIMEREPORT_VERSION_MAJOR = 1
LIMEREPORT_VERSION_MINOR = 5
LIMEREPORT_VERSION_RELEASE = 87

LIMEREPORT_VERSION = '$${LIMEREPORT_VERSION_MAJOR}.$${LIMEREPORT_VERSION_MINOR}.$${LIMEREPORT_VERSION_RELEASE}'
DEFINES *= LIMEREPORT_VERSION_STR=\\\"$${LIMEREPORT_VERSION}\\\"

QT *= xml sql

REPORT_PATH = $$PWD/limereport
TRANSLATIONS_PATH = $$PWD/translations

equals(QT_MAJOR_VERSION, 4){
    DEFINES *= HAVE_QT4
    CONFIG(uitools){
        message(uitools)
        DEFINES *= HAVE_UI_LOADER
    }
}

equals(QT_MAJOR_VERSION, 5) {
    DEFINES *= HAVE_QT5
    QT *= printsupport widgets
    contains(QT,uitools){
        message(uitools)
        DEFINES *= HAVE_UI_LOADER
    }
    contains(CONFIG, qjsengine){
        message(qjsengine)
        DEFINES *= USE_QJSENGINE
        QT *= qml
    }
}
