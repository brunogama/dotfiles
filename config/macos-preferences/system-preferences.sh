#!/usr/bin/env bash
# macOS Preferences Restoration Script
# Generated on: Thu Sep 11 15:17:55 -03 2025
# Machine: Naboo
# User: bruno
# macOS Version: 26.0

set -euo pipefail

# Preference restoration
echo 'Restoring macOS preferences...'

# com.apple.dock preferences
echo 'Setting com.apple.dock preferences...'
# {
#     autohide = 1;
#     "autohide-delay" = 0;
#     "autohide-time-modifier" = 0;
#     "enable-spring-load-actions-on-all-items" = 1;
#     "last-analytics-stamp" =     (
#         "778718507.124264"
#     );
#     lastShowIndicatorTime = "779179192.053506";
#     launchanim = 0;
#     loc = "en_US:BR";
#     mineffect = scale;
#     "minimize-to-application" = 1;
#     "mod-count" = 534;
#     "mouse-over-hilite-stack" = 1;
#     orientation = bottom;
#     "persistent-apps" =     (
#                 {
#             GUID = 1707297554;
#             "tile-data" =             {
#                 book = {length = 552, bytes = 0x626f6f6b 28020000 00000410 30000000 ... 04000000 00000000 };
#                 "bundle-identifier" = "dev.warp.Warp-Stable";
#                 "dock-extra" = 1;
#                 "file-data" =                 {
#                     "_CFURLString" = "file:///Applications/Warp.app/";
#                     "_CFURLStringType" = 15;
#                 };
#                 "file-label" = Warp;
#                 "file-mod-date" = 6313147255060;
#                 "file-type" = 41;
#                 "is-beta" = 0;
#                 "parent-mod-date" = 142467905629050;
#             };
#             "tile-type" = "file-tile";
#         },
#                 {
#             GUID = 2633207129;
#             "tile-data" =             {
#                 book = {length = 552, bytes = 0x626f6f6b 28020000 00000410 30000000 ... 04000000 00000000 };
#                 "bundle-identifier" = "app.zen-browser.zen";
#                 "dock-extra" = 0;
#                 "file-data" =                 {
#                     "_CFURLString" = "file:///Applications/Zen.app/";
#                     "_CFURLStringType" = 15;
#                 };
#                 "file-label" = Zen;
#                 "file-mod-date" = 126958776433887;
#                 "file-type" = 41;
#                 "is-beta" = 0;
#                 "parent-mod-date" = 39680746783291;
#             };
#             "tile-type" = "file-tile";
#         },
#                 {
#             "tile-data" =             {
#                 book = {length = 556, bytes = 0x626f6f6b 2c020000 00000410 30000000 ... 04000000 00000000 };
#                 "bundle-identifier" = "com.todesktop.230313mzl4w4u92";
#                 "dock-extra" = 0;
#                 "file-data" =                 {
#                     "_CFURLString" = "file:///Applications/Cursor.app/";
#                     "_CFURLStringType" = 15;
#                 };
#                 "file-label" = Cursor;
#                 "file-mod-date" = 2398388400;
#                 "file-type" = 41;
#                 "is-beta" = 0;
#                 "parent-mod-date" = 13958189181063;
#             };
#             "tile-type" = "file-tile";
#         },
#                 {
#             GUID = 2352989775;
#             "tile-data" =             {
#                 book = {length = 572, bytes = 0x626f6f6b 3c020000 00000410 30000000 ... 04000000 00000000 };
#                 "bundle-identifier" = "com.apple.dt.Xcode";
#                 "dock-extra" = 0;
#                 "file-data" =                 {
#                     "_CFURLString" = "file:///Applications/Xcode-beta.app/";
#                     "_CFURLStringType" = 15;
#                 };
#                 "file-label" = "Xcode-beta";
#                 "file-mod-date" = 3838012591;
#                 "file-type" = 41;
#                 "is-beta" = 0;
#                 "parent-mod-date" = 145182323447901;
#             };
#             "tile-type" = "file-tile";
#         },
#                 {
#             GUID = 2655251396;
#             "tile-data" =             {
#                 book = {length = 1120, bytes = 0x626f6f6b 60040000 00000410 30000000 ... 04000000 00000000 };
#                 "bundle-identifier" = "com.apple.Safari";
#                 "dock-extra" = 0;
#                 "file-data" =                 {
#                     "_CFURLString" = "file:///System/Volumes/Preboot/Cryptexes/App/System/Applications/Safari.app/";
#                     "_CFURLStringType" = 15;
#                 };
#                 "file-label" = Safari;
#                 "file-mod-date" = 3835663533;
#                 "file-type" = 41;
#                 "is-beta" = 0;
#                 "parent-mod-date" = 3835663533;
#             };
#             "tile-type" = "file-tile";
#         }
#     );
#     "persistent-others" =     (
#                 {
#             GUID = 2377292569;
#             "tile-data" =             {
#                 arrangement = 2;
#                 book = {length = 668, bytes = 0x626f6f6b 9c020000 00000410 30000000 ... 04000000 00000000 };
#                 displayas = 0;
#                 "file-data" =                 {
#                     "_CFURLString" = "file:///Users/bruno/Downloads/";
#                     "_CFURLStringType" = 15;
#                 };
#                 "file-label" = Downloads;
#                 "file-mod-date" = 99677135385958;
#                 "file-type" = 2;
#                 "is-beta" = 0;
#                 "parent-mod-date" = 50383795467773;
#                 preferreditemsize = "-1";
#                 showas = 0;
#             };
#             "tile-type" = "directory-tile";
#         }
#     );
#     "recent-apps" =     (
#     );
#     region = BR;
#     "show-process-indicators" = 1;
#     "show-recents" = 0;
#     showhidden = 1;
#     tilesize = 70;
#     "trash-full" = 1;
#     version = 1;
#     "wvous-br-corner" = 14;
# }

