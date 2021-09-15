# `lf` configuration files

## Image preview

**NOTE:** *ueberzug will use a lot of memory (up to 2GB+. I think it a bug, at least a flaw, but the author doesn't think so) if previewing a lot of large images. So, either you be OK with that, or go implement thumbnails in your lf config, or not use image preview at all.*

Lf has a [Preview wiki page](https://github.com/gokcehan/lf/wiki/Previews) about how to preview with ueberzug. Refer to that as well.

![lf-ueberzug-preview](https://user-images.githubusercontent.com/12032219/103355663-c0f43f80-4ae9-11eb-9627-a70f8cec5d1c.gif)

Image preview works great after [this commit](https://github.com/gokcehan/lf/commit/82f03102a51fc192b69cd9d7cc52fac9f2c67211). Before that all solutions have problems like image not cleaned or not updated. Now you have the perfect image preview in `lf`!

### What need to be done

1. Start `ueberzug` before `lf` and kill `ueberzug` when exiting `lf`.

   See my overridden [lf script](.local/bin/lf).

2. Send commands to `ueberzug` in a script. I am using *json* parser style because I am using `sh`, go to [Brodie's dotfiles](https://github.com/BrodieRobertson/dotfiles) for `bash` version.

   See [preview-image](.local/bin/preview-image) script.

3. Image preview in the preview script. Note:
   - After the new commit, preview region's position and dimension are passed from `lf`, use them directly.
   - Return 1 in the preview script to disable preview cache for images, this will refresh image previews.

   See [the `pv` script](.local/bin/pv) => `image/*`.

4. Specify a clean script in `lfrc`. I am using the same [preview-image](.local/bin/preview-image) to preview and clean images.

   See [lfrc](.config/lf/lfrc) => `set cleaner`.
