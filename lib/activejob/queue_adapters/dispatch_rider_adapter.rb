module ActiveJob
  module QueueAdapters
    # Adds support for DispatchRider to ActiveJob.
    class DispatchRiderAdapter
      class << self
        # @param [ActiveJob::Base] job
        def enqueue(job)
          publisher.publish destinations: Array(job.queue_name),
                            message: {
                              subject: "dispatch_rider_active_job_handler",
                              body: job.serialize
                            }
        end

        def enqueue_at(*)
          raise NotImplementedError,
                "This queueing backend does not support scheduling jobs. To "\
                "see what features are supported go to "\
                "http://api.rubyonrails.org/classes/ActiveJob/QueueAdapters.html"
        end

        private

        def publisher
          @publisher ||= ::DispatchRider::Publisher.new
        end
      end
    end
  end
end
