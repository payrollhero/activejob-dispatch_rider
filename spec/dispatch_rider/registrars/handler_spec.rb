require "spec_helper"

describe DispatchRider::Registrars::Handler do
  subject(:registrar) { described_class.new }

  example { expect(registrar.fetch "foo").to eq ActiveJob::DispatchRider::JobHandler }
end