# com.apple.finder preferences
echo 'Setting com.apple.finder preferences...'
# {
#     AppleShowAllFiles = 1;
#     BulkLastFormatter = 0;
#     BulkRenameAddNumberTo = 0;
#     BulkRenameAddTextText = ".txt";
#     BulkRenameAddTextTo = 0;
#     BulkRenameFindText = ".mdc.txt";
#     BulkRenameName = "File ";
#     BulkRenamePlaceNumberAt = 0;
#     BulkRenameReplaceText = ".md";
#     BulkRenameStartIndex = 1;
#     ComputerViewSettings =     {
#         CustomViewStyleVersion = 1;
#         ExtendedListViewSettingsV2 =         {
#             axTextSize = 13;
#             calculateAllSizes = 0;
#             columns =             (
#                                 {
#                     ascending = 1;
#                     identifier = name;
#                     visible = 1;
#                     width = 300;
#                 },
#                                 {
#                     ascending = 0;
#                     identifier = ubiquity;
#                     visible = 0;
#                     width = 35;
#                 },
#                                 {
#                     ascending = 0;
#                     identifier = dateModified;
#                     visible = 1;
#                     width = 181;
#                 },
#                                 {
#                     ascending = 0;
#                     identifier = dateCreated;
#                     visible = 0;
#                     width = 181;
#                 },
#                                 {
#                     ascending = 0;
#                     identifier = size;
#                     visible = 1;
#                     width = 97;
#                 },
#                                 {
#                     ascending = 1;
#                     identifier = kind;
#                     visible = 1;
#                     width = 115;
#                 },
#                                 {
#                     ascending = 1;
#                     identifier = label;
#                     visible = 0;
#                     width = 100;
#                 },
#                                 {
#                     ascending = 1;
#                     identifier = version;
#                     visible = 0;
#                     width = 75;
#                 },
#                                 {
#                     ascending = 1;
#                     identifier = comments;
#                     visible = 0;
#                     width = 300;
#                 },
#                                 {
#                     ascending = 0;
#                     identifier = dateLastOpened;
#                     visible = 0;
#                     width = 200;
#                 },
#                                 {
#                     ascending = 0;
#                     identifier = shareOwner;
#                     visible = 0;
#                     width = 200;
#                 },
#                                 {
#                     ascending = 0;
#                     identifier = shareLastEditor;
#                     visible = 0;
#                     width = 200;
#                 },
#                                 {
#                     ascending = 0;
#                     identifier = dateAdded;
#                     visible = 0;
#                     width = 181;
#                 },
#                                 {
#                     ascending = 0;
#                     identifier = invitationStatus;
#                     visible = 0;
#                     width = 210;
#                 }
#             );
#             iconSize = 16;
#             scrollPositionX = "-147.5";
#             scrollPositionY = 0;
#             showIconPreview = 1;
#             sortColumn = name;
#             textSize = 13;
#             useRelativeDates = 1;
#             viewOptionsVersion = 1;
#         };
#         ListViewSettings =         {
#             axTextSize = 13;
#             calculateAllSizes = 0;
#             columns =             {
#                 comments =                 {
#                     ascending = 1;
#                     index = 7;
#                     visible = 0;
#                     width = 300;
#                 };
#                 dateCreated =                 {
#                     ascending = 0;
#                     index = 2;
#                     visible = 0;
#                     width = 181;
#                 };
#                 dateLastOpened =                 {
#                     ascending = 0;
#                     index = 8;
#                     visible = 0;
#                     width = 200;
#                 };
#                 dateModified =                 {
#                     ascending = 0;
#                     index = 1;
#                     visible = 1;
#                     width = 181;
#                 };
#                 kind =                 {
#                     ascending = 1;
#                     index = 4;
#                     visible = 1;
#                     width = 115;
#                 };
#                 label =                 {
#                     ascending = 1;
#                     index = 5;
#                     visible = 0;
#                     width = 100;
#                 };
#                 name =                 {
#                     ascending = 1;
#                     index = 0;
#                     visible = 1;
#                     width = 300;
#                 };
#                 size =                 {
#                     ascending = 0;
#                     index = 3;
#                     visible = 1;
#                     width = 97;
#                 };
#                 version =                 {
#                     ascending = 1;
#                     index = 6;
#                     visible = 0;
#                     width = 75;
#                 };
#             };
#             iconSize = 16;
#             scrollPositionX = "-147.5";
#             scrollPositionY = 0;
#             showIconPreview = 1;
#             sortColumn = name;
#             textSize = 13;
#             useRelativeDates = 1;
#             viewOptionsVersion = 1;
#         };
#         WindowState =         {
#             ContainerShowSidebar = 1;
#             ShowSidebar = 1;
#             ShowStatusBar = 1;
#             ShowTabView = 0;
#             ShowToolbar = 1;
#             WindowBounds = "{{0, 93}, {1512, 855}}";
#         };
#     };
#     CopyProgressWindowLocation = "{406, 220}";
#     DataSeparatedDisplayNameCache = "";
#     DesktopViewSettings =     {
#         IconViewSettings =         {
#             arrangeBy = none;
#             backgroundColorBlue = 1;
#             backgroundColorGreen = 1;
#             backgroundColorRed = 1;
#             backgroundType = 0;
#             gridOffsetX = 0;
#             gridOffsetY = 0;
#             gridSpacing = 54;
#             iconSize = 64;
#             labelOnBottom = 1;
#             showIconPreview = 1;
#             showItemInfo = 0;
#             textSize = 12;
#             viewOptionsVersion = 1;
#         };
#     };
#     DisableAllAnimations = 1;
#     DownloadsFolderListViewSettingsVersion = 1;
#     EmptyTrashProgressWindowLocation = "{556, 242}";
#     EmptyTrashSecurely = 1;
#     "FK_AppCentricShowSidebar" = 1;
#     "FK_DefaultIconViewSettings" =     {
#         arrangeBy = name;
#         backgroundColorBlue = 1;
#         backgroundColorGreen = 1;
#         backgroundColorRed = 1;
#         backgroundType = 0;
#         gridOffsetX = 0;
#         gridOffsetY = 0;
#         gridSpacing = 54;
#         iconSize = 64;
#         labelOnBottom = 1;
#         showIconPreview = 1;
#         showItemInfo = 1;
#         textSize = 12;
#         viewOptionsVersion = 1;
#     };
#     "FK_DefaultListViewSettingsV2" =     {
#         calculateAllSizes = 0;
#         columns =         (
#                         {
#                 ascending = 1;
#                 identifier = name;
#                 visible = 1;
#                 width = 232;
#             },
#                         {
#                 ascending = 0;
#                 identifier = ubiquity;
#                 visible = 0;
#                 width = 35;
#             },
#                         {
#                 ascending = 0;
#                 identifier = dateModified;
#                 visible = 0;
#                 width = 181;
#             },
#                         {
#                 ascending = 0;
#                 identifier = dateCreated;
#                 visible = 0;
#                 width = 181;
#             },
#                         {
#                 ascending = 0;
#                 identifier = size;
#                 visible = 1;
#                 width = 97;
#             },
#                         {
#                 ascending = 1;
#                 identifier = kind;
#                 visible = 1;
#                 width = 115;
#             },
#                         {
#                 ascending = 1;
#                 identifier = label;
#                 visible = 0;
#                 width = 100;
#             },
#                         {
#                 ascending = 1;
#                 identifier = version;
#                 visible = 0;
#                 width = 75;
#             },
#                         {
#                 ascending = 1;
#                 identifier = comments;
#                 visible = 0;
#                 width = 300;
#             },
#                         {
#                 ascending = 0;
#                 identifier = dateLastOpened;
#                 visible = 0;
#                 width = 193;
#             },
#                         {
#                 ascending = 0;
#                 identifier = shareOwner;
#                 visible = 0;
#                 width = 200;
#             },
#                         {
#                 ascending = 0;
#                 identifier = shareLastEditor;
#                 visible = 0;
#                 width = 200;
#             },
#                         {
#                 ascending = 0;
#                 identifier = dateAdded;
#                 visible = 1;
#                 width = 181;
#             },
#                         {
#                 ascending = 0;
#                 identifier = invitationStatus;
#                 visible = 0;
#                 width = 210;
#             }
#         );
#         iconSize = 16;
#         showIconPreview = 1;
#         sortColumn = name;
#         textSize = 13;
#         useRelativeDates = 1;
#         viewOptionsVersion = 1;
#     };
#     "FK_SearchListViewSettingsV2" =     {
#         calculateAllSizes = 0;
#         columns =         (
#                         {
#                 ascending = 1;
#                 identifier = name;
#                 visible = 1;
#                 width = 424;
#             },
#                         {
#                 ascending = 0;
#                 identifier = ubiquity;
#                 visible = 0;
#                 width = 35;
#             },
#                         {
#                 ascending = 0;
#                 identifier = dateModified;
#                 visible = 1;
#                 width = 181;
#             },
#                         {
#                 ascending = 0;
#                 identifier = dateCreated;
#                 visible = 0;
#                 width = 181;
#             },
#                         {
#                 ascending = 0;
#                 identifier = size;
#                 visible = 1;
#                 width = 97;
#             },
#                         {
#                 ascending = 1;
#                 identifier = kind;
#                 visible = 1;
#                 width = 115;
#             },
#                         {
#                 ascending = 1;
#                 identifier = label;
#                 visible = 0;
#                 width = 100;
#             },
#                         {
#                 ascending = 1;
#                 identifier = version;
#                 visible = 0;
#                 width = 75;
#             },
#                         {
#                 ascending = 1;
#                 identifier = comments;
#                 visible = 0;
#                 width = 300;
#             },
#                         {
#                 ascending = 0;
#                 identifier = dateLastOpened;
#                 visible = 0;
#                 width = 200;
#             },
#                         {
#                 ascending = 0;
#                 identifier = shareOwner;
#                 visible = 0;
#                 width = 200;
#             },
#                         {
#                 ascending = 0;
#                 identifier = shareLastEditor;
#                 visible = 0;
#                 width = 200;
#             },
#                         {
#                 ascending = 0;
#                 identifier = dateAdded;
#                 visible = 0;
#                 width = 181;
#             },
#                         {
#                 ascending = 0;
#                 identifier = invitationStatus;
#                 visible = 0;
#                 width = 210;
#             }
#         );
#         iconSize = 16;
#         showIconPreview = 1;
#         sortColumn = name;
#         textSize = 13;
#         useRelativeDates = 1;
#         viewOptionsVersion = 1;
#     };
#     "FK_SidebarWidth" = 141;
#     "FK_SidebarWidth2" = 139;
#     "FK_StandardViewOptions2" =     {
#         ColumnViewOptions =         {
#             ArrangeBy = dnam;
#             ColumnShowFolderArrow = 1;
#             ColumnShowIcons = 1;
#             ColumnWidth = 245;
#             FontSize = 13;
#             PreviewDisclosureState = 1;
#             SharedArrangeBy = kipl;
#             ShowIconThumbnails = 1;
#             ShowPreview = 1;
#         };
#     };
#     "FK_StandardViewSettings" =     {
#         ExtendedListViewSettingsV2 =         {
#             calculateAllSizes = 0;
#             columns =             (
#                                 {
#                     ascending = 1;
#                     identifier = name;
#                     visible = 1;
#                     width = 300;
#                 },
#                                 {
#                     ascending = 0;
#                     identifier = dateModified;
#                     visible = 1;
#                     width = 181;
#                 },
#                                 {
#                     ascending = 0;
#                     identifier = dateCreated;
#                     visible = 0;
#                     width = 181;
#                 },
#                                 {
#                     ascending = 0;
#                     identifier = size;
#                     visible = 1;
#                     width = 97;
#                 },
#                                 {
#                     ascending = 1;
#                     identifier = kind;
#                     visible = 1;
#                     width = 115;
#                 },
#                                 {
#                     ascending = 1;
#                     identifier = label;
#                     visible = 0;
#                     width = 100;
#                 },
#                                 {
#                     ascending = 1;
#                     identifier = version;
#                     visible = 0;
#                     width = 75;
#                 },
#                                 {
#                     ascending = 1;
#                     identifier = comments;
#                     visible = 0;
#                     width = 300;
#                 },
#                                 {
#                     ascending = 0;
#                     identifier = dateLastOpened;
#                     visible = 0;
#                     width = 200;
#                 },
#                                 {
#                     ascending = 0;
#                     identifier = shareOwner;
#                     visible = 0;
#                     width = 200;
#                 },
#                                 {
#                     ascending = 0;
#                     identifier = shareLastEditor;
#                     visible = 0;
#                     width = 200;
#                 }
#             );
#             iconSize = 16;
#             showIconPreview = 1;
#             sortColumn = name;
#             textSize = 13;
#             useRelativeDates = 1;
#             viewOptionsVersion = 1;
#         };
#         IconViewSettings =         {
#             arrangeBy = none;
#             backgroundColorBlue = 1;
#             backgroundColorGreen = 1;
#             backgroundColorRed = 1;
#             backgroundType = 0;
#             gridOffsetX = 0;
#             gridOffsetY = 0;
#             gridSpacing = 54;
#             iconSize = 64;
#             labelOnBottom = 1;
#             showIconPreview = 1;
#             showItemInfo = 0;
#             textSize = 12;
#             viewOptionsVersion = 1;
#         };
#         ListViewSettings =         {
#             calculateAllSizes = 0;
#             columns =             {
#                 comments =                 {
#                     ascending = 1;
#                     index = 7;
#                     visible = 0;
#                     width = 300;
#                 };
#                 dateCreated =                 {
#                     ascending = 0;
#                     index = 2;
#                     visible = 0;
#                     width = 181;
#                 };
#                 dateLastOpened =                 {
#                     ascending = 0;
#                     index = 8;
#                     visible = 0;
#                     width = 200;
#                 };
#                 dateModified =                 {
#                     ascending = 0;
#                     index = 1;
#                     visible = 1;
#                     width = 181;
#                 };
#                 kind =                 {
#                     ascending = 1;
#                     index = 4;
#                     visible = 1;
#                     width = 115;
#                 };
#                 label =                 {
#                     ascending = 1;
#                     index = 5;
#                     visible = 0;
#                     width = 100;
#                 };
#                 name =                 {
#                     ascending = 1;
#                     index = 0;
#                     visible = 1;
#                     width = 300;
#                 };
#                 size =                 {
#                     ascending = 0;
#                     index = 3;
#                     visible = 1;
#                     width = 97;
#                 };
#                 version =                 {
#                     ascending = 1;
#                     index = 6;
#                     visible = 0;
#                     width = 75;
#                 };
#             };
#             iconSize = 16;
#             showIconPreview = 1;
#             sortColumn = name;
#             textSize = 13;
#             useRelativeDates = 1;
#             viewOptionsVersion = 1;
#         };
#         SettingsType = "FK_StandardViewSettings";
#     };
#     "FK_iCloudListViewSettingsV2" =     {
#         calculateAllSizes = 0;
#         columns =         (
#                         {
#                 ascending = 1;
#                 identifier = name;
#                 visible = 1;
#                 width = 523;
#             },
#                         {
#                 ascending = 0;
#                 identifier = ubiquity;
#                 visible = 0;
#                 width = 35;
#             },
#                         {
#                 ascending = 0;
#                 identifier = dateModified;
#                 visible = 1;
#                 width = 181;
#             },
#                         {
#                 ascending = 0;
#                 identifier = dateCreated;
#                 visible = 0;
#                 width = 181;
#             },
#                         {
#                 ascending = 0;
#                 identifier = size;
#                 visible = 1;
#                 width = 97;
#             },
#                         {
#                 ascending = 1;
#                 identifier = kind;
#                 visible = 0;
#                 width = 115;
#             },
#                         {
#                 ascending = 1;
#                 identifier = label;
#                 visible = 0;
#                 width = 100;
#             },
#                         {
#                 ascending = 1;
#                 identifier = version;
#                 visible = 0;
#                 width = 75;
#             },
#                         {
#                 ascending = 1;
#                 identifier = comments;
#                 visible = 0;
#                 width = 300;
#             },
#                         {
#                 ascending = 0;
#                 identifier = dateLastOpened;
#                 visible = 0;
#                 width = 193;
#             },
#                         {
#                 ascending = 0;
#                 identifier = shareOwner;
#                 visible = 0;
#                 width = 200;
#             },
#                         {
#                 ascending = 0;
#                 identifier = shareLastEditor;
#                 visible = 0;
#                 width = 200;
#             },
#                         {
#                 ascending = 0;
#                 identifier = dateAdded;
#                 visible = 0;
#                 width = 181;
#             },
#                         {
#                 ascending = 0;
#                 identifier = invitationStatus;
#                 visible = 0;
#                 width = 210;
#             }
#         );
#         iconSize = 16;
#         showIconPreview = 1;
#         sortColumn = dateModified;
#         textSize = 13;
#         useRelativeDates = 1;
#         viewOptionsVersion = 1;
#     };
#     FXArrangeGroupViewBy = Name;
#     FXDefaultSearchScope = SCcf;
#     FXDesktopTouchBarUpgradedToTenTwelveOne = 1;
#     FXDesktopVolumePositions =     {
#         "Arc_0x1.36c0904p+29" =         {
#             AnchorRelativeTo = 1;
#             ScreenID = 0;
#             xRelative = "-65";
#             yRelative = 78;
#         };
#         "Backup_-0x1.d63c8c5p+35" =         {
#             AnchorRelativeTo = 1;
#             ScreenID = 0;
#             xRelative = "-65";
#             yRelative = 65;
#         };
#         "Backup_0x1.d64f24ap+28" =         {
#             AnchorRelativeTo = 1;
#             ScreenID = 0;
#             xRelative = "-65";
#             yRelative = 65;
#         };
#         "ChatGPT Installer_0x1.6886f648p+29" =         {
#             AnchorRelativeTo = 1;
#             ScreenID = 0;
#             xRelative = "-65";
#             yRelative = 289;
#         };
#         "Claude_0x1.68a4edb8p+29" =         {
#             AnchorRelativeTo = 1;
#             ScreenID = 0;
#             xRelative = "-65";
#             yRelative = 401;
#         };
#         "Google Chrome_0x1.68926448p+29" =         {
#             AnchorRelativeTo = 1;
#             ScreenID = 0;
#             xRelative = "-65";
#             yRelative = 190;
#         };
#         "LM Studio_0x1.664c3d9p+29" =         {
#             AnchorRelativeTo = 2;
#             ScreenID = 0;
#             xRelative = "-65";
#             yRelative = "-455";
#         };
#         "ProtonPass_1.27.0_0x1.68adfd68p+29" =         {
#             AnchorRelativeTo = 1;
#             ScreenID = 0;
#             xRelative = "-65";
#             yRelative = 513;
#         };
#     };
#     FXDetachedDesktopProviderID = "com.apple.CloudDocs.iCloudDriveFileProvider/96C77D41-3352-4BE6-924A-77A0F5D6EECB";
#     FXDetachedDocumentsProviderID = "com.apple.CloudDocs.iCloudDriveFileProvider/96C77D41-3352-4BE6-924A-77A0F5D6EECB";
#     FXEnableExtensionChangeWarning = 0;
#     FXICloudDriveDesktop = 1;
#     FXICloudDriveDocuments = 1;
#     FXICloudDriveEnabled = 1;
#     FXICloudLoggedIn = 1;
#     FXInfoPanesExpanded =     {
#         MetaData = 0;
#         Name = 0;
#         OpenWith = 1;
#     };
#     FXInfoWindowWidth = 265;
#     FXLastSearchScope = SCev;
#     FXPreferredGroupBy = None;
#     FXPreferredSearchViewStyle = Nlsv;
#     FXPreferredSearchViewStyleVersion = "%00%00%00%01";
#     FXPreferredViewStyle = icnv;
#     FXQuickActionsConfigUpgradeLevel = 3;
#     FXRecentFolders =     (
#                 {
#             "file-bookmark" = {length = 692, bytes = 0x626f6f6b b4020000 00000410 30000000 ... a0000000 00000000 };
#             name = bruno;
#         },
#                 {
#             "file-bookmark" = {length = 664, bytes = 0x626f6f6b 98020000 00000410 30000000 ... 04000000 00000000 };
#             name = Desktop;
#         },
#                 {
#             "file-bookmark" = {length = 784, bytes = 0x626f6f6b 10030000 00000410 30000000 ... 04000000 00000000 };
#             name = doc;
#         },
#                 {
#             "file-bookmark" = {length = 808, bytes = 0x626f6f6b 28030000 00000410 30000000 ... 04000000 00000000 };
#             name = doc;
#         },
#                 {
#             "file-bookmark" = {length = 748, bytes = 0x626f6f6b ec020000 00000410 30000000 ... 04000000 00000000 };
#             name = FuncThor;
#         },
#                 {
#             "file-bookmark" = {length = 508, bytes = 0x626f6f6b fc010000 00000410 30000000 ... 04000000 00000000 };
#             name = Applications;
#         },
#                 {
#             "file-bookmark" = {length = 1520, bytes = 0x626f6f6b f0050000 00000410 30000000 ... d4040000 00000000 };
#             name = "Flow-v1.3.396";
#         },
#                 {
#             "file-bookmark" = {length = 832, bytes = 0x626f6f6b 40030000 00000410 30000000 ... 04000000 00000000 };
#             name = teams;
#         }
#     );
#     FXSidebarUpgradedSharedSearchToTwelve = 1;
#     FXSidebarUpgradedToSixteen = 1;
#     FXSidebarUpgradedToTenFourteen = 1;
#     FXSidebarUpgradedToTenTen = 1;
#     FXSyncExtensionToolbarItemsAutomaticallyAdded =     (
#         "net.langui.ContextMenu.ContextMenuExtension",
#         "com.shrek.rightmouse.extension",
#         "com.getdropbox.dropbox.garcon"
#     );
#     FXSyncExtensionToolbarItemsPendingAdd =     (
#     );
#     FXSyncExtensionToolbarItemsPendingRemove =     (
#     );
#     FXToolbarUpgradedToTenEight = 1;
#     FXToolbarUpgradedToTenNine = 2;
#     FXToolbarUpgradedToTenSeven = 1;
#     FavoriteTagNames =     (
#         "",
#         Red,
#         Orange,
#         Yellow,
#         Green,
#         Blue,
#         Purple,
#         Gray
#     );
#     FontSizeCategory = Custom;
#     GoToField = "/Users/bruno/.con";
#     GoToFieldHistory =     (
#         "/Users/bruno/.config",
#         "/Users/bruno/.claude",
#         "/Users/bruno/.cache",
#         "/Users/bruno/.code-reasoning/prompt_values.json",
#         "/Users/bruno/Documents/API_KEYS.ts"
#     );
#     ICloudViewSettings =     {
#         WindowState =         {
#             ContainerShowSidebar = 1;
#             ShowSidebar = 1;
#             ShowStatusBar = 0;
#             ShowTabView = 0;
#             ShowToolbar = 1;
#             WindowBounds = "{{325, 368}, {920, 436}}";
#         };
#     };
#     LastTrashState = 1;
#     MeetingRoomViewSetting =     {
#         CustomViewStyleVersion = 1;
#         WindowState =         {
#             ContainerShowSidebar = 1;
#             ShowSidebar = 1;
#             ShowStatusBar = 1;
#             ShowTabView = 0;
#             ShowToolbar = 1;
#             WindowBounds = "{{404, 90}, {920, 492}}";
#         };
#     };
#     NSNavPanelExpandedSizeForOpenMode = "{930, 448}";
#     NSOSPLastRootDirectory = {length = 748, bytes = 0x626f6f6b ec020000 00000410 30000000 ... 8c010000 00000000 };
#     "NSToolbar Configuration Browser" =     {
#         "TB Default Item Identifiers" =         (
#             "com.apple.finder.BACK",
#             "com.apple.finder.SWCH",
#             NSToolbarSpaceItem,
#             "com.apple.finder.ARNG",
#             NSToolbarSpaceItem,
#             "com.apple.finder.SHAR",
#             "com.apple.finder.LABL",
#             "com.apple.finder.ACTN",
#             NSToolbarSpaceItem,
#             "com.apple.finder.SRCH"
#         );
#         "TB Display Mode" = 2;
#         "TB Icon Size Mode" = 1;
#         "TB Is Shown" = 1;
#         "TB Item Identifiers" =         (
#             "com.apple.finder.BACK",
#             "com.apple.finder.SWCH",
#             NSToolbarSpaceItem,
#             "com.apple.finder.ARNG",
#             "com.apple.finder.SHAR",
#             "com.apple.finder.LABL",
#             "com.apple.finder.ACTN",
#             NSToolbarSpaceItem,
#             NSToolbarSpaceItem,
#             "net.langui.ContextMenu.ContextMenuExtension",
#             "com.shrek.rightmouse.extension",
#             "com.getdropbox.dropbox.garcon",
#             "com.apple.finder.SRCH"
#         );
#         "TB Size Mode" = 1;
#     };
#     "NSWindow Frame GoToSheet" = "230 323 460 183 0 0 1920 1049 ";
#     "NSWindow Frame NSNavPanelAutosaveName" = "881 1530 930 448 387 1080 1920 1049 ";
#     NewWindowTarget = PfDe;
#     NewWindowTargetPath = "file:///Users/bruno/Desktop/";
#     OpenWindowForNewRemovableDisk = 1;
#     PreviewPaneGalleryWidth = 250;
#     PreviewPaneWidth = 250;
#     QLEnableTextSelection = 1;
#     QuitMenuItem = 1;
#     RecentMoveAndCopyDestinations =     (
#         "file:///Users/bruno/.config/img/",
#         "file:///Applications/",
#         "file:///Users/bruno/Developer/Inbox/FuncThor/.claude/commands/",
#         "file:///Users/bruno/Developer/Inbox/PropertyTesting/.cursor/",
#         "file:///Users/bruno/Developer/Inbox/FuncThor/.claude/scripts/",
#         "file:///Users/bruno/Developer/Inbox/FuncThor/.claude/",
#         "file:///Users/bruno/Developer/Inbox/FuncThor/doc/",
#         "file:///Users/bruno/Developer/Inbox/PropertyTesting/",
#         "file:///Users/bruno/.Trash/.cursor%2002.43.23/rules/",
#         "file:///Users/bruno/Developer/Archon/"
#     );
#     RecentsArrangeGroupViewBy = "Date Last Opened";
#     SearchRecentsSavedViewStyleVersion = "%00%00%00%01";
#     SearchRecentsViewSettings =     {
#         WindowState =         {
#             ContainerShowSidebar = 1;
#             ShowSidebar = 1;
#             ShowStatusBar = 1;
#             ShowTabView = 0;
#             ShowToolbar = 1;
#             WindowBounds = "{{595, 171}, {920, 492}}";
#         };
#     };
#     SearchViewSettings =     {
#         ExtendedListViewSettingsV2 =         {
#             axTextSize = 13;
#             calculateAllSizes = 0;
#             columns =             (
#                                 {
#                     ascending = 1;
#                     identifier = name;
#                     visible = 1;
#                     width = 252;
#                 },
#                                 {
#                     ascending = 0;
#                     identifier = ubiquity;
#                     visible = 0;
#                     width = 35;
#                 },
#                                 {
#                     ascending = 0;
#                     identifier = dateModified;
#                     visible = 0;
#                     width = 181;
#                 },
#                                 {
#                     ascending = 0;
#                     identifier = dateCreated;
#                     visible = 0;
#                     width = 181;
#                 },
#                                 {
#                     ascending = 0;
#                     identifier = size;
#                     visible = 0;
#                     width = 97;
#                 },
#                                 {
#                     ascending = 1;
#                     identifier = kind;
#                     visible = 1;
#                     width = 115;
#                 },
#                                 {
#                     ascending = 1;
#                     identifier = label;
#                     visible = 0;
#                     width = 100;
#                 },
#                                 {
#                     ascending = 1;
#                     identifier = version;
#                     visible = 0;
#                     width = 75;
#                 },
#                                 {
#                     ascending = 1;
#                     identifier = comments;
#                     visible = 0;
#                     width = 300;
#                 },
#                                 {
#                     ascending = 0;
#                     identifier = dateLastOpened;
#                     visible = 1;
#                     width = 193;
#                 },
#                                 {
#                     ascending = 0;
#                     identifier = shareOwner;
#                     visible = 0;
#                     width = 200;
#                 },
#                                 {
#                     ascending = 0;
#                     identifier = shareLastEditor;
#                     visible = 0;
#                     width = 200;
#                 },
#                                 {
#                     ascending = 0;
#                     identifier = dateAdded;
#                     visible = 0;
#                     width = 181;
#                 },
#                                 {
#                     ascending = 0;
#                     identifier = invitationStatus;
#                     visible = 0;
#                     width = 210;
#                 }
#             );
#             iconSize = 16;
#             showIconPreview = 1;
#             sortColumn = dateLastOpened;
#             textSize = 13;
#             useRelativeDates = 1;
#             viewOptionsVersion = 1;
#         };
#         IconViewSettings =         {
#             arrangeBy = name;
#             backgroundColorBlue = 1;
#             backgroundColorGreen = 1;
#             backgroundColorRed = 1;
#             backgroundType = 0;
#             gridOffsetX = 0;
#             gridOffsetY = 0;
#             gridSpacing = 54;
#             iconSize = 96;
#             labelOnBottom = 1;
#             showIconPreview = 1;
#             showItemInfo = 0;
#             textSize = 12;
#             viewOptionsVersion = 1;
#         };
#         ListViewSettings =         {
#             axTextSize = 13;
#             calculateAllSizes = 0;
#             columns =             {
#                 comments =                 {
#                     ascending = 1;
#                     index = 7;
#                     visible = 0;
#                     width = 300;
#                 };
#                 dateCreated =                 {
#                     ascending = 0;
#                     index = 2;
#                     visible = 0;
#                     width = 181;
#                 };
#                 dateLastOpened =                 {
#                     ascending = 0;
#                     index = 8;
#                     visible = 1;
#                     width = 193;
#                 };
#                 dateModified =                 {
#                     ascending = 0;
#                     index = 1;
#                     visible = 0;
#                     width = 181;
#                 };
#                 kind =                 {
#                     ascending = 1;
#                     index = 4;
#                     visible = 1;
#                     width = 115;
#                 };
#                 label =                 {
#                     ascending = 1;
#                     index = 5;
#                     visible = 0;
#                     width = 100;
#                 };
#                 name =                 {
#                     ascending = 1;
#                     index = 0;
#                     visible = 1;
#                     width = 252;
#                 };
#                 size =                 {
#                     ascending = 0;
#                     index = 3;
#                     visible = 0;
#                     width = 97;
#                 };
#                 version =                 {
#                     ascending = 1;
#                     index = 6;
#                     visible = 0;
#                     width = 75;
#                 };
#             };
#             iconSize = 16;
#             showIconPreview = 1;
#             sortColumn = dateLastOpened;
#             textSize = 13;
#             useRelativeDates = 1;
#             viewOptionsVersion = 1;
#         };
#         WindowState =         {
#             ContainerShowSidebar = 1;
#             ShowSidebar = 1;
#             ShowStatusBar = 1;
#             ShowTabView = 0;
#             ShowToolbar = 1;
#             WindowBounds = "{{646, 303}, {920, 492}}";
#         };
#     };
#     ShowExternalHardDrivesOnDesktop = 0;
#     ShowHardDrivesOnDesktop = 0;
#     ShowMountedServersOnDesktop = 0;
#     ShowPathbar = 1;
#     ShowRemovableMediaOnDesktop = 0;
#     ShowSidebar = 1;
#     ShowStatusBar = 1;
#     SidebarDevicesSectionDisclosedState = 1;
#     SidebarPlacesSectionDisclosedState = 1;
#     SidebarShowingSignedIntoiCloud = 1;
#     SidebarShowingiCloudDesktop = 1;
#     SidebarWidth = 223;
#     SidebarWidth2 = 183;
#     SidebariCloudDriveSectionDisclosedState = 1;
#     SmartSharedSearchViewSettings =     {
#         WindowState =         {
#             ContainerShowSidebar = 1;
#             ShowSidebar = 1;
#             ShowStatusBar = 1;
#             ShowTabView = 0;
#             ShowToolbar = 1;
#             WindowBounds = "{{300, 334}, {920, 492}}";
#         };
#     };
#     StandardViewOptions =     {
#         ColumnViewOptions =         {
#             ArrangeBy = dnam;
#             ColumnShowFolderArrow = 1;
#             ColumnShowIcons = 1;
#             ColumnWidth = 245;
#             FontSize = 13;
#             PreviewDisclosureState = 1;
#             SharedArrangeBy = kipl;
#             ShowIconThumbnails = 1;
#             ShowPreview = 1;
#         };
#     };
#     StandardViewSettings =     {
#         ExtendedListViewSettingsV2 =         {
#             calculateAllSizes = 0;
#             columns =             (
#                                 {
#                     ascending = 1;
#                     identifier = name;
#                     visible = 1;
#                     width = 300;
#                 },
#                                 {
#                     ascending = 0;
#                     identifier = dateModified;
#                     visible = 1;
#                     width = 181;
#                 },
#                                 {
#                     ascending = 0;
#                     identifier = dateCreated;
#                     visible = 0;
#                     width = 181;
#                 },
#                                 {
#                     ascending = 0;
#                     identifier = size;
#                     visible = 1;
#                     width = 97;
#                 },
#                                 {
#                     ascending = 1;
#                     identifier = kind;
#                     visible = 1;
#                     width = 115;
#                 },
#                                 {
#                     ascending = 1;
#                     identifier = label;
#                     visible = 0;
#                     width = 100;
#                 },
#                                 {
#                     ascending = 1;
#                     identifier = version;
#                     visible = 0;
#                     width = 75;
#                 },
#                                 {
#                     ascending = 1;
#                     identifier = comments;
#                     visible = 0;
#                     width = 300;
#                 },
#                                 {
#                     ascending = 0;
#                     identifier = dateLastOpened;
#                     visible = 0;
#                     width = 200;
#                 },
#                                 {
#                     ascending = 0;
#                     identifier = shareOwner;
#                     visible = 0;
#                     width = 200;
#                 },
#                                 {
#                     ascending = 0;
#                     identifier = shareLastEditor;
#                     visible = 0;
#                     width = 200;
#                 }
#             );
#             iconSize = 16;
#             showIconPreview = 1;
#             sortColumn = name;
#             textSize = 13;
#             useRelativeDates = 1;
#             viewOptionsVersion = 1;
#         };
#         GalleryViewSettings =         {
#             arrangeBy = name;
#             iconSize = 48;
#             showIconPreview = 1;
#             viewOptionsVersion = 1;
#         };
#         IconViewSettings =         {
#             arrangeBy = none;
#             backgroundColorBlue = 1;
#             backgroundColorGreen = 1;
#             backgroundColorRed = 1;
#             backgroundType = 0;
#             gridOffsetX = 0;
#             gridOffsetY = 0;
#             gridSpacing = 54;
#             iconSize = 64;
#             labelOnBottom = 1;
#             showIconPreview = 1;
#             showItemInfo = 0;
#             textSize = 12;
#             viewOptionsVersion = 1;
#         };
#         ListViewSettings =         {
#             calculateAllSizes = 0;
#             columns =             {
#                 comments =                 {
#                     ascending = 1;
#                     index = 7;
#                     visible = 0;
#                     width = 300;
#                 };
#                 dateCreated =                 {
#                     ascending = 0;
#                     index = 2;
#                     visible = 0;
#                     width = 181;
#                 };
#                 dateLastOpened =                 {
#                     ascending = 0;
#                     index = 8;
#                     visible = 0;
#                     width = 200;
#                 };
#                 dateModified =                 {
#                     ascending = 0;
#                     index = 1;
#                     visible = 1;
#                     width = 181;
#                 };
#                 kind =                 {
#                     ascending = 1;
#                     index = 4;
#                     visible = 1;
#                     width = 115;
#                 };
#                 label =                 {
#                     ascending = 1;
#                     index = 5;
#                     visible = 0;
#                     width = 100;
#                 };
#                 name =                 {
#                     ascending = 1;
#                     index = 0;
#                     visible = 1;
#                     width = 300;
#                 };
#                 size =                 {
#                     ascending = 0;
#                     index = 3;
#                     visible = 1;
#                     width = 97;
#                 };
#                 version =                 {
#                     ascending = 1;
#                     index = 6;
#                     visible = 0;
#                     width = 75;
#                 };
#             };
#             iconSize = 16;
#             showIconPreview = 1;
#             sortColumn = name;
#             textSize = 13;
#             useRelativeDates = 1;
#             viewOptionsVersion = 1;
#         };
#         SettingsType = StandardViewSettings;
#     };
#     TagsCloudSerialNumber = 1;
#     TrashViewSettings =     {
#         CustomViewStyleVersion = 1;
#         ExtendedListViewSettingsV2 =         {
#             axTextSize = 13;
#             calculateAllSizes = 0;
#             columns =             (
#                                 {
#                     ascending = 1;
#                     identifier = name;
#                     visible = 1;
#                     width = 300;
#                 },
#                                 {
#                     ascending = 0;
#                     identifier = ubiquity;
#                     visible = 0;
#                     width = 35;
#                 },
#                                 {
#                     ascending = 0;
#                     identifier = dateModified;
#                     visible = 1;
#                     width = 181;
#                 },
#                                 {
#                     ascending = 0;
#                     identifier = dateCreated;
#                     visible = 0;
#                     width = 181;
#                 },
#                                 {
#                     ascending = 0;
#                     identifier = size;
#                     visible = 1;
#                     width = 97;
#                 },
#                                 {
#                     ascending = 1;
#                     identifier = kind;
#                     visible = 1;
#                     width = 115;
#                 },
#                                 {
#                     ascending = 1;
#                     identifier = label;
#                     visible = 0;
#                     width = 100;
#                 },
#                                 {
#                     ascending = 1;
#                     identifier = version;
#                     visible = 0;
#                     width = 75;
#                 },
#                                 {
#                     ascending = 1;
#                     identifier = comments;
#                     visible = 0;
#                     width = 300;
#                 },
#                                 {
#                     ascending = 0;
#                     identifier = dateLastOpened;
#                     visible = 0;
#                     width = 200;
#                 },
#                                 {
#                     ascending = 0;
#                     identifier = shareOwner;
#                     visible = 0;
#                     width = 200;
#                 },
#                                 {
#                     ascending = 0;
#                     identifier = shareLastEditor;
#                     visible = 0;
#                     width = 200;
#                 },
#                                 {
#                     ascending = 0;
#                     identifier = dateAdded;
#                     visible = 0;
#                     width = 181;
#                 },
#                                 {
#                     ascending = 0;
#                     identifier = invitationStatus;
#                     visible = 0;
#                     width = 210;
#                 }
#             );
#             iconSize = 16;
#             scrollPositionX = "-191";
#             scrollPositionY = 0;
#             showIconPreview = 1;
#             sortColumn = dateModified;
#             textSize = 13;
#             useRelativeDates = 1;
#             viewOptionsVersion = 1;
#         };
#         ListViewSettings =         {
#             axTextSize = 13;
#             calculateAllSizes = 0;
#             columns =             {
#                 comments =                 {
#                     ascending = 1;
#                     index = 7;
#                     visible = 0;
#                     width = 300;
#                 };
#                 dateCreated =                 {
#                     ascending = 0;
#                     index = 2;
#                     visible = 0;
#                     width = 181;
#                 };
#                 dateLastOpened =                 {
#                     ascending = 0;
#                     index = 8;
#                     visible = 0;
#                     width = 200;
#                 };
#                 dateModified =                 {
#                     ascending = 0;
#                     index = 1;
#                     visible = 1;
#                     width = 181;
#                 };
#                 kind =                 {
#                     ascending = 1;
#                     index = 4;
#                     visible = 1;
#                     width = 115;
#                 };
#                 label =                 {
#                     ascending = 1;
#                     index = 5;
#                     visible = 0;
#                     width = 100;
#                 };
#                 name =                 {
#                     ascending = 1;
#                     index = 0;
#                     visible = 1;
#                     width = 300;
#                 };
#                 size =                 {
#                     ascending = 0;
#                     index = 3;
#                     visible = 1;
#                     width = 97;
#                 };
#                 version =                 {
#                     ascending = 1;
#                     index = 6;
#                     visible = 0;
#                     width = 75;
#                 };
#             };
#             iconSize = 16;
#             scrollPositionX = "-191";
#             scrollPositionY = 0;
#             showIconPreview = 1;
#             sortColumn = dateModified;
#             textSize = 13;
#             useRelativeDates = 1;
#             viewOptionsVersion = 1;
#         };
#         WindowState =         {
#             ContainerShowSidebar = 1;
#             ShowSidebar = 1;
#             ShowStatusBar = 1;
#             ShowTabView = 0;
#             ShowToolbar = 1;
#             WindowBounds = "{{0, 82}, {1512, 866}}";
#         };
#     };
#     WarnOnEmptyTrash = 0;
#     "_FXShowPosixPathInTitle" = 1;
#     "_FXSortFoldersFirst" = 1;
# }

# com.apple.desktopservices preferences
echo 'Setting com.apple.desktopservices preferences...'
# {
#     DSDontWriteNetworkStores = 1;
#     DSDontWriteUSBStores = 1;
# }

