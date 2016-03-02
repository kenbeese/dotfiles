// ========================== KeySnail Init File =========================== //

// この領域は, GUI により設定ファイルを生成した際にも引き継がれます
// 特殊キー, キーバインド定義, フック, ブラックリスト以外のコードは, この中に書くようにして下さい
// ========================================================================= //
//{{%PRESERVE%
// ここにコードを入力して下さい


// 入れてるプラグイン
// bmany
// built in command as Ext
// Caret hint
// History
// HoK
// HoK ex
// k2Emacs
// NoScript Cooperation
// Tanything

plugins.options["hok.local_queries"] = [
    ["^file://.*articles.html", "span, h2, img.TagImg"],
    ["localhost:8080", "a, td.dp-comment"]
];

//==========Caret hint==========
plugins.options["hok.actions"] = [
    ['m',
     M({ja: "右クリックメニューを開く", en: "Open context menu"}),
     function (elem) {plugins.hok.openContextMenu(elem)},],
    ['S',
      M({ja: "リンク先を保存", en: "Save hint"}),
      function (elem) {plugins.hok.saveLink(elem, true)},],
];

//==========Tanything==========
plugins.options["tanything_opt.keymap"] = {
    "C-z"   : "prompt-toggle-edit-mode",
    "C-v"   : "prompt-next-page",
    "M-v"     : "prompt-previous-page",
    // "j"     : "prompt-next-completion",
    // "k"     : "prompt-previous-completion",
    // "g"     : "prompt-beginning-of-candidates",
    // "G"     : "prompt-end-of-candidates",
    "C-g"     : "prompt-cancel",
    //Tanything specific actions
    // "O"     : "localOpen",
    "M-k"     : "localClose",
    // "1"     : "localAllclose",
    // "C"     : "localClipU",
    "M-p"     : "localTogglePin",
    "M-b"     : "localAddBokmark",
};

//========K2Emacs========================

//plugins.options["K2Emacs.editor"]    = "XMODIFIERS=@im=none /usr/bin/emacs";
plugins.options["K2Emacs.editor"] = "/usr/bin/emacsclient -c";
plugins.options["K2Emacs.ext"]    = "txt";
plugins.options["K2Emacs.encode"]    = "UTF-8";
plugins.options["K2Emacs.sep"]    = "/";


// ======= history ============
shell.add(["history"], "search history",

  function(args, extra) {

    ext.exec("history-show", args.join(' '), null);

  }, { argCount: '*' }, true

);


//============== misc =====================


function focus_window (ev, arg) {
    let elem = document.commandDispatcher.focusedElement;
    if (elem) elem.blur();
    gBrowser.focus();
    _content.focus();

}

function focus_prompt (ev, arg) {
    var p = document.getElementById("keysnail-prompt");
                if (p.hidden)
                    return;
    document.getElementById("keysnail-prompt-textbox").focus();
}

ext.add("focus_window", focus_window,
        M({ja: "ウィンドウにfocus",
en: "focus window"}));

ext.add("focus_prompt", focus_prompt,
        M({ja: "プロンプトにfocus",
en: "focus prompt"}));

//}}%PRESERVE%
// ========================================================================= //

// ========================= Special key settings ========================== //

key.quitKey              = "C-g";
key.helpKey              = "<f1>";
key.escapeKey            = "C-q";
key.macroStartKey        = "<f3>";
key.macroEndKey          = "<f4>";
key.universalArgumentKey = "C-u";
key.negativeArgument1Key = "C--";
key.negativeArgument2Key = "C-M--";
key.negativeArgument3Key = "M--";
key.suspendKey           = "<f2>";

// ================================= Hooks ================================= //

hook.setHook('KeyBoardQuit', function (aEvent) {
    if (key.currentKeySequence.length) return;

    command.closeFindBar();

    let marked = command.marked(aEvent);

    if (util.isCaretEnabled()) {
        if (marked) {
            command.resetMark(aEvent);
        } else {
            if ("blur" in aEvent.target) aEvent.target.blur();
            util.setBoolPref("accessibility.browsewithcaret", false);
            gBrowser.focus();
            _content.focus();
        }
    } else {
        goDoCommand("cmd_selectNone");
    }

    if (KeySnail.windowType === "navigator:browser" && !marked) {
        key.generateKey(aEvent.originalTarget, KeyEvent.DOM_VK_ESCAPE, true);
    }
});


