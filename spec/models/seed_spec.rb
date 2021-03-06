require 'spec_helper'

describe "Seed" do
  let(:link) { "http://foo.com" }
  let(:amount) { 10000 }
  let(:user_id) { 100 }
  
  describe "#reseed" do
    context "given donation information" do
      it "the created seed is connected to another seed" do
        parent = double(:seed)
        child = double(:seed)
        reseeds = double(:reseeds)
        
        Seed.should_receive(:plant).with(user_id, 10000).and_return(child)
        Seed.should_receive(:find).with(:link => link).and_return(parent)
        
        parent.stub(:outgoing).and_return(reseeds)
        reseeds.should_receive(:<<).with(child)                                    
        parent.should_receive(:save)     
        Seed.reseed(user_id, link, 10000)
      end
    end
  end

  describe "#plant" do
    it "attaches a pledge" do
      Seed.stub(:generate_link).and_return(link)
      donation = double(:donation, amount_cents: amount)
      seed = double(:seed, link: link)
      Seed.stub(:create).with(:user_id => user_id, :link => link).and_return(seed)
      Seed.stub(:create_donation).with(amount).and_return(donation)
      seed.should_receive(:pledge=).with(donation)
      seed.should_receive(:save)
      Seed.plant(user_id, amount)
    end

  end
end