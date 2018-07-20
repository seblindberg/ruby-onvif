# frozen_string_literal: true

require 'test_helper'
require 'onvif/version'

describe ONVIF do
  it 'has a version number' do
    refute_nil ::ONVIF::VERSION
  end
end
