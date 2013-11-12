require_relative 'spec_helper'

describe Capsuleer do

  describe "#new" do
    context "with no parameters" do
      it "is invalid" do
        Capsuleer.new.should_not_be :valid?
      end
    end

  end
end