// ============================= Key bindings ============================== //

key.setGlobalKey('C-M-r', function (ev) {
    userscript.reload();
}, '設定ファイルを再読み込み', true);

key.setGlobalKey('M-x', function (aEvent, aArg) {
    ext.select(aArg, aEvent);
}, 'エクステ一覧');

key.setGlobalKey('M-:', function (ev) {
    command.interpreter();
}, 'JavaScript のコードを評価', true);

key.setGlobalKey(['<f1>', 'b'], function (ev) {
    key.listKeyBindings();
}, 'キーバインド一覧を表示');

key.setGlobalKey(['<f1>', 'F'], function (ev) {
    openHelpLink("firefox-help");
}, 'Firefox のヘルプを表示');

key.setGlobalKey('C-m', function (ev) {
    key.generateKey(ev.originalTarget, KeyEvent.DOM_VK_RETURN, true);
}, 'リターンコードを生成');

key.setGlobalKey([['C-l'], ['C-x', 'l']], function (ev) {
    command.focusToById("urlbar");
}, 'ロケーションバーへフォーカス', true);

key.setGlobalKey(['C-x', '1'], function (ev) {
    window.loadURI(ev.target.ownerDocument.location.href);
}, '現在のフレームだけを表示', true);

key.setGlobalKey(['C-x', 'g'], function (ev) {
    command.focusToById("searchbar");
}, '検索バーへフォーカス', true);

key.setGlobalKey(['C-x', 't'], function (ev) {
    command.focusElement(command.elementsRetrieverTextarea, 0);
}, '最初のインプットエリアへフォーカス', true);

key.setGlobalKey(['C-x', 's'], function (ev) {
    command.focusElement(command.elementsRetrieverButton, 0);
}, '最初のボタンへフォーカス', true);

key.setGlobalKey(['C-x', 'k'], function (ev) {
    BrowserCloseTabOrWindow();
}, 'タブ / ウィンドウを閉じる');

key.setGlobalKey(['C-x', 'K'], function (ev) {
    closeWindow(true);
}, 'ウィンドウを閉じる');

key.setGlobalKey(['C-x', 'n'], function (ev) {
    OpenBrowserWindow();
}, 'ウィンドウを開く');

key.setGlobalKey(['C-x', 'C-c'], function (ev) {
    goQuitApplication();
}, 'Firefox を終了', true);

key.setGlobalKey(['C-x', 'o'], function (ev, arg) {
    command.focusOtherFrame(arg);
}, '次のフレームを選択');

key.setGlobalKey(['C-x', 'C-f'], function (ev) {
    BrowserOpenFileWindow();
}, 'ファイルを開く', true);

key.setGlobalKey(['C-x', 'C-s'], function (ev) {
    saveDocument(window.content.document);
}, 'ファイルを保存', true);

key.setGlobalKey('M-w', function (ev) {
    command.copyRegion(ev);
}, '選択中のテキストをコピー', true);

key.setGlobalKey('C-s', function (ev) {
    command.iSearchForwardKs(ev);
}, 'Emacs ライクなインクリメンタル検索', true);

key.setGlobalKey('C-r', function (ev) {
    command.iSearchBackwardKs(ev);
}, 'Emacs ライクな逆方向インクリメンタル検索', true);

key.setGlobalKey(['C-c', 'u'], function (ev) {
    undoCloseTab();
}, '閉じたタブを元に戻す');

key.setGlobalKey(['C-c', 'C-c', 'C-v'], function (ev) {
    toJavaScriptConsole();
}, 'Javascript コンソールを表示', true);

key.setGlobalKey(['C-c', 'C-c', 'C-c'], function (ev) {
    command.clearConsole();
}, 'Javascript コンソールの表示をクリア', true);

