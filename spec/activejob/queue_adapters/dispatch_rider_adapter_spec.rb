require "spec_helper"

describe ActiveJob::QueueAdapters::DispatchRiderAdapter do
  let(:foo_job_class) {
    job_class = Class.new(ActiveJob::Base) do
      queue_as :foo

      def perform(*)
      end
    end

    stub_const "FooAjJob", job_class

    FooAjJob
  }

  let(:bar_job_class) {
    job_class = Class.new(ActiveJob::Base) do
      queue_as :bar

      def perform(*)
      end
    end

    stub_const "BarAjJob", job_class

    BarAjJob
  }

  describe "class methods" do
    subject(:adapter) { described_class }

    let(:foo_queue_path_pattern) { "tmp/queue/foo_channel/*.*" }
    let(:bar_queue_path_pattern) { "tmp/queue/bar_channel/*.*" }
    let(:foo_queued_item) { JSON.parse(File.read Dir[foo_queue_path_pattern].first) }
    let(:bar_queued_item) { JSON.parse(File.read Dir[bar_queue_path_pattern].first) }

    describe ".enqueue" do
      around do |test|
        FileUtils.rmtree "tmp/queue/"
        test.run
        FileUtils.rmtree "tmp/queue/"
      end

      it("is called when performing later") {
        expect(adapter).to receive(:enqueue).with instance_of(foo_job_class)
        foo_job_class.perform_later foo: "bar"
      }

      example("queued item") {
        foo_job_class.perform_later foo: "bar"

        expect(foo_queued_item["subject"]).to eq("foo_aj_job")
        expect(foo_queued_item["body"]["job_class"]).to eq("FooAjJob")
        expect(foo_queued_item["body"]["guid"]).to eq(foo_queued_item["body"]["job_id"])
        expect(foo_queued_item["body"]["queue_name"]).to eq("foo")
        expect(foo_queued_item["body"]["arguments"].first).to include("foo" => "bar")
      }

      describe "switching channel depending on the queue name" do
        example { expect { foo_job_class.perform_later foo: "bar" }.to change { Dir[foo_queue_path_pattern].count }.by(1) }
        example { expect { bar_job_class.perform_later foo: "bar" }.to change { Dir[bar_queue_path_pattern].count }.by(1) }
        example { expect { foo_job_class.perform_later foo: "bar" }.to_not change { Dir[bar_queue_path_pattern].count } }
      end
    end

    describe ".enqueue_at" do
      let(:job) { double :job }
      let(:timestamp) { Time.now }

      example { expect { adapter.enqueue_at job, timestamp }.to raise_error NotImplementedError }
    end
  end
end
