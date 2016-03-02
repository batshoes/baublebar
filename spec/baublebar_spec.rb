RSpec.describe Baublebar::GetTickets do
  context "when email is received" do
    let(:email) {"email@email.com"}
    let(:correct_response) {"{
                              id: 1,
                              name: 'Joe Bloggs',
                              other_information: 'chatlog/email/etc'
                              }"
                            }

    before do
      allow_any_instance_of(NewTicketRequest)
        .to receive(:call)
          .and_return(correct_response)
    end

    subject do
      described_class.new(email)
    end
  end
end