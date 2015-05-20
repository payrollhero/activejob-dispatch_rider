module ActiveJob
  module DispatchRider
    # This module is prepended to `DispatchRider::Registrars::Handler` to allow it to cover any
    # ActiveJob messages. The assumption is that if the message's subject doesn't have a registered
    # native `DispatchRider::Handler` then the job is delegated to
    # `ActiveJob::DispatchRider::JobHandler`. `ActiveJob::DispatchRider::JobHandler` essentially
    # just let ActiveJob process the message as it would process them normally.
    module HandlerRegistrarFallback
      def fetch(*)
        super
      rescue ::DispatchRider::NotRegistered
        JobHandler
      end
    end
  end
end
