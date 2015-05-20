require "active_job"
require "dispatch-rider"

module ActiveJob
  module DispatchRider
  end
end

require_relative "dispatch_rider/version"
require_relative "dispatch_rider/job_handler"
require_relative "dispatch_rider/handler_registrar_fallback"
require_relative "queue_adapters/dispatch_rider_adapter"

# Handle all unregistered messages as messages coming from ActiveJobs.
DispatchRider::Registrars::Handler.prepend ActiveJob::DispatchRider::HandlerRegistrarFallback
