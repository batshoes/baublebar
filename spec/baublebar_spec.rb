RSpec.describe Baublebar::GetZenDeskTickets do
  context "when email is received" do
    let(:email) {"email@email.com"}
    let(:ticket_response) {[
                            {
                              url: "https://someurl.com/11.json",
                              id: 11,
                              description: "Chat Log: chat chat chat",
                              requester_id: "12345678",
                              result_type: "ticket",
                              zendesk_url: "https://someurl.com/11"
                            },
                            {
                              url: "https://someurl.com/9.json",
                              id: 11,
                              description: "Chat Log: chat chat chat",
                              requester_id: "12345678",
                              result_type: "ticket",
                              zendesk_url: "https://someurl.com/9"
                            },
                            {
                              url: "https://someurl.com/8.json",
                              id: 11,
                              description: "Chat Log: chat chat chat",
                              requester_id: "12345678",
                              result_type: "ticket",
                              zendesk_url: "https://someurl.com/8"
                            }
                          ]}


    let(:raw_user_response) {'{"users"=>[{ "id"=>4980494598,"url"=>"https://testapp1.zendesk.com/api/v2/users/4980494598.json","name"=>"Barry Allen","email"=>"email@email.com","created_at"=>2016-02-24 20:59:42 UTC,"updated_at"=>2016-02-24 20:59:42 UTC,"time_zone"=>"Bogota","phone"=>nil,"photo"=>nil,"chat_only"=>false,"user_fields"=>{}}],"next_page"=>nil,"previous_page"=>nil,"count"=>1}'}

    before do
      allow_any_instance_of(GetTicketRequest)
        .to receive(:call)
          .and_return(ticket_response)

      allow_any_instance_of(GetUserRequest)
        .to receive(:call)
          .and_return(raw_user_response.to_json)
      
    end

    subject do
      described_class.new.get_tickets(email)
    end

    it {expect(subject).to eq ticket_response}
    it {expect(subject.length).to eq 3}
    it {expect(subject.kind_of? Array).to eq true}
    it {expect(subject[0].kind_of? Hash).to eq true}
  end

  context "when less than 3 tickets are available" do
    let(:email) {"email_with_two_tickets@email.com"}
    let(:ticket_response) {[
                            {
                              url: "https://someurl.com/11.json",
                              id: 11,
                              description: "Chat Log: chat chat chat",
                              requester_id: "12345678",
                              result_type: "ticket",
                              zendesk_url: "https://someurl.com/11"
                            },
                            {
                              url: "https://someurl.com/9.json",
                              id: 11,
                              description: "Chat Log: chat chat chat",
                              requester_id: "12345678",
                              result_type: "ticket",
                              zendesk_url: "https://someurl.com/9"
                            }
                          ]}
    let(:no_tickets) { "No Tickets Available"}
    let(:two_ticket_user_response) {'{"users"=>[{ "id"=>12345}]}'}

    before do
      allow_any_instance_of(GetTicketRequest)
        .to receive(:call)
          .and_return(ticket_response)

      allow_any_instance_of(GetUserRequest)
        .to receive(:call)
          .and_return(two_ticket_user_response.to_json)
        
    end

    subject do
      described_class.new.get_tickets(email)
    end

    it {expect(subject).to eq ticket_response}
    it {expect(subject.length).to be < 3}
    #when before do is turned off, this will cause errors. As email does not exist.
    
  end

  context "when no user is available" do
    let(:email) {"new_email@email.com"}
    let(:no_user) {{"users"=>[], "next_page"=>nil, "previous_page"=>nil, "count"=>0}}

    before do

      allow_any_instance_of(GetUserRequest)
        .to receive(:call)
          .and_return(no_user)
        
    end

    subject do
      described_class.new.get_tickets(email)
    end

    it {expect(subject).to eq "No User Available..."}
  end
end