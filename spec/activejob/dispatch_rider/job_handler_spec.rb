require "spec_helper"

describe ActiveJob::DispatchRider::JobHandler do

  let!(:job_class) {
    job_class = Class.new(ActiveJob::Base) do
      queue_as :foo

      def perform(foo:)
        "foo is #{foo}"
      end
    end

    stub_const "AjJob", job_class

    AjJob
  }

  let(:job_data) {
    {
      "job_class" => "AjJob",
      "job_id" => "8b71ac6b-2854-4287-8d1b-15085b70280b",
      "queue_name" => "foo",
      "arguments" => [
        {
          "foo" => "bar",
          "_aj_symbol_keys" => ["foo"]
        }
      ],
      "guid" => "8b71ac6b-2854-4287-8d1b-15085b70280b",
    }
  }

  subject(:job_handler) { described_class.new }

  it("performs the job") { expect(job_handler.process job_data).to eq "foo is bar" }
end