key.setGlobalKey(['C-c', 'w'], function (ev, arg) {
    ext.exec("focus_window", arg);
}, 'ウィンドウにフォーカス', true);

key.setGlobalKey(['C-c', 'r'], function (ev, arg) {
    ext.exec("focus_prompt", arg);
}, 'プロンプトにフォーカス', true);

key.setGlobalKey('C-M-l', function (ev) {
    getBrowser().mTabContainer.advanceSelectedTab(1, true);
}, 'ひとつ右のタブへ');

key.setGlobalKey('C-M-h', function (ev) {
    getBrowser().mTabContainer.advanceSelectedTab(-1, true);
}, 'ひとつ左のタブへ');

key.setViewKey([['C-n'], ['j']], function (ev) {
    key.generateKey(ev.originalTarget, KeyEvent.DOM_VK_DOWN, true);
}, '一行スクロールダウン');

key.setViewKey([['C-p'], ['k']], function (ev) {
    key.generateKey(ev.originalTarget, KeyEvent.DOM_VK_UP, true);
}, '一行スクロールアップ');

key.setViewKey([['C-f'], ['.']], function (ev) {
    key.generateKey(ev.originalTarget, KeyEvent.DOM_VK_RIGHT, true);
}, '右へスクロール');

key.setViewKey([['C-b'], [',']], function (ev) {
    key.generateKey(ev.originalTarget, KeyEvent.DOM_VK_LEFT, true);
}, '左へスクロール');

key.setViewKey('M-v', function (ev) {
    goDoCommand("cmd_scrollPageUp");
}, '一画面分スクロールアップ');

key.setViewKey(['b', 'b'], function (ev, arg) {
    ext.exec("bmany-list-all-bookmarks", arg, ev);
}, 'ブックマーク');

key.setViewKey(['b', 'B'], function (ev, arg) {
    ext.exec("bmany-list-bookmarklets", arg, ev);
}, 'bmany - ブックマークレットを一覧表示');

key.setViewKey(['b', 'k'], function (ev, arg) {
    ext.exec("bmany-list-bookmarks-with-keyword", arg, ev);
}, 'bmany - キーワード付きブックマークを一覧表示');

key.setViewKey(['b', 't'], function (ev, arg) {
    ext.exec("bmany-list-bookmarks-with-tag", arg, ev);
}, 'bmany - タグ付きブックマークを一覧表示');

key.setViewKey('C-v', function (ev) {
    goDoCommand("cmd_scrollPageDown");
}, '一画面スクロールダウン');

key.setViewKey([['M-<'], ['g']], function (ev) {
    goDoCommand("cmd_scrollTop");
}, 'ページ先頭へ移動', true);

key.setViewKey([['M->'], ['G']], function (ev) {
    goDoCommand("cmd_scrollBottom");
}, 'ページ末尾へ移動', true);

key.setViewKey('l', function (ev) {
    getBrowser().mTabContainer.advanceSelectedTab(1, true);
}, 'ひとつ右のタブへ');

key.setViewKey('h', function (ev) {
    getBrowser().mTabContainer.advanceSelectedTab(-1, true);
}, 'ひとつ左のタブへ');

key.setViewKey(':', function (ev, arg) {
    shell.input(null, arg);
}, 'コマンドの実行', true);

key.setViewKey('R', function (ev) {
    BrowserReload();
}, '更新', true);

key.setViewKey('B', function (ev) {
    BrowserBack();
}, '戻る');

key.setViewKey('F', function (ev) {
    BrowserForward();
}, '進む');

key.setViewKey(['C-x', 'h'], function (ev) {
    goDoCommand("cmd_selectAll");
}, 'すべて選択', true);

key.setViewKey('f', function (ev) {
    command.focusElement(command.elementsRetrieverTextarea, 0);
}, '最初のインプットエリアへフォーカス', true);

key.setViewKey('M-p', function (ev) {
    command.walkInputElement(command.elementsRetrieverButton, true, true);
}, '次のボタンへフォーカスを当てる');

key.setViewKey('M-n', function (ev) {
    command.walkInputElement(command.elementsRetrieverButton, false, true);
}, '前のボタンへフォーカスを当てる');

