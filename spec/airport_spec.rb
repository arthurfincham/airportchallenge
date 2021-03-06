require 'airport' 

describe Airport do
  let(:plane) { Plane.new }
  subject(:airport) { described_class.new }

  describe '#config' do
    it 'can change capacity' do
      airport = Airport.new(10)
      expect(airport.capacity).to eq 10
    end
  end

  describe '#landing' do
    before do
      allow(plane).to receive(:land)
    end

    context 'weather is sunny' do
      before do
        allow(airport).to receive(:stormy?).and_return(false)
      end

      it 'is permitted when sunny' do
        subject.land(plane)
        expect(subject.tarmac).to include(plane)
      end
      
      it 'is denied if capacity is full' do
        allow(airport).to receive(:full?).and_return(true)
        expect { subject.land(plane) }.to raise_error('Tarmac is full.')
      end
    end

    context 'weather is stormy' do
      it 'is denied if stormy' do
        allow(airport).to receive(:stormy?).and_return(true)
        expect { subject.land(plane) }.to raise_error('Treacherous conditions. Stay put.')
      end
    end
  end

  describe "#take_off" do

    before do
      allow(plane).to receive(:take_off)
      allow(airport).to receive(:stormy?).and_return(false)
      subject.land(plane)
    end

    context 'weather is sunny' do
      it 'planes can take off' do
        subject.take_off(plane)
        expect(subject.tarmac).to_not include(plane)
      end

      it 'can confirm that the plane has taken off' do
        subject.take_off(plane)
        expect(subject.confirm(plane)).to eq 'Flying high!'
      end
    end

    context 'weather is stormy' do
      it 'planes cannot take off' do
        allow(airport).to receive(:stormy?).and_return(true)
        expect { subject.take_off(plane) }.to raise_error('Stormy. Cannot take off.')
      end
    end
  end
end
