# frozen_string_literal: true

require 'ipaddr'
require 'logger'
require 'socket'
require 'webrick/config'
require 'webrick/httpresponse'
require 'webrick/httprequest'

require 'onvif/error'

require 'onvif/service'
require 'onvif/service/discovery'
require 'onvif/service/http'
require 'onvif/service/soap'

require 'onvif/server'

# This library implements a server that tries to comply with ONVIF camera
# profile S.
module ONVIF
end
