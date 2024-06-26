cmake_minimum_required(VERSION 3.16)
project("plasma-smart-video-wallpaper-reborn")
option(INSTALL_WALLPAPER "Install wallpaper" ON)
option(PACKAGE_WALLPAPER "Package wallpaper" OFF)

set(PROJECT_DEP_VERSION "6.0.0")
set(QT_MIN_VERSION "6.6.0")
set(KF6_MIN_VERSION "6.0.0")
set(KDE_COMPILERSETTINGS_LEVEL "5.85")

find_package(ECM ${KF6_MIN_VERSION} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${ECM_MODULE_PATH})

include(ECMFindQmlModule)
include(ECMQmlModule)

find_package(Qt6 ${QT_MIN_VERSION} REQUIRED COMPONENTS
    Core
    Gui
    Quick
    Multimedia
    Core5Compat
)
find_package(KF6 ${KF6_MIN_VERSION} REQUIRED COMPONENTS
    CoreAddons
    Declarative
)

find_package(KF6Kirigami ${KF6_MIN_VERSION} CONFIG)
set_package_properties(KF6Kirigami PROPERTIES
    DESCRIPTION "A QtQuick based components set"
    PURPOSE "Required"
    TYPE RUNTIME
)

# Get id and version from metadata
file(READ ${CMAKE_CURRENT_SOURCE_DIR}/package/metadata.json METADATA)
string(JSON PLUGIN_ID GET ${METADATA} KPlugin Id)
string(JSON CUR_VERSION GET ${METADATA} KPlugin Version)
message("Plugin Id: ${PLUGIN_ID}")
message("Version: ${CUR_VERSION}")

if(INSTALL_WALLPAPER)
    find_package(Plasma ${PROJECT_DEP_VERSION} REQUIRED)
    plasma_install_package(package ${PLUGIN_ID} wallpapers)
endif()

if(PACKAGE_WALLPAPER)
    # generate wallpaper package
    set(WALLPAPER_FILE "${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME}-v${CUR_VERSION}.zip")
    add_custom_target(wallpaper ALL
        COMMAND rm -rf "${WALLPAPER_FILE}"
        COMMAND ${CMAKE_COMMAND} -E chdir ${CMAKE_CURRENT_SOURCE_DIR}/package zip -r ${WALLPAPER_FILE} ./
        COMMENT "Generating ${WALLPAPER_FILE}"
    )
endif()