key.setViewKey('e', function (aEvent, aArg) {
    ext.exec("hok-start-foreground-mode", aArg);
}, 'Hit a Hint を開始', true);

key.setViewKey('E', function (aEvent, aArg) {
    ext.exec("hok-start-background-mode", aArg);
}, 'リンクをバックグラウンドで開く Hit a Hint を開始', true);

key.setViewKey(';', function (aEvent, aArg) {
    ext.exec("hok-start-extended-mode", aArg);
}, 'HoK - 拡張ヒントモード', true);

key.setViewKey(['C-c', 'C-e'], function (aEvent, aArg) {
    ext.exec("hok-start-continuous-mode", aArg);
}, 'リンクを連続して開く Hit a Hint を開始', true);

key.setViewKey(['C-c', 'C-n'], function (ev) {
    ext.exec("noscript-show-popup");
}, 'NoScript - popup menu');

key.setViewKey('a', function (ev, arg) {
    ext.exec("tanything", arg);
}, 'タブを一覧表示', true);

key.setViewKey('N', function (ev) {
    ext.exec("noscript-selector");
}, 'NoScript - selector');

key.setEditKey(['C-x', 'h'], function (ev) {
    command.selectAll(ev);
}, '全て選択', true);

key.setEditKey([['C-x', 'u'], ['C-_']], function (ev) {
    display.echoStatusBar("Undo!", 2000);
    goDoCommand("cmd_undo");
}, 'アンドゥ');

key.setEditKey(['C-x', 'r', 'd'], function (ev, arg) {
    command.replaceRectangle(ev.originalTarget, "", false, !arg);
}, '矩形削除', true);

key.setEditKey(['C-x', 'r', 't'], function (ev) {
    prompt.read("String rectangle: ", function (aStr, aInput) {
        command.replaceRectangle(aInput, aStr);
    },
    ev.originalTarget);
}, '矩形置換', true);

key.setEditKey(['C-x', 'r', 'o'], function (ev) {
    command.openRectangle(ev.originalTarget);
}, '矩形行空け', true);

key.setEditKey(['C-x', 'r', 'k'], function (ev, arg) {
    command.kill.buffer = command.killRectangle(ev.originalTarget, !arg);
}, '矩形キル', true);

key.setEditKey(['C-x', 'r', 'y'], function (ev) {
    command.yankRectangle(ev.originalTarget, command.kill.buffer);
}, '矩形ヤンク', true);

key.setEditKey([['C-SPC'], ['C-@']], function (ev) {
    command.setMark(ev);
}, 'マークをセット', true);

key.setEditKey('C-o', function (ev) {
    command.openLine(ev);
}, '行を開く (Open line)');

key.setEditKey('C-\\', function (ev) {
    display.echoStatusBar("Redo!", 2000);
    goDoCommand("cmd_redo");
}, 'リドゥ');

key.setEditKey('C-a', function (ev) {
    command.beginLine(ev);
}, '行頭へ移動');

key.setEditKey('C-e', function (ev) {
    command.endLine(ev);
}, '行末へ');

key.setEditKey('C-f', function (ev) {
    command.nextChar(ev);
}, '一文字右へ移動');

key.setEditKey('C-b', function (ev) {
    command.previousChar(ev);
}, '一文字左へ移動');

key.setEditKey('M-f', function (ev) {
    command.forwardWord(ev);
}, '一単語右へ移動');

key.setEditKey('M-b', function (ev) {
    command.backwardWord(ev);
}, '一単語左へ移動');

key.setEditKey('C-n', function (ev) {
    command.nextLine(ev);
}, '一行下へ');

key.setEditKey('C-p', function (ev) {
    command.previousLine(ev);
}, '一行上へ');

key.setEditKey('C-v', function (ev) {
    command.pageDown(ev);
}, '一画面分下へ');

key.setEditKey('M-v', function (ev) {
    command.pageUp(ev);
}, '一画面分上へ');

key.setEditKey('M-<', function (ev) {
    command.moveTop(ev);
}, 'テキストエリア先頭へ');

