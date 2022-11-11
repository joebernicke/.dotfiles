--- {{{ Imports 
-- Base
import XMonad
import System.Directory
import System.IO (hClose, hPutStr, hPutStrLn)
import System.Exit (exitSuccess)
import qualified XMonad.StackSet as W

-- Actions
import XMonad.Actions.CopyWindow (kill1)
import XMonad.Actions.CycleWS (Direction1D(..), moveTo, shiftTo, WSType(..), nextScreen, prevScreen,prevWS,nextWS)
import XMonad.Actions.CycleWS
import XMonad.Actions.GridSelect
import XMonad.Actions.MouseResize
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves (rotSlavesDown, rotAllDown)
import XMonad.Actions.WindowGo (runOrRaise)
import XMonad.Actions.WithAll (sinkAll, killAll)
import qualified XMonad.Actions.Search as S

-- Layouts
import XMonad.Layout.Accordion
import XMonad.Layout.GridVariants (Grid(Grid))
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spiral
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns

-- Layouts modifiers
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (limitWindows, increaseLimit, decreaseLimit)
import XMonad.Layout.MultiToggle (mkToggle, single, EOT(EOT), (??))
import XMonad.Layout.MultiToggle.Instances (StdTransformers(NBFULL, MIRROR, NOBORDERS))
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.ShowWName
import XMonad.Layout.Simplest
import XMonad.Layout.Spacing
import XMonad.Layout.SubLayouts
import XMonad.Layout.WindowArranger (windowArrange, WindowArrangerMsg(..))
import XMonad.Layout.WindowNavigation
import qualified XMonad.Layout.ToggleLayouts as T (toggleLayouts, ToggleLayout(Toggle))
import qualified XMonad.Layout.MultiToggle as MT (Toggle(..))
   
-- Data
import Data.Char (isSpace, toUpper)
import Data.Maybe (fromJust)
import Data.Monoid
import Data.Maybe (isJust)
import Data.Tree
import qualified Data.Map as M

-- Utilities
import XMonad.Util.Dmenu
import XMonad.Util.EZConfig (additionalKeysP, mkNamedKeymap)
import XMonad.Util.NamedActions
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run (runProcessWithInput, safeSpawn, spawnPipe)
import XMonad.Util.SpawnOnce

-- Hooks
import XMonad.Hooks.DynamicLog (dynamicLogWithPP, wrap, xmobarPP, xmobarColor, shorten, PP(..))
import XMonad.Hooks.EwmhDesktops  -- for some fullscreen events, also for xcomposite in obs.
import XMonad.Hooks.ManageDocks (avoidStruts, docks, manageDocks, ToggleStruts(..))
import XMonad.Hooks.ManageHelpers (isFullscreen, doFullFloat, doCenterFloat)
import XMonad.Hooks.ServerMode
import XMonad.Hooks.SetWMName
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.WindowSwallowing
import XMonad.Hooks.WorkspaceHistory

-- ColorScheme module (SET ONLY ONE!)
    -- Possible choice are:
    -- DoomOne
    -- Dracula
    -- GruvboxDark
    -- MonokaiPro
    -- Nord
    -- OceanicNext
    -- Palenight
    -- SolarizedDark
    -- SolarizedLight
    -- TomorrowNight
import Colors.DoomOne
-- import Colors.Nord

--- }}}
--- {{{ Variables
myFont :: String
myFont = "xft:SauceCodePro Nerd Font Mono:regular:size=9:antialias=true:hinting=true"

myModMask :: KeyMask
myModMask = mod4Mask        -- Sets modkey to super/windows key

myTerminal :: String
myTerminal = "alacritty"    -- Sets default terminal

myBrowser :: String
myBrowser = "firefox "  -- Sets qutebrowser as browser


myEditor :: String
myEditor = myTerminal ++ " -e vim "    -- Sets vim as editor

myBorderWidth :: Dimension
myBorderWidth = 2           -- Sets border width for windows

myNormColor :: String       -- Border color of normal windows
myNormColor   = colorBack   -- This variable is imported from Colors.THEME

myFocusColor :: String      -- Border color of focused windows
myFocusColor  = color15     -- This variable is imported from Colors.THEME


windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset
--- }}}
--- {{{Startup Hook
myStartupHook :: X()
myStartupHook = do
    spawn "killall conky"
    spawn "killall trayer"
    spawnOnce "lxsession"
    spawnOnce "picom"
    spawnOnce "nm-applet"
    spawnOnce "volumeicon"
    spawnOnce "blueberry-tray"

    spawn ("sleep 2 && conky -c $HOME/.config/conky/xmonad/" ++ colorScheme ++ "-01.conkyrc")
    spawn ("sleep 3 && exec trayer --edge top --align right --widthtype request --padding 6 --SetDockType true --SetPartialStrut true --expand true --monitor 1 --transparent true --alpha 0 " ++ colorTrayer ++ " --height 22")
    spawnOnce "nitrogen --restore &" 
    setWMName "LG3D"
--- }}}
--- {{{ Scratchpads
myScratchPads :: [NamedScratchpad]
myScratchPads = [ NS "terminal" spawnTerm findTerm manageTerm
                , NS "mocp" spawnMocp findMocp manageMocp
                , NS "calculator" spawnCalc findCalc manageCalc
                ]
    where
        spawnTerm  = myTerminal ++ " -t scratchpad"
        findTerm   = title =? "scratchpad"
        manageTerm = customFloating $ W.RationalRect l t w h
            where
                h = 0.9
                w = 0.9
                t = 0.95 -h
                l = 0.95 -w
        spawnMocp  = myTerminal ++ " -t mocp -e mocp"
        findMocp   = title =? "mocp"
        manageMocp = customFloating $ W.RationalRect l t w h
            where
                h = 0.9
                w = 0.9
                t = 0.95 -h
                l = 0.95 -w
        spawnCalc  = "qalculate-gtk"
        findCalc   = className =? "Qalculate-gtk"
        manageCalc = customFloating $ W.RationalRect l t w h
            where
                h = 0.5
                w = 0.4
                t = 0.75 -h
                l = 0.70 -w
--- }}}
--- {{{Layout 
--Makes setting the spacingRaw simpler to write. The spacingRaw module adds a configurable amount of space around windows.
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True
mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

tall     = renamed [Replace "tall"]
         $ limitWindows 5
         $ smartBorders
         $ windowNavigation
         $ addTabs shrinkText myTabTheme
         -- $ subLayout [] (smartBorders Simplest)
         $ mySpacing 2
         $ ResizableTall 1 (3/100) (1/2) []
monocle  = renamed [Replace "monocle"]
         $ smartBorders
         $ windowNavigation
         $ addTabs shrinkText myTabTheme
         $ subLayout [] (smartBorders Simplest)
         $ Full
floats   = renamed [Replace "floats"]
         $ smartBorders
         $ simplestFloat
tabs     = renamed [Replace "tabs"]
         -- I cannot add spacing to this layout because it will
         -- add spacing between window and tabs which looks bad.
         $ tabbed shrinkText myTabTheme
myTabTheme = def { fontName            = myFont
                 , activeColor         = color15
                 , inactiveColor       = color08
                 , activeBorderColor   = color15
                 , inactiveBorderColor = colorBack
                 , activeTextColor     = colorBack
                 , inactiveTextColor   = color16
                 }

-- Theme for showWName which prints current workspace when you change workspaces.
myShowWNameTheme :: SWNConfig
myShowWNameTheme = def
    { swn_font              = "xft:Ubuntu:bold:size=60"
    , swn_fade              = 1.0
    , swn_bgcolor           = "#1c1f24"
    , swn_color             = "#ffffff"
    }
                                                                                                                                 


-- The layout hook
myLayoutHook = avoidStruts
               $ mouseResize
               $ windowArrange
               $ T.toggleLayouts floats
               $ mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
    where
        myDefaultLayout = withBorder myBorderWidth tall
            ||| noBorders monocle
            ||| floats
            ||| noBorders tabs

-- myWorkspaces = [" 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 "]
myWorkspaces = [" dev ", " www ", " sys ", " doc ", " vbox ", " chat ", " mus ", " vid ", " gfx "]
-- myWorkspaces =
--         " 1 : <fn=2>\xf111</fn> " :
--         " 2 : <fn=2>\xf1db</fn> " :
--         " 3 : <fn=2>\xf192</fn> " :
--         " 4 : <fn=2>\xf025</fn> " :
--         " 5 : <fn=2>\xf03d</fn> " :
--         " 6 : <fn=2>\xf1e3</fn> " :
--         " 7 : <fn=2>\xf07b</fn> " :
--         " 8 : <fn=2>\xf21b</fn> " :
--         " 9 : <fn=2>\xf21e</fn> " :
--         []

myWorkspaceIndices = M.fromList $ zipWith (,) myWorkspaces [1..] -- (,) == \x y -> (x,y)

clickable ws = "<action=xdotool key super+"++show i++">"++ws++"</action>"
    where i = fromJust $ M.lookup ws myWorkspaceIndices

myManageHook :: XMonad.Query (Data.Monoid.Endo WindowSet)
myManageHook = composeAll
  -- 'doFloat' forces a window to float.  Useful for dialog boxes and such.
  -- using 'doShift ( myWorkspaces !! 7)' sends program to workspace 8!
  -- I'm doing it this way because otherwise I would have to write out the full
  -- name of my workspaces and the names would be very long if using clickable workspaces.
  [ className =? "confirm"         --> doFloat
  , className =? "file_progress"   --> doFloat
  , className =? "dialog"          --> doFloat
  , className =? "download"        --> doFloat
  , className =? "error"           --> doFloat
  , className =? "Gimp"            --> doFloat
  , className =? "notification"    --> doFloat
  , className =? "pinentry-gtk-2"  --> doFloat
  , className =? "splash"          --> doFloat
  , className =? "toolbar"         --> doFloat
  , className =? "Yad"             --> doCenterFloat
  , title =? "Oracle VM VirtualBox Manager"  --> doFloat
  , title =? "Mozilla Firefox"     --> doShift ( myWorkspaces !! 1 )
  , className =? "Brave-browser"   --> doShift ( myWorkspaces !! 1 )
  , className =? "mpv"             --> doShift ( myWorkspaces !! 7 )
  , className =? "Gimp"            --> doShift ( myWorkspaces !! 8 )
  , className =? "VirtualBox Manager" --> doShift  ( myWorkspaces !! 4 )
  , (className =? "firefox" <&&> resource =? "Dialog") --> doFloat  -- Float Firefox Dialog
  , isFullscreen -->  doFullFloat
  ] <+> namedScratchpadManageHook myScratchPads

--- }}}
--- {{{ KeyBindings
subtitle' ::  String -> ((KeyMask, KeySym), NamedAction)
subtitle' x = ((0,0), NamedAction $ map toUpper
                          $ sep ++ "\n-- " ++ x ++ " --\n" ++ sep)
  where
      sep = replicate (6 + length x) '-'

showKeybindings :: [((KeyMask, KeySym), NamedAction)] -> NamedAction
showKeybindings x = addName "Show Keybindings" $ io $ do
        h <- spawnPipe $ "yad --text-info --fontname=\"SauceCodePro Nerd Font Mono 12\" --fore=#46d9ff back=#282c36 --center --geometry=1200x800 --title \"XMonad keybindings\""
        --hPutStr h (unlines $ showKm x) -- showKM adds ">>" before subtitles
        hPutStr h (unlines $ showKmSimple x) -- showKmSimple doesn't add ">>" to subtitles
        hClose h
        return ()

myKeys :: XConfig l0 -> [((KeyMask, KeySym), NamedAction)]
myKeys c =
  --(subtitle "Custom Keys":) $ mkNamedKeymap c $
    let subKeys str ks = subtitle' str : mkNamedKeymap c ks in
    subKeys "Xmonad Essentials"
        [ ("M-C-r", addName "Recompile XMonad"       $ spawn "xmonad --recompile")
        , ("M-S-r", addName "Restart XMonad"         $ spawn "xmonad --restart")
        , ("M-S-q", addName "Quit XMonad"            $ sequence_ [io exitSuccess])
        , ("M-q", addName "Kill focused window"    $ kill1)
        , ("M-S-a", addName "Kill all windows on WS" $ killAll)
        , ("M-S-<Return>", addName "Run prompt"      $ sequence_ [spawn "/usr/bin/dmenu_run"])]

        ^++^ subKeys "Switch to workspace"
        [ ("M-p", addName "previous workspace"       $ (prevWS))
        , ("M-l", addName "toggle to last workspace" $ (toggleWS))
        , ("M-n", addName "toggle to last workspace" $ (nextWS))
        , ("M-1", addName "Switch to workspace 1"    $ (windows $ W.greedyView $ myWorkspaces !! 0))
        , ("M-2", addName "Switch to workspace 2"    $ (windows $ W.greedyView $ myWorkspaces !! 1))]

        ^++^ subKeys "Send window to workspace"
        [ ("M-S-1", addName "Send to workspace 1"    $ (windows $ W.shift $ myWorkspaces !! 0))
        , ("M-S-2", addName "Send to workspace 2"    $ (windows $ W.shift $ myWorkspaces !! 1))
        , ("M-S-3", addName "Send to workspace 3"    $ (windows $ W.shift $ myWorkspaces !! 2))]

       ^++^ subKeys "Window navigation"
       [ ("M-m", addName "Move focus to master window"              $ windows W.focusMaster)
       , ("M-j", addName "Focus Down"                               $ windows W.focusDown)
       , ("M-k", addName "Focus Up"                                 $ windows W.focusUp)

       , ("M-S-m", addName "Swap focused window with master window" $ windows W.swapMaster)
       , ("M-S-j", addName "Swap focused window with next window"   $ windows W.swapDown)
       , ("M-S-k", addName "Swap focused window with prev window"   $ windows W.swapUp)
       , ("M-S-,", addName "Rotate all windows except master"       $ rotSlavesDown)
       , ("M-S-.", addName "Rotate all windows current stack"       $ rotAllDown)]

       -- Dmenu scripts (dmscripts)
       -- In Xmonad and many tiling window managers, M-p is the default keybinding to
       -- launch dmenu_run, so I've decided to use M-p plus KEY for these dmenu scripts.
       ^++^ subKeys "Dmenu scripts"
       [ ("M-d h", addName "List all dmscripts"     $ spawn "dm-hub")
       , ("M-d b", addName "Set background"         $ spawn "dm-setbg")
       , ("M-d c", addName "Choose color scheme"    $ spawn "~/.local/bin/dtos-colorscheme")
       , ("M-d C", addName "Pick color from scheme" $ spawn "dm-colpick")
       , ("M-d e", addName "Edit config files"      $ spawn "dm-confedit")
       , ("M-d i", addName "Take a screenshot"      $ spawn "dm-maim")
       , ("M-d k", addName "Kill processes"         $ spawn "dm-kill")
       , ("M-d m", addName "View manpages"          $ spawn "dm-man")
       , ("M-d n", addName "Store and copy notes"   $ spawn "dm-note")
       , ("M-d o", addName "Browser bookmarks"      $ spawn "dm-bookman")
       , ("M-d q", addName "Logout Menu"            $ spawn "dm-logout")
       , ("M-d s", addName "Search various engines" $ spawn "dm-websearch")]
       
       ^++^ subKeys "Favorite programs"
       [ ("M-<Return>", addName "Launch terminal"   $ spawn (myTerminal))
       , ("M-b", addName "Launch web browser"       $ spawn (myBrowser))]
       
       ^++^ subKeys "Monitors"
       [ ("M-.", addName "Switch focus to next monitor" $ nextScreen)
       , ("M-,", addName "Switch focus to prev monitor" $ prevScreen)]
       
       -- Switch layouts
       ^++^ subKeys "Switch layouts"
       [ ("M-<Tab>", addName "Switch to next layout"   $ sendMessage NextLayout)
       , ("M-<Space>", addName "Toggle noborders/full" $ sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts)]
       
       -- Window resizing
       ^++^ subKeys "Window resizing"
       [ ("M-z h", addName "Shrink window"               $ sendMessage Shrink)
       , ("M-z l", addName "Expand window"               $ sendMessage Expand)
       , ("M-M1-j", addName "Shrink window vertically" $ sendMessage MirrorShrink)
       , ("M-M1-k", addName "Expand window vertically" $ sendMessage MirrorExpand)]
       
       -- Floating windows
       ^++^ subKeys "Floating windows"
       [ ("M-f", addName "Toggle float layout"        $ sendMessage (T.Toggle "floats"))
       , ("M-t", addName "Sink a floating window"     $ withFocused $ windows . W.sink)
       , ("M-S-t", addName "Sink all floated windows" $ sinkAll)]
       
       -- Increase/decrease spacing (gaps))
       ^++^ subKeys "Window spacing (gaps)"
       [ ("C-M1-j", addName "Decrease window spacing" $ decWindowSpacing 4)
       , ("C-M1-k", addName "Increase window spacing" $ incWindowSpacing 4)
       , ("C-M1-h", addName "Decrease screen spacing" $ decScreenSpacing 4)
       , ("C-M1-l", addName "Increase screen spacing" $ incScreenSpacing 4)]
       
       -- Increase/decrease windows in the master pane or the stack
       ^++^ subKeys "Increase/decrease windows in master pane or the stack"
       [ ("M-S-<Up>", addName "Increase clients in master pane"   $ sendMessage (IncMasterN 1))
       , ("M-S-<Down>", addName "Decrease clients in master pane" $ sendMessage (IncMasterN (-1)))
       , ("M-=", addName "Increase max # of windows for layout"   $ increaseLimit)
       , ("M--", addName "Decrease max # of windows for layout"   $ decreaseLimit)]
       
       -- Sublayouts
       -- This is used to push windows to tabbed sublayouts, or pull them out of it.
       ^++^ subKeys "Sublayouts"
       [ ("M-C-h", addName "pullGroup L"           $ sendMessage $ pullGroup L)
       , ("M-C-l", addName "pullGroup R"           $ sendMessage $ pullGroup R)
       , ("M-C-k", addName "pullGroup U"           $ sendMessage $ pullGroup U)
       , ("M-C-j", addName "pullGroup D"           $ sendMessage $ pullGroup D)
       , ("M-C-m", addName "MergeAll"              $ withFocused (sendMessage . MergeAll))
       -- , ("M-C-u", addName "UnMerge"               $ withFocused (sendMessage . UnMerge)))$)
       , ("M-C-/", addName "UnMergeAll"            $  withFocused (sendMessage . UnMergeAll))
       , ("M-C-.", addName "Switch focus next tab" $  onGroup W.focusUp')
       , ("M-C-,", addName "Switch focus prev tab" $  onGroup W.focusDown')]
       
       -- Scratchpads
       -- Toggle show/hide these programs. They run on a hidden workspace.
       -- When you toggle them to show, it brings them to current workspace.
       -- Toggle them to hide and it sends them back to hidden workspace (NSP).)


        ^++^ subKeys "Scratchpads"
        [ ("M-s t", addName "Toggle scratchpad terminal"   $ namedScratchpadAction myScratchPads "terminal")
        , ("M-s m", addName "Toggle scratchpad mocp"       $ namedScratchpadAction myScratchPads "mocp")
        , ("M-s c", addName "Toggle scratchpad calculator" $ namedScratchpadAction myScratchPads "calculator")]

        -- Controls for mocp music player (SUPER-u followed by a key)
       ^++^ subKeys "Mocp music player"
       [ ("M-u p", addName "mocp play"                $ spawn "mocp --play")
       , ("M-u l", addName "mocp next"                $ spawn "mocp --next")
       , ("M-u h", addName "mocp prev"                $ spawn "mocp --previous")
       , ("M-u <Space>", addName "mocp toggle pause"  $ spawn "mocp --toggle-pause")]

        where nonNSP          = WSIs (return (\ws -> W.tag ws /= "NSP"))
              nonEmptyNonNSP  = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "NSP"))
