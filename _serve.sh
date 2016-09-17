#!/bin/bash

rm -r _site/
bundle exec jekyll serve --config _config.yml,_config_dev.yml --incremental

# jekyll serve --config _config.yml,_config_dev.yml --incremental