key.setEditKey('M->', function (ev) {
    command.moveBottom(ev);
}, 'テキストエリア末尾へ');

key.setEditKey('C-d', function (ev) {
    goDoCommand("cmd_deleteCharForward");
}, '次の一文字削除');

key.setEditKey('C-h', function (ev) {
    goDoCommand("cmd_deleteCharBackward");
}, '前の一文字を削除');

key.setEditKey('M-d', function (ev) {
    command.deleteForwardWord(ev);
}, '次の一単語を削除');

key.setEditKey([['C-<backspace>'], ['M-<delete>']], function (ev) {
    command.deleteBackwardWord(ev);
}, '前の一単語を削除');

key.setEditKey('M-u', function (ev, arg) {
    command.wordCommand(ev, arg, command.upcaseForwardWord, command.upcaseBackwardWord);
}, '次の一単語を全て大文字に (Upper case)');

key.setEditKey('M-l', function (ev, arg) {
    command.wordCommand(ev, arg, command.downcaseForwardWord, command.downcaseBackwardWord);
}, '次の一単語を全て小文字に (Lower case)');

key.setEditKey('M-c', function (ev, arg) {
    command.wordCommand(ev, arg, command.capitalizeForwardWord, command.capitalizeBackwardWord);
}, '次の一単語をキャピタライズ');

key.setEditKey('C-k', function (ev) {
    command.killLine(ev);
}, 'カーソルから先を一行カット (Kill line)');

key.setEditKey('C-y', command.yank, '貼り付け (Yank)');

key.setEditKey('M-y', command.yankPop, '古いクリップボードの中身を順に貼り付け (Yank pop)', true);

key.setEditKey('C-M-y', function (ev) {
    if (!command.kill.ring.length)
        return;

    let ct = command.getClipboardText();
    if (!command.kill.ring.length || ct != command.kill.ring[0]) {
        command.pushKillRing(ct);
    }

    prompt.selector(
        {
            message: "Paste:",
            collection: command.kill.ring,
            callback: function (i) { if (i >= 0) key.insertText(command.kill.ring[i]); }
        }
    );
}, '以前にコピーしたテキスト一覧から選択して貼り付け', true);

key.setEditKey('C-w', function (ev) {
    goDoCommand("cmd_copy");
    goDoCommand("cmd_delete");
    command.resetMark(ev);
}, '選択中のテキストを切り取り (Kill region)', true);

key.setEditKey('M-n', function (ev) {
    command.walkInputElement(command.elementsRetrieverTextarea, true, true);
}, '次のテキストエリアへフォーカス');

key.setEditKey('M-p', function (ev) {
    command.walkInputElement(command.elementsRetrieverTextarea, false, true);
}, '前のテキストエリアへフォーカス');

key.setEditKey(['C-c', 'e'], function (ev, arg) {
    ext.exec("edit_text", arg);
}, '外部エディタで編集', true);

key.setCaretKey([['C-a'], ['^']], function (ev) {
    ev.target.ksMarked ? goDoCommand('cmd_selectBeginLine') : goDoCommand('cmd_beginLine');
}, 'キャレットを行頭へ移動');

key.setCaretKey([['C-e'], ['$']], function (ev) {
    ev.target.ksMarked ? goDoCommand('cmd_selectEndLine') : goDoCommand('cmd_endLine');
}, 'キャレットを行末へ移動');

key.setCaretKey([['C-n'], ['j']], function (ev) {
    ev.target.ksMarked ? goDoCommand('cmd_selectLineNext') : goDoCommand('cmd_lineNext');
}, 'キャレットを一行下へ', true);

key.setCaretKey([['C-p'], ['k']], function (ev) {
    ev.target.ksMarked ? goDoCommand('cmd_selectLinePrevious') : goDoCommand('cmd_linePrevious');
}, 'キャレットを一行上へ', true);

key.setCaretKey([['C-f'], ['l']], function (ev) {
    ev.target.ksMarked ? goDoCommand('cmd_selectCharNext') : goDoCommand('cmd_charNext');
}, 'キャレットを一文字右へ移動', true);

