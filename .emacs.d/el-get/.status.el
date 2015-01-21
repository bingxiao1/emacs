((auto-complete status "installed" recipe
		(:name auto-complete :website "https://github.com/auto-complete/auto-complete" :description "The most intelligent auto-completion extension." :type github :pkgname "auto-complete/auto-complete" :depends
		       (popup fuzzy)))
 (ctable status "installed" recipe
	 (:name ctable :description "Table Component for elisp" :type github :pkgname "kiwanami/emacs-ctable"))
 (deferred status "installed" recipe
   (:name deferred :description "Simple asynchronous functions for emacs lisp" :website "https://github.com/kiwanami/emacs-deferred" :type github :pkgname "kiwanami/emacs-deferred" :features "deferred"))
 (el-get status "installed" recipe
	 (:name el-get :website "https://github.com/dimitri/el-get#readme" :description "Manage the external elisp bits and pieces you depend upon." :type github :branch "4.stable" :pkgname "dimitri/el-get" :info "." :load "el-get.el"))
 (epc status "installed" recipe
      (:name epc :description "An RPC stack for Emacs Lisp" :type github :pkgname "kiwanami/emacs-epc" :depends
	     (deferred ctable)))
 (fuzzy status "installed" recipe
	(:name fuzzy :website "https://github.com/auto-complete/fuzzy-el" :description "Fuzzy matching utilities for GNU Emacs" :type github :pkgname "auto-complete/fuzzy-el"))
 (hide-lines status "installed" recipe
	     (:name hide-lines :auto-generated t :type emacswiki :description "Commands for hiding lines based on a regexp" :website "https://raw.github.com/emacsmirror/emacswiki.org/master/hide-lines.el"))
 (icicles status "installed" recipe
	  (:name icicles :auto-generated t :type emacswiki :description "Minibuffer input completion and cycling." :website "https://raw.github.com/emacsmirror/emacswiki.org/master/icicles.el"))
 (jedi status "installed" recipe
       (:name jedi :description "An awesome Python auto-completion for Emacs" :type github :pkgname "tkf/emacs-jedi" :build
	      (("make" "requirements"))
	      :build/berkeley-unix
	      (("gmake" "requirements"))
	      :submodule nil :depends
	      (epc auto-complete)))
 (jira status "installed" recipe
       (:name jira :auto-generated t :type emacswiki :description "Connect to JIRA issue tracking software" :website "https://raw.github.com/emacsmirror/emacswiki.org/master/jira.el"))
 (popup status "installed" recipe
	(:name popup :website "https://github.com/auto-complete/popup-el" :description "Visual Popup Interface Library for Emacs" :type github :pkgname "auto-complete/popup-el"))
 (xml-rpc status "installed" recipe
	  (:name xml-rpc :auto-generated t :type emacswiki :description "An elisp implementation of clientside XML-RPC" :website "https://raw.github.com/emacsmirror/emacswiki.org/master/xml-rpc.el")))
