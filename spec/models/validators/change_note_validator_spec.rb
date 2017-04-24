require "spec_helper"

RSpec.describe ChangeNoteValidator do
  subject(:validatable) {
    ChangeNoteValidator.new(section)
  }

  let(:section) {
    double(
      :section,
      change_note: change_note,
      minor_update?: minor_update,
      published?: published,
      errors: section_errors,
      valid?: section_valid,
    )
  }

  let(:change_note) { nil }
  let(:minor_update) { false }
  let(:published) { false }
  let(:section_errors) {
    double(
      :section_errors_uncast,
      to_hash: section_errors_hash,
    )
  }
  let(:section_errors_hash) { {} }
  let(:section_valid) { false }

  describe "#valid?" do
    context "when the underlying section is not valid" do
      before do
        allow(section).to receive(:valid?).and_return(false)
      end

      it "is not valid" do
        expect(validatable).not_to be_valid
      end
    end

    context "when the section is otherwise valid" do
      before do
        allow(section).to receive(:valid?).and_return(true)
      end

      context "when the section has never been published" do
        let(:published) { false }

        it "is valid without a change note" do
          expect(validatable).to be_valid
        end
      end

      context "when the section has been published" do
        let(:published) { true }
        context "when the section has a change note" do
          let(:change_note) { "Awesome update!" }

          it "is valid" do
            expect(validatable).to be_valid
          end
        end

        context "when the section does not have a change note" do
          context "when the update is minor" do
            let(:minor_update) { true }

            it "is valid" do
              expect(validatable).to be_valid
            end
          end

          context "when the update is not minor" do
            let(:minor_update) { false }

            it "calls #valid? on the section" do
              validatable.valid?

              expect(section).to have_received(:valid?)
            end

            it "is not valid" do
              expect(validatable).not_to be_valid
            end
          end
        end
      end
    end
  end

  describe "#errors" do
    context "when a change note is missing" do
      let(:change_note) { nil }
      let(:minor_update) { false }
      let(:published) { true }

      before do
        validatable.valid?
      end

      it "returns an error string for that field" do
        expect(validatable.errors.fetch(:change_note))
          .to eq(["You must provide a change note or indicate minor update"])
      end

      context "when the underlying section has errors" do
        let(:section_errors_hash) {
          {
            another_field: ["is not valid"],
          }
        }

        it "combines all errors" do
          expect(validatable.errors.fetch(:another_field))
            .to eq(["is not valid"])
        end
      end
    end

    context "transitioning from invalid to valid" do
      let(:change_note) { nil }
      let(:minor_update) { false }
      let(:published) { true }
      let(:section_valid) { true }

      before do
        validatable.valid?
        allow(section).to receive(:change_note).and_return("Updated")
        validatable.valid?
      end

      it "resets the errors, returning an empty hash" do
        expect(validatable.errors).to eq({})
      end
    end
  end
end
