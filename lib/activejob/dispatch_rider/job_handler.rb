module ActiveJob
  module DispatchRider
    # Generic DispatchRider handler for ActiveJob.
    class JobHandler < ::DispatchRider::Handlers::Base
      def process(job_data)
        ::ActiveJob::Base.execute job_data
      end
    end
  end
end