key.setCaretKey([['C-b'], ['h'], ['C-h']], function (ev) {
    ev.target.ksMarked ? goDoCommand('cmd_selectCharPrevious') : goDoCommand('cmd_charPrevious');
}, 'キャレットを一文字左へ移動', true);

key.setCaretKey([['M-f'], ['w']], function (ev) {
    ev.target.ksMarked ? goDoCommand('cmd_selectWordNext') : goDoCommand('cmd_wordNext');
}, 'キャレットを一単語右へ移動');

key.setCaretKey([['M-b'], ['W']], function (ev) {
    ev.target.ksMarked ? goDoCommand('cmd_selectWordPrevious') : goDoCommand('cmd_wordPrevious');
}, 'キャレットを一単語左へ移動');

key.setCaretKey([['C-v'], ['SPC']], function (ev) {
    ev.target.ksMarked ? goDoCommand('cmd_selectPageDown') : goDoCommand('cmd_movePageDown');
}, 'キャレットを一画面分下へ');

key.setCaretKey([['M-v'], ['b']], function (ev) {
    ev.target.ksMarked ? goDoCommand('cmd_selectPageUp') : goDoCommand('cmd_movePageUp');
}, 'キャレットを一画面分上へ');

key.setCaretKey([['M-<'], ['g']], function (ev) {
    ev.target.ksMarked ? goDoCommand('cmd_selectTop') : goDoCommand('cmd_moveTop');
}, 'キャレットをページ先頭へ移動');

key.setCaretKey([['M->'], ['G']], function (ev) {
    ev.target.ksMarked ? goDoCommand('cmd_selectBottom') : goDoCommand('cmd_moveBottom');
}, 'キャレットを行末へ移動');

key.setCaretKey('J', function (ev) {
    util.getSelectionController().scrollLine(true);
}, '画面を一行分下へスクロール');

key.setCaretKey('K', function (ev) {
    util.getSelectionController().scrollLine(false);
}, '画面を一行分上へスクロール');

key.setCaretKey(',', function (ev) {
    util.getSelectionController().scrollHorizontal(true);
    goDoCommand("cmd_scrollLeft");
}, '左へスクロール');

key.setCaretKey('.', function (ev) {
    goDoCommand("cmd_scrollRight");
    util.getSelectionController().scrollHorizontal(false);
}, '右へスクロール');

key.setCaretKey('z', function (ev) {
    command.recenter(ev);
}, 'キャレットの位置までスクロール');

key.setCaretKey([['C-SPC'], ['C-@']], function (ev) {
    command.setMark(ev);
}, 'マークをセット', true);

key.setCaretKey(':', function (ev, arg) {
    shell.input(null, arg);
}, 'コマンドの実行', true);

key.setCaretKey('R', function (ev) {
    BrowserReload();
}, '更新', true);

key.setCaretKey('B', function (ev) {
    BrowserBack();
}, '戻る');

key.setCaretKey('F', function (ev) {
    BrowserForward();
}, '進む');

key.setCaretKey(['C-x', 'h'], function (ev) {
    goDoCommand("cmd_selectAll");
}, 'すべて選択', true);

key.setCaretKey('f', function (ev) {
    command.focusElement(command.elementsRetrieverTextarea, 0);
}, '最初のインプットエリアへフォーカス', true);

key.setCaretKey('M-p', function (ev) {
    command.walkInputElement(command.elementsRetrieverButton, true, true);
}, '次のボタンへフォーカスを当てる');

key.setCaretKey('M-n', function (ev) {
    command.walkInputElement(command.elementsRetrieverButton, false, true);
}, '前のボタンへフォーカスを当てる');

key.setCaretKey('s', function (ev, arg) {
    ext.exec("swap-caret", arg, ev);
}, 'キャレットを交換', true);

key.setCaretKey('N', function (ev) {
    ext.exec("noscript-selector");
}, 'NoScript - selector');

key.setCaretKey(['C-c', 'C-n'], function (ev) {
    ext.exec("noscript-show-popup");
}, 'NoScript - popup menu');
