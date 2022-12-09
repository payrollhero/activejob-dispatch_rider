module ActiveJob
  module QueueAdapters
    # Adds support for DispatchRider to ActiveJob.
    class DispatchRiderAdapter
        # @param [ActiveJob::Base] job
        def enqueue(job)
          publisher.publish **job_details_for(job)
        end

        # @param [ActiveJob::Base] job
        # @param [Float] scheduled_at - float representing time (blame AJ)
        def enqueue_at(job, scheduled_at)
          scheduled_job_details = job_details_for(job).merge(scheduled_at: Time.at(scheduled_at))

          ::DispatchRider::ScheduledJob.create! **scheduled_job_details
        end

        private

        def publisher
          @publisher ||= ::DispatchRider::Publisher.new
        end

        def job_details_for(job)
          {
            destinations: Array(job.queue_name),
            message: {
              subject: job.class.name.underscore,
              body: job.serialize.merge(guid: job.job_id)
            }
          }
        end
    end
  end
end