---}}}
--- {{{ Main
main :: IO ()
main = do
  -- Launching three instances of xmobar on their monitors.
  xmproc0 <- spawnPipe ("xmobar -x 0 $HOME/.xmobar/" ++ colorScheme ++ "-xmobarrc")
  xmproc1 <- spawnPipe ("xmobar -x 1 $HOME/.xmobar/" ++ colorScheme ++ "-xmobarrc")
  -- the xmonad, ya know...what the WM is named after!
  xmonad $ addDescrKeys' ((mod4Mask, xK_F1), showKeybindings) myKeys $ ewmh $ docks $ def
    { manageHook         = myManageHook <+> manageDocks
    , handleEventHook    = swallowEventHook (className =? "Alacritty"  <||> className =? "st-256color" <||> className =? "XTerm") (return True)
    , modMask            = myModMask
    , terminal           = myTerminal
    , startupHook        = myStartupHook
    , layoutHook         = showWName' myShowWNameTheme $ myLayoutHook
    , workspaces         = myWorkspaces
    , borderWidth        = myBorderWidth
    , normalBorderColor  = myNormColor
    , focusedBorderColor = myFocusColor
    , logHook = dynamicLogWithPP $  filterOutWsPP [scratchpadWorkspaceTag] $ xmobarPP
        { ppOutput = \x -> hPutStrLn xmproc0 x   -- xmobar on monitor 1
                        >> hPutStrLn xmproc1 x   -- xmobar on monitor 2
                        


        , ppCurrent = xmobarColor color06 "" . wrap("<box type=Bottom width=2 mb=2 color=" ++ color06 ++ ">") "</box>"
        -- Visible but not current workspace
        , ppVisible = xmobarColor color06 "" . clickable
        -- Hidden workspace
        , ppHidden = xmobarColor color05 "" . wrap("<box type=Top width=2 mt=2 color=" ++ color05 ++ ">") "</box>" . clickable
        -- Hidden workspaces (no windows)
        , ppHiddenNoWindows = xmobarColor color05 ""  . clickable
        -- Title of active window
        , ppTitle = xmobarColor color16 "" . shorten 60
        -- Separator character
        , ppSep =  "<fc=" ++ color09 ++ "> <fn=1>|</fn> </fc>"
        -- Urgent workspace
        , ppUrgent = xmobarColor color02 "" . wrap "!" "!"
        -- Adding # of windows on current workspace to the bar
        , ppExtras  = [windowCount]
        -- order of things in xmobar
        , ppOrder  = \(ws:l:t:ex) -> [ws,l]++ex++[t]
        }
    }
---}}}
