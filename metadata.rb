name             "chamber-solr"
maintainer       "Roman Chukh"
maintainer_email "roman.chukh@gmail.com"
license          "Apache 2.0"
description      "Installs and configures solr"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.1.1"

supports 		 "centos"

depends          "chef-sugar"
depends          "ark"
depends          "maven"
