# Configure Rails Environment
ENV['RAILS_ENV'] = 'spec'

SPEC_DIR = __dir__
ROOT_DIR = File.expand_path(File.join(SPEC_DIR, '..'))
LIB_DIR = File.expand_path(File.join(ROOT_DIR, 'lib'))

$LOAD_PATH.unshift(SPEC_DIR)
$LOAD_PATH.unshift(LIB_DIR)
$LOAD_PATH.uniq!

require 'google/maps/services'
