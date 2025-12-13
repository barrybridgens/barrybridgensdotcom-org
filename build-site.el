;; Set the package installation directory so that packages aren't stored in the
;; ~/.emacs.d/elpa path.
(require 'package)
(setq package-user-dir (expand-file-name "./.packages"))
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

;; Initialize the package system
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

;; Install dependencies
(package-install 'htmlize)

;; Load the publishing system
(require 'ox-publish)

;; Customize the HTML output
(setq org-html-validation-link nil            ;; Don't show validation link
      org-html-head-include-scripts nil       ;; Use our own scripts
      org-html-head-include-default-style nil ;; Use our own styles
      org-html-head "<link rel=\"stylesheet\" href=\"/style.css\"/>")


(defun my/org-publish-org-sitemap-format (entry style project)
  "Custom sitemap entry formatting: add date"
  (format "[[file:%s][%s]] (%s)\n"
          entry
	  (org-publish-find-title entry project)
	  (format-time-string "%Y-%m-%d"
                              (org-publish-find-date entry project))))

(setq org-publish-project-alist
      `(("pages"
         :base-directory "./content/"
         :base-extension "org"
         :recursive nil
	 :with-toc nil
	 :section-numbers nil
	 :time-stamp-file nil
         :publishing-directory "./public"
	 :html-postamble "<hr/><footer>Author: Barry Bridgens<br><nav> <a href=\"/\">&lt; Home</a></nav><div id=\"updated\">Updated: %C</div><hr></footer>"
         :publishing-function org-html-publish-to-html)

        ("static"
         :base-directory "./content/"
         :base-extension "css\\|txt"
         :recursive t
         :publishing-directory  "./public"
         :publishing-function org-publish-attachment)

	("images"
         :base-directory "./content/"
         :base-extension "jpg\\|gif\\|png"
         :recursive nil
         :publishing-directory  "./public/images"
         :publishing-function org-publish-attachment)

	("photos"
	 :base-directory "./content/photos/"
	 :base-extension "org"
	 :with-toc nil
	 :section-numbers nil
	 :time-stamp-file nil
	 :publishing-directory "./public/photos"
	 :html-postamble "<hr/><footer>Author: Barry Bridgens<br><nav> <a href=\"/\">&lt; Home</a></nav><div id=\"updated\">Updated: %C</div><hr></footer>"
	 :publishing-function org-html-publish-to-html

	 :auto-sitemap t
	 :sitemap-title "Photo Galleries"
	 :sitemap-filename "index.org"
	 :sitemap-format-entry my/org-publish-org-sitemap-format
	 :sitemap-sort-files anti-chronologically)

	
	("blog"
	 :base-directory "./content/blog/"
	 :base-extension "org"
	 :with-toc nil
	 :section-numbers nil
	 :time-stamp-file nil
	 :publishing-directory "./public/blog"
	 :html-postamble "<hr/><footer>Author: Barry Bridgens<br><nav> <a href=\"/\">&lt; Home</a></nav><div id=\"updated\">Updated: %C</div><hr></footer>"
	 :publishing-function org-html-publish-to-html

	 :auto-sitemap t
	 :sitemap-title "Blog Posts"
	 :sitemap-filename "index.org"
	 :sitemap-format-entry my/org-publish-org-sitemap-format
	 :sitemap-sort-files anti-chronologically)

	("blog-images"
         :base-directory "./content/blog/images"
         :base-extension "jpg\\|gif\\|png"
         :recursive nil
         :publishing-directory  "./public/blog/images"
         :publishing-function org-publish-attachment)	

        ("org-site" :components ("pages" "blog" "static" "images"))))

;; Generate the site output
(org-publish-all t)

(message "Build complete!")
