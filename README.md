[![Build Status](https://travis-ci.org/rchukh/chamber-solr.svg)](https://travis-ci.org/rchukh/chamber-solr)

Description
===========

Installs solr and manage cores with LWRP

Requirements
============

Chef 0.11.0 or higher required.

Support Solr 4.8+ only:

- Cores autodiscovery;
- Requires JDK 7;

Platforms:

- Centos (tested on 6.5)

Attributes
==========

### Required Attributes

| Attribute  | Description |
| ------------- | ------------- |
| ```node[:chamber][:solr][:user]``` | Solr war user ownership | 
| ```node[:chamber][:solr][:group]``` | Solr war group ownership | 
| ```node[:chamber][:solr][:path]``` | Solr path to place war file | 


### Custom Attributes

| Attribute  | Description | [Default](attributes/default.rb) |
| ------------- | ------------- | ------------- |
| ```node[:chamber][:solr][:version]``` | Solr version (only 4.8+ are supported) | ```4.8.0``` |
| ```node[:chamber][:solr][:home]``` | Solr home | ```/usr/local/solr/```  |
| ```node[:chamber][:solr][:custom_war_path]``` | Solr custom war path (uses cookbook_file) | None. |
| ```node[:chamber][:solr][:url]``` | Solr distribution URL | See [defaults](attributes/default.rb) |
| ```node[:chamber][:solr][:archive_war_path]``` | Solr war path within distribution | See [defaults](attributes/default.rb) |


Usage
=====

    include_recipe "chamber-solr"

Resources/Providers
===================

chamber-solr
--------

### Actions

| Attribute  | Description | 
| ------------- | ------------- | 
| ```create``` | create a solr core |


### Attribute Parameters

| Attribute  | Description | Default |
| ------------- | ------------- | ------------- |
| ```name``` | Name of the Solr core | name attribute |
| ```directory``` | Directory with Solr core configuration (within cookbook files path) | name attribute |
| ```cookbook``` | ```directory``` cookbook | current cookbook |


## License and Authors

```text
Copyright 2014, Roman Chukh (<roman.chukh@gmail.com>)

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
