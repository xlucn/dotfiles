Configuration files for vi/ex, vim and neovim

## EX/VI Resources

In the late 80s and early 90s, there were a lot of information around ex/vi.
Here lists some important ones that I have found.

- An Introduction to Display Editing with Vi, by William Joy (creator of vi).

  [FreeBSD website][viin1].
  [SourceForge website][viin2], with a correction to the text.

- EX/VI archive by Ove Ruben R Olsen, the biggest archive on ex/vi.
  Originally at ftp://alf.uib.no/pub/vi.

  [Web Archive][alf], some files such as docs seem not to be archived.

- Sven Guckes' [collection][guckes], the original vi-editor.org.

  [Web Archive][guckes1].

- The vi Lovers Home Page

  [Web Archive][vilover].

- Usenet group comp.editors discussions. Ex/vi related discussions are mainly
  in 80s and 90s. Now available in:

  [Google Groups][ggroup].
  [Usenet Archives][usenet].
  [Internet Archive][webarc].

  Download from Internet Archive the `comp.editors.mbox.zip` file and run

  ```sh
  unzip -p comp.editors.mbox.zip | awk '{
    if ($0 ~ /^From / && substr($0,6) !~ /^[-0-9]+$/) print ">" $0; else print
  }' > comp.editors.mbox
  ```

  This correctly escapes non-header "From " lines, generating a mbox file that
  can be imported into email clients.

- Other webpages with links.
  - https://www1.udel.edu/topics/os/unix/package/vi/intro.html
  - https://beausanders.org/main/learn-the-vi-vim-editor/
  - https://elvis.the-little-red-haired-girl.org/elvislinks/index.html

[alf]: https://web.archive.org/http://ringtail.its.monash.edu.au/pub/vi/
[ggroup]: https://groups.google.com/g/comp.editors
[guckes]: http://www.math.fu-berlin.de/~guckes/vi/
[guckes1]: http://web.archive.org/web/20210425113318/http://www.guckes.net/vi/
[usenet]: https://usenetarchives.com/threads.php?id=comp.editors
[viin1]: https://docs-archive.freebsd.org/44doc/usd/12.vi/paper.html
[viin2]: https://ex-vi.sourceforge.net/viin/paper.html
[vilover]: https://web.archive.org/web/20110429231621/http://thomer.com/vi/vi.html
[webarc]: https://archive.org/details/usenet-comp
