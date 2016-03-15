# Rmagic on OSX
Installing the rmagic gem which requires image magic on osx.

Uninstall current version of ImageMagick if its already installed and giving you grief.
```
brew uninstall imagemagick
```

Reinstall imagemagick without openmp support (this is the library responsible for lgomp)
```
brew install imagemagick --disable-openmp
```

Install rmagick
```
gem install rmagick
```

### Thanks
http://stackoverflow.com/questions/13963404/rails-and-os-x-how-to-install-rmagick
