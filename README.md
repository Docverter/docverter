# Docverter Server

Docverter is a document conversion server with an HTTP interface. It wrap the following open source software in a JRuby app:

* [Pandoc](http://johnmacfarlane.net/pandoc/) for plain text to HTML and ePub conversion
* [Flying Saucer](http://code.google.com/p/flying-saucer/) for HTML to PDF
* [Calibre](http://calibre-ebook.com/) for ePub to MOBI conversion

## Installation

Installing on Heroku is the easiest option. Simply clone the repo, create an app, and push:

    $ git clone https://github.com/docverter/docverter.git
    $ cd docverter
    $ heroku create --buildpack https://github.com/ddollar/heroku-buildpack-multi
    $ heroku config:add PATH=bin:/app/bin:/app/jruby/bin:/usr/bin:/bin
    $ git push heroku master
    
If you'd like to install locally, first ensure that Jruby, Pandoc and Calibre are installed and available. Then (for Ubuntu):

    $ jruby -S gem install foreman
    $ git clone https://github.com/docverter/docverter.git
    $ cd docverter
    $ sudo foreman export upstart /etc/init -u <some app user> -a docverter -l /var/log/docverter
    $ sudo service docverter start
    
Other distributions will be similar. See the documentation for [Foreman](http://ddollar.github.com/foreman/) for other
distributions.

## Usage

See `doc/api.md` and [Docverter Ruby](https://github.com/docverter/docverter-ruby) for usage documentation.
