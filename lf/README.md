# `lf` configuration files

## Image preview

![lf-ueberzug-preview](https://user-images.githubusercontent.com/12032219/103355663-c0f43f80-4ae9-11eb-9627-a70f8cec5d1c.gif)

Image preview works great after [this commit](https://github.com/gokcehan/lf/commit/82f03102a51fc192b69cd9d7cc52fac9f2c67211). Before that all solutions have problems like image not cleaned or not updated. Now you have the perfect image preview in `lf`!

### How to do it

1. Start `ueberzug` before `lf` and kill `ueberzug` when exiting `lf`.

   See my overridden [lf script](.local/bin/lf).

2. Send commands to `ueberzug` in a script. I am using *simple* parser style because I am using `sh`, go to [Brodie's dotfiles](https://github.com/BrodieRobertson/dotfiles) for `bash` version.

   See [preview-image](.local/bin/preview-image) script.

3. Image preview in the preview script. Note:
   - After the new commit, preview region's position and dimension are passed from `lf`, use them directly
   - Use exit 1 to disable preview cache for images to avoid the not updating or not cleaned issues

   See [the `pv` script](.local/bin/pv).

4. Specify a clean script in `lfrc`

   See [lfrc](.config/lf/lfrc).
