# torasup.info

[![Build Status](https://travis-ci.org/dwilkie/torasup.info.svg)](https://travis-ci.org/dwilkie/torasup.info)

Source code for [torasup.info](http://torasup.info)

## Installation

To contribute, first [fork the project on Github](https://help.github.com/articles/fork-a-repo/).

And then execute:

```
$ bundle install --path vendor
```

Finally run the tests

```
$ bundle exec rake
```

You can boot the development server with:

```
$ bundle exec foreman start web
```

## Contributing

[torasup.info](http://torasup.info) uses the [torasup gem](https://github.com/dwilkie/torasup) in order to lookup phone number data. To add phone number data for new countries or new operators, open up a pull request over there.

If you'd like to contribute to the look and feel of [torasup.info](http://torasup.info) you can open a pull request here.
